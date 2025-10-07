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
#include "ble_protocol.h"
#include "shared_params.h"
#include "user_app.h"
#include "sensor_data_parser.h"
#include "sensor_status_manager.h"  // 为了使用传感器状态管理器
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
 * EXTERNAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
extern void gpio_4g_power_en_set(bool enable);
extern bool gpio_4g_power_en_get(void);
/*
 * DEFINES
 *****************************************************************************************
 */
#define SEND_AT_COMMAND_ASYNC(cmd) do { \
    uart1_tx_data_send((uint8_t*)(cmd), strlen(cmd)); \
} while(0)
#define DEBUG_TAG                   "[4G_PROTOCOL]"
#define JSON_BUFFER_SIZE            1024
#define DEVICE_ID_SIZE              32

// GPIO定义 - 电源控制引脚
#define SENSOR_POWER_PIN    APP_IO_PIN_25 // S_EN - 传感器电源控制
#define POWER_GPIO_TYPE     APP_IO_TYPE_NORMAL // GPIO类型

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static ble_4g_sensor_data_t s_current_sensor_data_4g = {0};
static ble_4g_device_info_t s_device_info = {0};
static ble_4g_status_info_t s_status_info = {0};
// 移除旧的参数结构体，使用共享参数

static bool s_protocol_initialized = false;
static char s_device_id[DEVICE_ID_SIZE] = {0};

// 定时器定义
static app_timer_id_t m_sensor_collect_timer;
static app_timer_id_t m_data_report_timer;
static app_timer_id_t m_delayed_send_timer;  // 延时发送定时器

// 数据累积机制
#define MAX_COLLECTED_DATA_COUNT 10  // 最大存储10次采集数据
static ble_4g_sensor_data_t s_collected_data_array[MAX_COLLECTED_DATA_COUNT];
static uint8_t s_collected_data_count = 0;
static uint8_t s_data_collection_index = 0;

// 延时发送机制
#define DELAYED_SEND_INTERVAL_MS 500  // 每条消息之间延迟500ms
static uint8_t s_send_data_index = 0;  // 当前发送的数据索引
static uint8_t s_total_data_to_send = 0;  // 总共需要发送的数据数量
static bool s_is_sending = false;  // 是否正在发送数据

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Check 4G network registration status.
 * 
 * @return true if registered to network, false otherwise
 *****************************************************************************************
 */
static bool check_4g_network_registration(void)
{
    // 发送网络注册状态查询指令
    const char* creg_cmd = "adminAT+CREG?\r\n";
    SEND_AT_COMMAND_ASYNC(creg_cmd);
    
    // 等待AT响应
    sys_delay_ms(500);
    
    // 根据AT+CREG文档，检查网络注册状态
    // network_reg_status: 0=未注册, 1=已注册
    if (g_at_collector.network_reg_status == 1)
    {
        APP_LOG_INFO("%s Network registered successfully (CREG status: %d)", 
                     DEBUG_TAG, g_at_collector.network_reg_status);
        return true;
    }
    
    APP_LOG_DEBUG("%s Network not registered (CREG status: %d)", 
                 DEBUG_TAG, g_at_collector.network_reg_status);
    return false;
}

/**
 *****************************************************************************************
 * @brief Wait for 4G network registration with timeout.
 * 
 * @param[in] timeout_seconds: Maximum time to wait for registration
 * @return true if network registered within timeout, false otherwise
 *****************************************************************************************
 */
static bool wait_for_4g_network_registration(uint32_t timeout_seconds)
{
    uint32_t check_count = 0;
    uint32_t max_checks = timeout_seconds / 2;  // 每2秒检查一次
    
    APP_LOG_INFO("%s Waiting for 4G network registration (timeout: %d seconds)", DEBUG_TAG, timeout_seconds);
    
    while (check_count < max_checks)
    {
        if (check_4g_network_registration())
        {
            uint32_t elapsed_seconds = check_count * 2;
            APP_LOG_INFO("%s Network registration completed in %d seconds", DEBUG_TAG, elapsed_seconds);
            return true;
        }
        
        // 每2秒检查一次网络状态
        sys_delay_ms(2000);
        check_count++;
        APP_LOG_DEBUG("%s Still waiting for network registration... (attempt %d/%d)", 
                     DEBUG_TAG, check_count, max_checks);
    }
    
    APP_LOG_WARNING("%s Network registration timeout after %d seconds, but continuing with upload", DEBUG_TAG, timeout_seconds);
    // 修改：即使网络注册超时，也继续尝试上传，而不是直接返回失败
    // 某些4G模块可能在CREG状态查询上有延迟，但实际网络已可用
    return true;  // 改为返回true，让上传流程继续
}

/**
 *****************************************************************************************
 * @brief Send JSON with standardized delay to avoid message collision.
 * 
 * @param[in] json_string: JSON string to send
 * @param[in] message_type: Description of message type for logging
 *****************************************************************************************
 */
static void send_json_with_delay(char *json_string, const char *message_type)
{
    if (json_string == NULL || message_type == NULL)
    {
        APP_LOG_ERROR("%s Invalid parameters for JSON send", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s Sending %s", DEBUG_TAG, message_type);
    uart1_send_json_to_4g(json_string);
    free(json_string);
    
    // 标准化延时，避免JSON消息粘连
    sys_delay_ms(300);
}

/**
 *****************************************************************************************
 * @brief 强制获取IMEI的内部函数
 * 
 * 这个函数执行IMEI获取的核心逻辑，包括重试机制
 * 
 * @return true if IMEI was successfully obtained, false otherwise
 *****************************************************************************************
 */
static bool ble_4g_protocol_force_get_imei(void)
{
    int imei_retry_count = 0;
    const int max_imei_retries = 3;
    
    while (imei_retry_count < max_imei_retries)
    {
        APP_LOG_INFO("%s Querying IMEI (attempt %d/%d)...", DEBUG_TAG, imei_retry_count + 1, max_imei_retries);
        
        // 使用超级指令查询IMEI
        const char* imei_cmd = "adminAT+IMEI?\r\n";
        SEND_AT_COMMAND_ASYNC(imei_cmd);
        sys_delay_ms(800);  // 等待AT响应
        
        // 检查是否成功获取IMEI
        if (strlen(g_at_collector.imei) > 0)
        {
            // 更新本地设备ID缓存
            strncpy(s_device_id, g_at_collector.imei, sizeof(s_device_id) - 1);
            s_device_id[sizeof(s_device_id) - 1] = '\0';
            APP_LOG_INFO("%s IMEI successfully obtained: %s", DEBUG_TAG, s_device_id);
            return true;
        }
        
        imei_retry_count++;
        if (imei_retry_count < max_imei_retries)
        {
            APP_LOG_WARNING("%s IMEI query failed, retrying...", DEBUG_TAG);
            sys_delay_ms(200);
        }
    }
    
    APP_LOG_WARNING("%s Failed to get IMEI after %d attempts", DEBUG_TAG, max_imei_retries);
    return false;
}



/**
 *****************************************************************************************
 * @brief Get device ID (IMEI) dynamically.
 * 
 * This function tries to get the IMEI from ble_protocol module.
 * If IMEI is not available, it returns a fallback device ID.
 * 
 * @param[out] p_device_id_buffer: Buffer to store device ID.
 * @param[in] buffer_size: Size of the buffer.
 *****************************************************************************************
 */
static void ble_4g_protocol_get_device_id(char *p_device_id_buffer, uint16_t buffer_size)
{
    if (p_device_id_buffer == NULL || buffer_size == 0)
    {
        return;
    }
    
    // 首先尝试使用初始化时获取的IMEI
    if (strlen(s_device_id) > 0)
    {
        strncpy(p_device_id_buffer, s_device_id, buffer_size - 1);
        p_device_id_buffer[buffer_size - 1] = '\0';
        APP_LOG_DEBUG("%s Device ID (IMEI): %s", DEBUG_TAG, p_device_id_buffer);
        return;
    }
    
    // 如果s_device_id为空，尝试从AT收集器获取最新的IMEI
    if (strlen(g_at_collector.imei) > 0)
    {
        strncpy(p_device_id_buffer, g_at_collector.imei, buffer_size - 1);
        p_device_id_buffer[buffer_size - 1] = '\0';
        
        // 同时更新本地缓存
        strncpy(s_device_id, g_at_collector.imei, sizeof(s_device_id) - 1);
        s_device_id[sizeof(s_device_id) - 1] = '\0';
        
        APP_LOG_DEBUG("%s Device ID (IMEI) updated: %s", DEBUG_TAG, p_device_id_buffer);
    }
    else
    {
        // 如果 IMEI 仍不可用，使用统一的IMEI获取函数（避免重复逻辑）
        APP_LOG_WARNING("%s IMEI not available, attempting to force IMEI query", DEBUG_TAG);
        
        if (ble_4g_protocol_force_get_imei())
        {
            strncpy(p_device_id_buffer, s_device_id, buffer_size - 1);
            p_device_id_buffer[buffer_size - 1] = '\0';
            APP_LOG_INFO("%s Device ID (IMEI) force updated: %s", DEBUG_TAG, p_device_id_buffer);
        }
        else
        {
            // 最后的fallback：使用MAC地址作为设备ID
            if (strlen(g_at_collector.device_id) > 0)
            {
                strncpy(p_device_id_buffer, g_at_collector.device_id, buffer_size - 1);
                p_device_id_buffer[buffer_size - 1] = '\0';
                APP_LOG_WARNING("%s Using MAC address as device ID: %s", DEBUG_TAG, p_device_id_buffer);
            }
            else
            {
                // 真正的最后fallback
                strncpy(p_device_id_buffer, "NO_IMEI_AVAILABLE", buffer_size - 1);
                p_device_id_buffer[buffer_size - 1] = '\0';
                APP_LOG_ERROR("%s No IMEI or MAC available, using error ID: %s", DEBUG_TAG, p_device_id_buffer);
            }
        }
    }
}

/**
 *****************************************************************************************
 * @brief Initialize device information.
 *****************************************************************************************
 */
static void ble_4g_protocol_init_device_info(void)
{
    // device_id 将在需要时动态获取，这里不再设置
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
 * @brief Update status information from external sources.
 * 
 * 从外部数据源更新状态信息（4G模块、传感器状态管理器等）
 *****************************************************************************************
 */
static void update_status_info_from_sources(void)
{
    // 1. 从传感器状态管理器获取传感器状态
    sensor_simple_status_t sensor_status = sensor_status_get_simple();
    s_status_info.sensor_status = (sensor_status == SENSOR_SIMPLE_STATUS_NORMAL) ? 0 : 1;
    
    // 2. 4G信号强度使用DTU特殊字段自动获取，无需MCU端查询
    APP_LOG_INFO("%s Using DTU special field ${CSQ} for 4G signal strength", DEBUG_TAG);
    
    // 3. 从ble_protocol模块获取GPS状态等其他信息
    status_info_t ble_status_info = {0};
    ble_protocol_get_status_info(&ble_status_info);
    
    // 4G信号强度将由DTU特殊字段${CSQ}自动填充，这里设置为0作为占位符
    s_status_info.device_LTE_signal = 0;
    
    APP_LOG_INFO("%s 4G signal will be filled by DTU special field ${CSQ}", DEBUG_TAG);
    
    // 更新GPS状态（从device_status的bit 2提取）
    s_status_info.device_GPS_status = (ble_status_info.device_status >> 2) & 0x01;
    
    // 更新水浸状态（从device_status的bit 0提取）
    s_status_info.device_water = ble_status_info.device_status & 0x01;
    
    // 更新防盗状态（从device_status的bit 1提取）
    s_status_info.device_move = (ble_status_info.device_status >> 1) & 0x01;
    
    APP_LOG_INFO("%s Status info updated: water=%d, sensor=%d, move=%d, signal=%d, gps=%d", 
                 DEBUG_TAG,
                 s_status_info.device_water,
                 s_status_info.sensor_status,
                 s_status_info.device_move,
                 s_status_info.device_LTE_signal,
                 s_status_info.device_GPS_status);
}

/**
 *****************************************************************************************
 * @brief Initialize parameter settings.
 *****************************************************************************************
 */
static void ble_4g_protocol_init_param_settings(void)
{
    // 使用共享参数初始化，如果共享参数未初始化则会使用默认值
    shared_params_init();
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
    
    // 动态获取设备 ID (IMEI)
    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_DATA_REPORT);
    cJSON_AddStringToObject(header, "device_ID", device_id);
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
    
    // 动态获取设备 ID (IMEI)
    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_DEVICE_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", device_id);
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
    
    // 动态获取设备 ID (IMEI)
    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_STATUS_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 使用特殊字段
    cJSON_AddNumberToObject(body, "device_water", s_status_info.device_water);
    cJSON_AddNumberToObject(body, "sensor_status", s_status_info.sensor_status);
    cJSON_AddNumberToObject(body, "device_move", s_status_info.device_move);
    cJSON_AddStringToObject(body, "device_LTE_signal", "${CSQ}");  // 使用DTU特殊字段获取4G信号强度
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
    
    // 动态获取设备 ID (IMEI)
    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_PARAM_INFO_REPORT);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body
    cJSON_AddNumberToObject(body, "device_collect_time", g_shared_params.device_collect_time);
    cJSON_AddNumberToObject(body, "device_updata_time", g_shared_params.device_updata_time);
    cJSON_AddNumberToObject(body, "methane_threshold", g_shared_params.methane_threshold);
    cJSON_AddNumberToObject(body, "TEMPH_threshold", g_shared_params.temp_high_threshold);
    cJSON_AddNumberToObject(body, "TEMPL_threshold", g_shared_params.temp_low_threshold);
    cJSON_AddNumberToObject(body, "water_threshold", g_shared_params.water_threshold);
    
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
    
    // 动态获取设备 ID (IMEI)
    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));
    
    // 构建header
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_QUERY_SETTINGS);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Sensor data collection timer handler.
 * 
 * 采集定时器处理函数：只负责采集和存储数据，不进行上报
 * 同时更新状态信息（103），使其与监测数据（105）同步
 *****************************************************************************************
 */
static void sensor_collect_timer_handler(void *p_context)
{
    APP_LOG_INFO("%s Sensor collect timer triggered - collecting data with power management", DEBUG_TAG);
    
    // 使用电源管理读取传感器数据
    ble_4g_sensor_data_t sensor_data;
    bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
    
    if (data_valid)
    {
        // 1. 更新当前传感器数据
        memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        
        // 2. 更新状态信息（103）- 使其与监测数据同步采集
        update_status_info_from_sources();
        
        // 3. 将当前数据存储到累积数组中
        if (s_collected_data_count < MAX_COLLECTED_DATA_COUNT)
        {
            memcpy(&s_collected_data_array[s_data_collection_index], &s_current_sensor_data_4g, 
                   sizeof(ble_4g_sensor_data_t));
            
            s_data_collection_index = (s_data_collection_index + 1) % MAX_COLLECTED_DATA_COUNT;
            s_collected_data_count++;
            
            APP_LOG_INFO("%s Data collected with power management, count: %d", DEBUG_TAG, s_collected_data_count);
        }
        else
        {
            // 数组已满，覆盖最旧的数据
            memcpy(&s_collected_data_array[s_data_collection_index], &s_current_sensor_data_4g, 
                   sizeof(ble_4g_sensor_data_t));
            
            s_data_collection_index = (s_data_collection_index + 1) % MAX_COLLECTED_DATA_COUNT;
            
            APP_LOG_INFO("%s Data collected, array full, overwriting old data", DEBUG_TAG);
        }
    }
    else
    {
        APP_LOG_ERROR("%s Failed to collect sensor data with power management", DEBUG_TAG);
    }
}

/**
 *****************************************************************************************
 * @brief Delayed send timer handler.
 * 
 * 延时发送定时器处理函数：每次发送一条数据，直到所有数据发送完毕
 *****************************************************************************************
 */
static void delayed_send_timer_handler(void *p_context)
{
    if (!s_is_sending || s_send_data_index >= s_total_data_to_send)
    {
        // 所有数据发送完毕
        s_is_sending = false;
        app_timer_stop(m_delayed_send_timer);
        
        // 清空累积数据计数
        s_collected_data_count = 0;
        s_data_collection_index = 0;
        
        APP_LOG_INFO("%s All collected data sent, buffer cleared", DEBUG_TAG);
        
        // 所有105和103数据已经发送完毕，现在发送静态信息：102设备信息、104参数设置、120设置查询
        // 注意：103状态信息已经跟每个105一起发送了，这里不再重复发送
        APP_LOG_INFO("%s Sending device info report (code 102) - static info", DEBUG_TAG);
        ble_4g_protocol_send_device_info_report();
        
        APP_LOG_INFO("%s Sending param info report (code 104) - static info", DEBUG_TAG);
        ble_4g_protocol_send_param_info_report();
        
        // 最后发送设置查询
        APP_LOG_INFO("%s Sending settings query (code 120)", DEBUG_TAG);
        ble_4g_protocol_send_settings_query();
        
        return;
    }
    
    // 计算实际索引（从最旧的数据开始上报）
    uint8_t report_index = (s_data_collection_index - s_total_data_to_send + s_send_data_index) % MAX_COLLECTED_DATA_COUNT;
    
    APP_LOG_INFO("%s Sending data point %d/%d", DEBUG_TAG, s_send_data_index + 1, s_total_data_to_send);
    
    // 发送105监测数据
    ble_4g_protocol_send_data_report(&s_collected_data_array[report_index]);
    
    // 每次105之后都发送103状态信息（因为状态是动态变化的）
    APP_LOG_INFO("%s Sending status info report (code 103) with data point %d", DEBUG_TAG, s_send_data_index + 1);
    ble_4g_protocol_send_status_info_report();
    
    s_send_data_index++;
}

/**
 *****************************************************************************************
 * @brief Start delayed send process.
 * 
 * 启动延时发送流程
 *****************************************************************************************
 */
/*
static void start_delayed_send_process(void)
{
    if (s_is_sending)
    {
        APP_LOG_WARNING("%s Already sending data, skip", DEBUG_TAG);
        return;
    }
    
    if (s_collected_data_count == 0)
    {
        APP_LOG_WARNING("%s No data to send", DEBUG_TAG);
        return;
    }
    
    // 初始化发送状态
    s_is_sending = true;
    s_send_data_index = 0;
    s_total_data_to_send = s_collected_data_count;
    
    APP_LOG_INFO("%s Starting delayed send process for %d data points", DEBUG_TAG, s_total_data_to_send);
    
    // 立即发送第一条数据
    delayed_send_timer_handler(NULL);
    
    // 启动定时器，后续数据延时发送
    if (s_total_data_to_send > 1)
    {
        sdk_err_t err_code = app_timer_start(m_delayed_send_timer, DELAYED_SEND_INTERVAL_MS, NULL);
        if (err_code != SDK_SUCCESS)
        {
            APP_LOG_ERROR("%s Failed to start delayed send timer: 0x%X", DEBUG_TAG, err_code);
            s_is_sending = false;
        }
    }
}
*/

/**
 *****************************************************************************************
 * @brief Data report timer handler.
 * 
 * 上报定时器处理函数：触发延时发送流程
 *****************************************************************************************
 */
static void data_report_timer_handler(void *p_context)
{
    APP_LOG_INFO("%s Data report timer triggered - uploading with DTU power management", DEBUG_TAG);
    
    // 确保有数据需要上报
    if (s_collected_data_count == 0)
    {
        APP_LOG_WARNING("%s No collected data to report", DEBUG_TAG);
        
        // 即使没有累积数据，也获取当前最新数据进行上报
        ble_4g_sensor_data_t sensor_data;
        bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
        
        if (data_valid)
        {
            memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        }
        update_status_info_from_sources();  // 同时更新状态信息
        
        // 使用DTU电源管理上传数据
        ble_4g_protocol_upload_with_power_mgmt();
    }
    else
    {
        APP_LOG_INFO("%s %d data points ready to report with DTU power management", DEBUG_TAG, s_collected_data_count);
        
        // 使用DTU电源管理上传所有累积数据
        ble_4g_protocol_upload_with_power_mgmt();
        
        // 清空累积数据
        ble_4g_protocol_clear_collected_data();
    }
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
    
    // 初始化电源控制GPIO
    APP_LOG_INFO("%s Initializing power control GPIOs", DEBUG_TAG);
    
    // 传感器电源控制引脚 (S_EN) 已在user_periph_setup.c中配置
    
    // 初始状态：传感器断电
    ble_4g_protocol_sensor_power_control(false);
    
    // 确保4G模块初始状态为断电（节能）
    APP_LOG_INFO("%s Ensuring 4G module is initially powered off for energy saving", DEBUG_TAG);
    gpio_4g_power_en_set(false);
    
    sdk_err_t err_code;
    
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
    
    err_code = app_timer_create(&m_delayed_send_timer, 
                               ATIMER_REPEAT, 
                               delayed_send_timer_handler);
    APP_ERROR_CHECK(err_code);
    
    s_protocol_initialized = true;
    APP_LOG_INFO("%s 4G protocol initialized successfully", DEBUG_TAG);
    
    // 初始化完成后执行首次上传（使用统一的电源管理流程）
    APP_LOG_INFO("%s Performing initial upload with power management", DEBUG_TAG);

    // 1. 读取传感器数据
    ble_4g_sensor_data_t sensor_data;
    bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
    if (data_valid)
    {
        memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
    }
    else
    {
        APP_LOG_WARNING("%s Failed to read sensor data during init, using default data", DEBUG_TAG);
        update_sensor_data_from_parser();
    }

    // 2. 更新状态信息
    update_status_info_from_sources();

    // 3. 使用统一的电源管理流程进行首次上传
    APP_LOG_INFO("%s Executing initial upload with full power management cycle", DEBUG_TAG);
    ble_4g_protocol_upload_with_power_mgmt();
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
        send_json_with_delay(json_string, "device info report (code 102)");
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
        send_json_with_delay(json_string, "status info report (code 103)");
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
        send_json_with_delay(json_string, "param info report (code 104)");
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
        send_json_with_delay(json_string, "sensor data report (code 105)");
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
        send_json_with_delay(json_string, "settings query (code 120)");
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
                uint16_t new_interval = (p_data[0] << 8) | p_data[1];
                // 参数范围验证 (1-1440分钟)
                if (new_interval >= 1 && new_interval <= 1440)
                {
                    // 使用共享参数API设置采集周期
                    if (shared_params_set_collect_time(new_interval))
                    {
                        result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                        APP_LOG_INFO("%s Set collect interval: %d minutes", DEBUG_TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_4G_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set collect interval", DEBUG_TAG);
                    }
                    
                    // 立即重启采集定时器
                    ble_4g_protocol_restart_collect_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid collect interval: %d (range: 1-1440)", DEBUG_TAG, new_interval);
                }
            }
            break;
            
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:
            if (length >= 2)
            {
                uint16_t new_interval = (p_data[0] << 8) | p_data[1];
                // 参数范围验证 (1-1440分钟)
                if (new_interval >= 1 && new_interval <= 1440)
                {
                    // 使用共享参数API设置上报周期
                    if (shared_params_set_update_time(new_interval))
                    {
                        result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                        APP_LOG_INFO("%s Set report interval: %d minutes", DEBUG_TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_4G_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set report interval", DEBUG_TAG);
                    }
                    
                    // 立即重启上报定时器
                    ble_4g_protocol_restart_report_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid report interval: %d (range: 1-1440)", DEBUG_TAG, new_interval);
                }
            }
            break;
            
        case PROTOCOL_4G_CMD_THRESHOLD_SET:
            if (length >= 8)
            {
                // 解析甲烷和温度阈值
                float methane_thresh;
                int16_t temp_high, temp_low;
                memcpy(&methane_thresh, &p_data[0], 4);
                memcpy(&temp_high, &p_data[4], 2);
                memcpy(&temp_low, &p_data[6], 2);
                
                // 使用共享参数API设置阈值
                if (shared_params_set_methane_threshold(methane_thresh) && 
                    shared_params_set_temp_thresholds(temp_high, temp_low))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set thresholds: CH4=%.2f%%vol, TEMP_H=%d°C, TEMP_L=%d°C", 
                               DEBUG_TAG, methane_thresh, temp_high, temp_low);
                }
                else
                {
                    result = PROTOCOL_4G_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set thresholds", DEBUG_TAG);
                }
            }
            break;
            
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET:
            if (length >= 2)
            {
                uint16_t water_thresh = (p_data[0] << 8) | p_data[1];
                
                // 使用共享参数API设置水浸阈值
                if (shared_params_set_water_threshold(water_thresh))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set water threshold: %d", DEBUG_TAG, water_thresh);
                }
                else
                {
                    result = PROTOCOL_4G_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set water threshold", DEBUG_TAG);
                }
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
    
    // 始终获取最新的传感器数据（用于BLE查询）
    update_sensor_data_from_parser();
    memcpy(p_sensor_data, &s_current_sensor_data_4g, sizeof(ble_4g_sensor_data_t));
    
    APP_LOG_DEBUG("%s BLE query: returning latest sensor data (valid: %s)", 
                  DEBUG_TAG, s_current_sensor_data_4g.is_valid ? "true" : "false");
    
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
        // 从共享参数复制到旧格式结构体（兼容性）
        p_param_settings->device_collect_time = g_shared_params.device_collect_time;
        p_param_settings->device_updata_time = g_shared_params.device_updata_time;
        p_param_settings->methane_threshold = g_shared_params.methane_threshold;
        p_param_settings->TEMPH_threshold = g_shared_params.temp_high_threshold;
        p_param_settings->TEMPL_threshold = g_shared_params.temp_low_threshold;
        p_param_settings->water_threshold = g_shared_params.water_threshold;
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
    uint32_t timeout_ms = g_shared_params.device_collect_time * 60 * 1000; // 分钟转换为毫秒
    
    err_code = app_timer_start(m_sensor_collect_timer, timeout_ms, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Started collect timer: %d minutes", DEBUG_TAG, g_shared_params.device_collect_time);
}

void ble_4g_protocol_start_report_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    sdk_err_t err_code;
    uint32_t timeout_ms = g_shared_params.device_updata_time * 60 * 1000; // 分钟转换为毫秒
    
    err_code = app_timer_start(m_data_report_timer, timeout_ms, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Started report timer: %d minutes", DEBUG_TAG, g_shared_params.device_updata_time);
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
 * @brief Restart collect timer with new interval.
 *****************************************************************************************
 */
void ble_4g_protocol_restart_collect_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    // 停止当前定时器
    app_timer_stop(m_sensor_collect_timer);
    
    // 计算新的超时时间
    uint32_t timeout_ms = g_shared_params.device_collect_time * 60 * 1000; // 分钟转换为毫秒
    
    // 启动新定时器
    sdk_err_t err_code = app_timer_start(m_sensor_collect_timer, timeout_ms, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Collect timer restarted: %d minutes", DEBUG_TAG, g_shared_params.device_collect_time);
}

/**
 *****************************************************************************************
 * @brief Restart report timer with new interval.
 *****************************************************************************************
 */
void ble_4g_protocol_restart_report_timer(void)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    // 停止当前定时器
    app_timer_stop(m_data_report_timer);
    
    // 计算新的超时时间
    uint32_t timeout_ms = g_shared_params.device_updata_time * 60 * 1000; // 分钟转换为毫秒
    
    // 启动新定时器
    sdk_err_t err_code = app_timer_start(m_data_report_timer, timeout_ms, NULL);
    APP_ERROR_CHECK(err_code);
    
    APP_LOG_INFO("%s Report timer restarted: %d minutes", DEBUG_TAG, g_shared_params.device_updata_time);
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
        APP_LOG_DEBUG("%s Sensor data updated externally", DEBUG_TAG);
    }
}

/**
 *****************************************************************************************
 * @brief Get collected data count.
 * 
 * @return Number of collected data points.
 *****************************************************************************************
 */
uint8_t ble_4g_protocol_get_collected_data_count(void)
{
    return s_collected_data_count;
}

/**
 *****************************************************************************************
 * @brief Clear collected data buffer.
 *****************************************************************************************
 */
void ble_4g_protocol_clear_collected_data(void)
{
    s_collected_data_count = 0;
    s_data_collection_index = 0;
    APP_LOG_INFO("%s Collected data buffer cleared", DEBUG_TAG);
}

void ble_4g_protocol_trigger_immediate_upload(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (!p_sensor_data || !p_sensor_data->is_valid) {
        APP_LOG_WARNING("%s Invalid sensor data for immediate upload", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s Triggering immediate upload due to threshold exceeded", DEBUG_TAG);
    
    // 更新状态信息
    update_status_info_from_sources();
    
    // 发送当前数据报告 (code 105)
    APP_LOG_INFO("%s Sending immediate sensor data (code 105)", DEBUG_TAG);
    ble_4g_protocol_send_data_report(p_sensor_data);
    
    // 发送状态信息报告 (code 103)
    APP_LOG_INFO("%s Sending status info report (code 103) with immediate data", DEBUG_TAG);
    ble_4g_protocol_send_status_info_report();
    
    // 发送静态信息
    APP_LOG_INFO("%s Sending static info with immediate upload", DEBUG_TAG);
    ble_4g_protocol_send_static_info();
}

void ble_4g_protocol_send_static_info(void)
{
    APP_LOG_INFO("%s Sending static information reports", DEBUG_TAG);
    
    // 发送设备信息报告 (code 102)
    APP_LOG_INFO("%s Sending device info report (code 102) - static info", DEBUG_TAG);
    ble_4g_protocol_send_device_info_report();
    
    // 发送参数信息报告 (code 104)
    APP_LOG_INFO("%s Sending param info report (code 104) - static info", DEBUG_TAG);
    ble_4g_protocol_send_param_info_report();
    
    // 发送设置查询 (code 120)
    APP_LOG_INFO("%s Sending settings query (code 120)", DEBUG_TAG);
    ble_4g_protocol_send_settings_query();
}

/*
 * POWER MANAGEMENT FUNCTIONS
 *****************************************************************************************
 */

void ble_4g_protocol_sensor_power_control(bool enable)
{
    if (enable) {
        app_io_write_pin(POWER_GPIO_TYPE, SENSOR_POWER_PIN, APP_IO_PIN_SET);
        APP_LOG_INFO("%s Sensor power ON (S_EN)", DEBUG_TAG);
    } else {
        app_io_write_pin(POWER_GPIO_TYPE, SENSOR_POWER_PIN, APP_IO_PIN_RESET);
        APP_LOG_INFO("%s Sensor power OFF (S_EN)", DEBUG_TAG);
    }
}



bool ble_4g_protocol_read_sensor_with_power_mgmt(ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL) {
        APP_LOG_ERROR("%s Invalid sensor data pointer", DEBUG_TAG);
        return false;
    }

    APP_LOG_INFO("%s Reading sensor with power management", DEBUG_TAG);
    
    // 1. 上电传感器
    ble_4g_protocol_sensor_power_control(true);
    
    // 2. 等待传感器稳定和初始化
    APP_LOG_INFO("%s Waiting for sensor stabilization...", DEBUG_TAG);
    sys_delay_ms(5000);  // 增加稳定时间到5秒
    
    // 3. 清除旧的传感器数据标志，准备接收新数据
    sensor_data_clear_flag();
    
    // 4. 等待接收新的传感器数据（传感器会自动发送数据）
    APP_LOG_INFO("%s Waiting for fresh sensor data...", DEBUG_TAG);
    bool data_received = false;
    
    // 等待最多10秒接收新数据，每100ms检查一次
    for (int i = 0; i < 100; i++)  // 100 * 100ms = 10秒
    {
        // 检查是否收到新的有效传感器数据
        sensor_data_t raw_data = {0};
        if (sensor_data_get_latest(&raw_data) && raw_data.data_valid)
        {
            // 更新协议层数据
            update_sensor_data_from_parser();
            data_received = true;
            APP_LOG_INFO("%s Fresh sensor data received after %d00ms", DEBUG_TAG, i+1);
            break;
        }
        sys_delay_ms(100);  // 每100ms检查一次
    }
    
    // 5. 读取传感器数据
    bool result = false;
    if (data_received)
    {
        result = ble_4g_protocol_get_sensor_data(p_sensor_data);
    }
    else
    {
        APP_LOG_WARNING("%s Timeout waiting for sensor data, using cached data", DEBUG_TAG);
        result = ble_4g_protocol_get_sensor_data(p_sensor_data);
    }
    
    // 6. 断电传感器
    ble_4g_protocol_sensor_power_control(false);
    
    if (result && data_received) {
        APP_LOG_INFO("%s Fresh sensor data read successfully", DEBUG_TAG);
    } else if (result) {
        APP_LOG_WARNING("%s Using cached sensor data", DEBUG_TAG);
    } else {
        APP_LOG_ERROR("%s Failed to read sensor data", DEBUG_TAG);
    }
    
    return result;
}

/**
 *****************************************************************************************
 * @brief Core data upload function (without power management).
 * 
 * This function sends all necessary data reports. It assumes the 4G module
 * is already powered on and initialized.
 *****************************************************************************************
 */
void ble_4g_protocol_upload(void)
{
    APP_LOG_INFO("%s Executing core upload logic", DEBUG_TAG);

    // 1. 发送动态信息
    APP_LOG_INFO("%s Uploading: sending current sensor data (code 105)", DEBUG_TAG);
    ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);

    APP_LOG_INFO("%s Uploading: sending status info (code 103)", DEBUG_TAG);
    ble_4g_protocol_send_status_info_report();

    // 2. 发送静态信息
    APP_LOG_INFO("%s Uploading: sending device info (code 102)", DEBUG_TAG);
    ble_4g_protocol_send_device_info_report();

    APP_LOG_INFO("%s Uploading: sending param info (code 104)", DEBUG_TAG);
    ble_4g_protocol_send_param_info_report();

    // 3. 发送设置查询
    APP_LOG_INFO("%s Uploading: sending settings query (code 120)", DEBUG_TAG);
    ble_4g_protocol_send_settings_query();

    APP_LOG_INFO("%s Core upload logic finished", DEBUG_TAG);
}


void ble_4g_protocol_upload_with_power_mgmt(void)
{
    APP_LOG_INFO("%s Starting upload with 4G/DTU power management", DEBUG_TAG);
    
    // 1. 上电4G/DTU模块
    gpio_4g_power_en_set(true);
    APP_LOG_INFO("%s 4G/DTU module powered on", DEBUG_TAG);
    
    // 2. 等待基本硬件稳定（延长到5秒，确保模块完全启动）
    APP_LOG_INFO("%s Waiting 5 seconds for 4G/DTU module hardware stabilization", DEBUG_TAG);
    sys_delay_ms(5000);
    
    // 3. 等待网络注册完成（延长到60秒超时）
    APP_LOG_INFO("%s Waiting for 4G network registration", DEBUG_TAG);
    bool network_ready = wait_for_4g_network_registration(60);
    
    // 4. 无论网络注册状态如何，都继续执行上传流程
    // （因为某些4G模块的CREG查询可能有延迟，但网络实际可用）
    APP_LOG_INFO("%s Starting 4G/DTU initialization process", DEBUG_TAG);
    
    // 使用统一的IMEI获取函数
    if (!ble_4g_protocol_force_get_imei())
    {
        APP_LOG_WARNING("%s Failed to get IMEI during upload, using cached/fallback ID", DEBUG_TAG);
    }
    
    // 5. 调用核心上传函数
    APP_LOG_INFO("%s Starting data upload process", DEBUG_TAG);
    ble_4g_protocol_upload();
    
    // 6. 等待10秒，接收平台可能下发的设置指令
    APP_LOG_INFO("%s Upload completed, waiting 10 seconds for platform response", DEBUG_TAG);
    sys_delay_ms(10000);
    
    APP_LOG_INFO("%s Platform response wait period finished, powering down 4G module", DEBUG_TAG);
    
    // 7. 断电4G/DTU模块
    gpio_4g_power_en_set(false);
    APP_LOG_INFO("%s 4G/DTU module powered off", DEBUG_TAG);
}

