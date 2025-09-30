/**
 *****************************************************************************************
 *
 * @file ble_4g_protocol.c
 *
 * @brief 4G Protocol Handler Implementation File
 *
 *****************************************************************************************
 * @attention
  #####Copyright (c) 2019 GOODIX
  All rights reserved.
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "ble_4g_protocol.h"
#include "user_app.h"
#include "sensor_data_parser.h"
#include "cJSON.h"
#include "app_log.h"
#include "app_error.h"
#include "app_uart.h"
#include "board_SK.h"
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "app_timer.h"        // 为了使用定时器相关函数
#include <stdlib.h>           // 为了使用 free 函数
#include "grx_sys.h"          // 为了使用 sdk_err_t 类型
/*
 * DEFINES
 *****************************************************************************************
 */
#define DEBUG_TAG                   "[4G_PROTOCOL]"
#define JSON_BUFFER_SIZE            1024
#define DEVICE_ID_SIZE              32

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static ble_4g_sensor_data_t s_current_sensor_data_4g = {0};
static ble_4g_device_info_t s_device_info = {0};
static ble_4g_status_info_t s_status_info = {0};
static ble_4g_param_settings_t s_param_settings = {0};
static bool s_protocol_initialized = false;
static char s_device_id[DEVICE_ID_SIZE] = {0};

// 定时器定义
static app_timer_id_t m_sensor_collect_timer;
static app_timer_id_t m_data_report_timer;

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */



/**
 *****************************************************************************************
 * @brief Get device ID (MAC address).
 *****************************************************************************************
 */
static void ble_4g_protocol_get_device_id(void)
{
    // 获取设备MAC地址作为设备ID
    uint8_t mac_addr[6] = {0};
    // TODO: 实际获取MAC地址的函数调用
    // ble_gap_addr_get(mac_addr);
    
    // 暂时使用固定MAC地址
    mac_addr[0] = 0x12; mac_addr[1] = 0x34; mac_addr[2] = 0x56;
    mac_addr[3] = 0x78; mac_addr[4] = 0x9A; mac_addr[5] = 0xBC;
    
    snprintf(s_device_id, sizeof(s_device_id), "%02X:%02X:%02X:%02X:%02X:%02X",
             mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
    
    APP_LOG_INFO("%s Device ID: %s", DEBUG_TAG, s_device_id);
}

/**
 *****************************************************************************************
 * @brief Initialize device information.
 *****************************************************************************************
 */
static void ble_4g_protocol_init_device_info(void)
{
    strcpy(s_device_info.device_id, s_device_id);
    strcpy(s_device_info.device_ver, "1.0.0");
}

/**
 *****************************************************************************************
 * @brief Initialize status information.
 *****************************************************************************************
 */
static void ble_4g_protocol_init_status_info(void)
{
    s_status_info.device_water = 0;        // 未水浸
    s_status_info.sensor_status = 0;       // 传感器正常
    s_status_info.device_move = 0;         // 位置正常
    s_status_info.device_LTE_signal = 25;  // 4G信号值
    s_status_info.device_GPS_status = 0;   // GPS正常
}

/**
 *****************************************************************************************
 * @brief Initialize parameter settings.
 *****************************************************************************************
 */
static void ble_4g_protocol_init_param_settings(void)
{
    s_param_settings.device_collect_time = 1;     // 默认1分钟检测周期
    s_param_settings.device_updata_time = 5;      // 默认5分钟上报周期
    s_param_settings.methane_threshold = 1.0f;    // 默认1%vol甲烷阈值
    s_param_settings.TEMPH_threshold = 50;        // 默认50°C高温阈值
    s_param_settings.TEMPL_threshold = -20;       // 默认-20°C低温阈值
    s_param_settings.water_threshold = 0;         // 默认水浸阈值
}

/**
 *****************************************************************************************
 * @brief Create JSON data report (code 105).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_data_report_json(const ble_4g_sensor_data_t *p_data)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    if (json == NULL || header == NULL || body == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_DATA_REPORT);
    cJSON_AddStringToObject(header, "device_ID", s_device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 使用特殊字段让4G模块自动转换
    char methane_str[32];
    snprintf(methane_str, sizeof(methane_str), "%.1f,%.1f", 
             p_data->methane_vol, p_data->methane_lel);
    cJSON_AddStringToObject(body, "sensor_methane", methane_str);
    
    cJSON_AddNumberToObject(body, "sensor_TEMP", p_data->temperature);
    
    char battery_str[32];
    snprintf(battery_str, sizeof(battery_str), "%.3f,%d", 
             p_data->battery_voltage, p_data->battery_percent);
    cJSON_AddStringToObject(body, "sensor_battery", battery_str);
    
    cJSON_AddStringToObject(body, "collect_time", p_data->collect_time);
    
    cJSON_AddItemToObject(json, "body", body);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON device info report (code 102).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_device_info_json(void)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    if (json == NULL || header == NULL || body == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_DEVICE_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", s_device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 使用特殊字段
    cJSON_AddStringToObject(body, "device_ver", s_device_info.device_ver);
    
    cJSON_AddItemToObject(json, "body", body);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON status info report (code 103).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_status_info_json(void)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    if (json == NULL || header == NULL || body == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_STATUS_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", s_device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 使用特殊字段
    cJSON_AddNumberToObject(body, "device_water", s_status_info.device_water);
    cJSON_AddNumberToObject(body, "sensor_status", s_status_info.sensor_status);
    cJSON_AddNumberToObject(body, "device_move", s_status_info.device_move);
    cJSON_AddNumberToObject(body, "device_LTE_signal", s_status_info.device_LTE_signal);
    cJSON_AddNumberToObject(body, "device_GPS_status", s_status_info.device_GPS_status);
    
    // 使用特殊字段获取定位信息
    cJSON_AddStringToObject(body, "device_location", SPECIAL_FIELD_LON "," SPECIAL_FIELD_LAT);
    cJSON_AddStringToObject(body, "device_installation_location", SPECIAL_FIELD_LON "," SPECIAL_FIELD_LAT);
    
    cJSON_AddItemToObject(json, "body", body);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON parameter info report (code 104).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_param_info_json(void)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    if (json == NULL || header == NULL || body == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_PARAM_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", s_device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body
    cJSON_AddNumberToObject(body, "device_collect_time", s_param_settings.device_collect_time);
    cJSON_AddNumberToObject(body, "device_updata_time", s_param_settings.device_updata_time);
    cJSON_AddNumberToObject(body, "methane_threshold", s_param_settings.methane_threshold);
    cJSON_AddNumberToObject(body, "TEMPH_threshold", s_param_settings.TEMPH_threshold);
    cJSON_AddNumberToObject(body, "TEMPL_threshold", s_param_settings.TEMPL_threshold);
    cJSON_AddNumberToObject(body, "water_threshold", s_param_settings.water_threshold);
    
    cJSON_AddItemToObject(json, "body", body);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON settings query (code 120).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_settings_query_json(void)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    
    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        return NULL;
    }
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_QUERY_SETTINGS);
    cJSON_AddStringToObject(header, "device_ID", s_device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Sensor data collection timer handler.
 *****************************************************************************************
 */
static void sensor_collect_timer_handler(void *p_context)
{
    APP_LOG_INFO("%s Sensor collect timer triggered", DEBUG_TAG);
    
    // 更新传感器数据
    update_sensor_data_from_parser();
    
    // 发送数据上报
    ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);
}

/**
 *****************************************************************************************
 * @brief Data report timer handler.
 *****************************************************************************************
 */
static void data_report_timer_handler(void *p_context)
{
    APP_LOG_INFO("%s Data report timer triggered", DEBUG_TAG);
    
    // 更新传感器数据
    update_sensor_data_from_parser();
    
    // 发送数据上报
    ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);
    
    // 发送设置查询
    ble_4g_protocol_send_settings_query();
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

void ble_4g_protocol_init(void)
{
    if (s_protocol_initialized)
    {
        APP_LOG_WARNING("%s Protocol already initialized", DEBUG_TAG);
        return;
    }
    
    // 确保4G模块上电 - 首先检查上电状态
    APP_LOG_INFO("%s Checking 4G module power status...", DEBUG_TAG);
    
    // 使用外部声明的4G上电控制函数（在user_periph_setup.h中声明）
    extern void gpio_4g_power_en_set(bool enable);
    extern bool gpio_4g_power_en_get(void);
    
    if (!gpio_4g_power_en_get())
    {
        APP_LOG_INFO("%s 4G module is powered off, powering on...", DEBUG_TAG);
        gpio_4g_power_en_set(true);
        APP_LOG_INFO("%s 4G module power enabled", DEBUG_TAG);
    }
    else
    {
        APP_LOG_INFO("%s 4G module is already powered on", DEBUG_TAG);
    }
    
    sdk_err_t err_code;
    
    // 获取设备ID
    ble_4g_protocol_get_device_id();
    
    // 初始化各种信息结构
    ble_4g_protocol_init_device_info();
    ble_4g_protocol_init_status_info();
    ble_4g_protocol_init_param_settings();
    
    // 初始化传感器数据
    memset(&s_current_sensor_data_4g, 0, sizeof(s_current_sensor_data_4g));
    
    // 创建定时器
    err_code = app_timer_create(&m_sensor_collect_timer, 
                               ATIMER_REPEAT, 
                               sensor_collect_timer_handler);
    APP_ERROR_CHECK(err_code);
    
    err_code = app_timer_create(&m_data_report_timer, 
                               ATIMER_REPEAT, 
                               data_report_timer_handler);
    APP_ERROR_CHECK(err_code);
    
    s_protocol_initialized = true;
    APP_LOG_INFO("%s 4G protocol initialized successfully", DEBUG_TAG);
}

void ble_4g_protocol_data_process(const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    if (p_data == NULL || length == 0)
    {
        APP_LOG_ERROR("%s Invalid parameters", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s Processing JSON data from 4G module: %d bytes", DEBUG_TAG, length);
    
    // 确保字符串以null结尾
    char json_str[JSON_BUFFER_SIZE];
    if (length >= JSON_BUFFER_SIZE)
    {
        APP_LOG_ERROR("%s JSON data too large: %d bytes", DEBUG_TAG, length);
        return;
    }
    
    memcpy(json_str, p_data, length);
    json_str[length] = '\0';
    
    APP_LOG_INFO("%s Received JSON from 4G: %s", DEBUG_TAG, json_str);
    
    // TODO: 解析服务器下发的设置命令
    // 这里可以解析服务器返回的参数设置命令
}

void ble_4g_protocol_send_device_info_report(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    char *json_string = ble_4g_protocol_create_device_info_json();
    if (json_string)
    {
        uart1_send_json_to_4g(json_string);
        free(json_string);
    }
}

void ble_4g_protocol_send_status_info_report(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    char *json_string = ble_4g_protocol_create_status_info_json();
    if (json_string)
    {
        uart1_send_json_to_4g(json_string);
        free(json_string);
    }
}

void ble_4g_protocol_send_param_info_report(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    char *json_string = ble_4g_protocol_create_param_info_json();
    if (json_string)
    {
        uart1_send_json_to_4g(json_string);
        free(json_string);
    }
}

void ble_4g_protocol_send_data_report(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    if (p_sensor_data == NULL)
    {
        APP_LOG_ERROR("%s Invalid sensor data pointer", DEBUG_TAG);
        return;
    }
    
    char *json_string = ble_4g_protocol_create_data_report_json(p_sensor_data);
    if (json_string)
    {
        uart1_send_json_to_4g(json_string);
        free(json_string);
    }
}

void ble_4g_protocol_send_settings_query(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    char *json_string = ble_4g_protocol_create_settings_query_json();
    if (json_string)
    {
        uart1_send_json_to_4g(json_string);
        free(json_string);
    }
}

void ble_4g_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    uint8_t result = PROTOCOL_4G_RESULT_SET_FAILED; // 定义result变量
    
    switch (cmd_code)
    {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET:
            if (length >= 2)
            {
                s_param_settings.device_collect_time = (p_data[0] << 8) | p_data[1];
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set collect interval: %d minutes", DEBUG_TAG, s_param_settings.device_collect_time);
            }
            break;
            
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:
            if (length >= 2)
            {
                s_param_settings.device_updata_time = (p_data[0] << 8) | p_data[1];
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set report interval: %d minutes", DEBUG_TAG, s_param_settings.device_updata_time);
            }
            break;
            
        case PROTOCOL_4G_CMD_THRESHOLD_SET:
            if (length >= 8)
            {
                // 解析甲烷和温度阈值 (4字节浮点数)
                memcpy(&s_param_settings.methane_threshold, &p_data[0], 4);
                memcpy(&s_param_settings.TEMPH_threshold, &p_data[4], 2);
                memcpy(&s_param_settings.TEMPL_threshold, &p_data[6], 2);
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set thresholds: CH4=%.2f%%vol, TEMP_H=%d°C, TEMP_L=%d°C", 
                           DEBUG_TAG, s_param_settings.methane_threshold, 
                           s_param_settings.TEMPH_threshold, s_param_settings.TEMPL_threshold);
            }
            break;
            
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET:
            if (length >= 2)
            {
                s_param_settings.water_threshold = (p_data[0] << 8) | p_data[1];
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set water threshold: %d", DEBUG_TAG, s_param_settings.water_threshold);
            }
            break;
            
        default:
            APP_LOG_ERROR("%s Unknown parameter set command: %d", DEBUG_TAG, cmd_code);
            break;
    }
    
    // 发送设置结果响应
    APP_LOG_INFO("%s Parameter setting result: %s", DEBUG_TAG, 
                 (result == PROTOCOL_4G_RESULT_SET_SUCCESS) ? "SUCCESS" : "FAILED");
}

float ble_4g_protocol_vol_to_lel(float vol_percent)
{
    // 甲烷LEL转换: 5%vol = 100%LEL
    return (vol_percent / METHANE_MAX_VOL_PERCENT) * METHANE_MAX_LEL_PERCENT;
}

bool ble_4g_protocol_get_sensor_data(ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return false;
    }
    
    update_sensor_data_from_parser();
    memcpy(p_sensor_data, &s_current_sensor_data_4g, sizeof(ble_4g_sensor_data_t));
    
    return s_current_sensor_data_4g.is_valid;
}

void ble_4g_protocol_get_device_info(ble_4g_device_info_t *p_device_info)
{
    if (p_device_info != NULL)
    {
        memcpy(p_device_info, &s_device_info, sizeof(ble_4g_device_info_t));
    }
}

void ble_4g_protocol_get_status_info(ble_4g_status_info_t *p_status_info)
{
    if (p_status_info != NULL)
    {
        memcpy(p_status_info, &s_status_info, sizeof(ble_4g_status_info_t));
    }
}

void ble_4g_protocol_get_param_settings(ble_4g_param_settings_t *p_param_settings)
{
    if (p_param_settings != NULL)
    {
        memcpy(p_param_settings, &s_param_settings, sizeof(ble_4g_param_settings_t));
    }
}

void ble_4g_protocol_start_collect_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    sdk_err_t err_code;
    uint32_t timeout_ticks = s_param_settings.device_collect_time * 60 * 1000; // 分钟转换为毫秒
    
    err_code = app_timer_start(m_sensor_collect_timer, timeout_ticks, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Started collect timer: %d minutes", DEBUG_TAG, s_param_settings.device_collect_time);
}

void ble_4g_protocol_start_report_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    sdk_err_t err_code;
    uint32_t timeout_ticks = s_param_settings.device_updata_time * 60 * 1000; // 分钟转换为毫秒
    
    err_code = app_timer_start(m_data_report_timer, timeout_ticks, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Started report timer: %d minutes", DEBUG_TAG, s_param_settings.device_updata_time);
}

void ble_4g_protocol_stop_collect_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    app_timer_stop(m_sensor_collect_timer);
    
    APP_LOG_INFO("%s Stopped collect timer", DEBUG_TAG);
}

void ble_4g_protocol_stop_report_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    app_timer_stop(m_data_report_timer);
    
    APP_LOG_INFO("%s Stopped report timer", DEBUG_TAG);
}
/**
 *****************************************************************************************
 * @brief Update sensor data from external source.
 *
 * @param[in] p_sensor_data: Pointer to sensor data to update.
 *****************************************************************************************
 */
void ble_4g_protocol_update_sensor_data(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data != NULL)
    {
        memcpy(&s_current_sensor_data_4g, p_sensor_data, sizeof(ble_4g_sensor_data_t));
    }
}

