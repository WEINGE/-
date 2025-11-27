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
#include "cJSON.h"
#include "app_log.h"
#include "app_error.h"
#include "app_uart.h"
#include "board_SK.h"
#include "ble_4g_param_handler.h"
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "app_timer.h"        // 为了使用定时器相关函数
#include <stdlib.h>           // 为了使用 free 函数
#include "grx_sys.h"          // 为了使用 sdk_err_t 类型
#include "bm8563_rtc.h"       // 为了使用RTC时间读取功能
#include "water_sensor.h"     // 水浸传感器驱动

#include "4g_time_utils.h"

/*
 * EXTERNAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
extern void gpio_4g_power_en_set(bool enable);
extern bool gpio_4g_power_en_get(void);
extern void gpio_p_m_en_set(bool enable);
extern void sensor_uart_open(void);
extern void sensor_uart_close(void);
extern void fourg_uart_open(void);
extern void fourg_uart_close(void);
/*
 * DEFINES
 *****************************************************************************************
 */
#define SEND_AT_COMMAND_ASYNC(cmd) do { \
    uart1_tx_data_send((uint8_t*)(cmd), strlen(cmd)); \
} while(0)
#define TAG                         "4G_PROTO"
#define JSON_BUFFER_SIZE            1024

// 将数值按两位小数四舍五入，避免2.0999999这类浮点显示问题
static double round_to_2_decimal(double value)
{
    long tmp = (long)(value * 100.0 + 0.5);
    return (double)tmp / 100.0;
}

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
static bool s_server_config_changed = false;

// 定时器定义
static app_timer_id_t m_sensor_collect_timer;
static app_timer_id_t m_data_report_timer;
static app_timer_id_t m_delayed_send_timer;  // 延时发送定时器

// 数据累积机制
#define MAX_COLLECTED_DATA_COUNT 24  // 最大存储24次采集数据
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
 * @brief RTC调试和测试函数
 * 
 * @details 测试RTC的各项功能并输出调试信息
 *****************************************************************************************
 */
static void rtc_debug_test(void)
{
    fourg_time_rtc_debug_test();
}

/**
 *****************************************************************************************
 * @brief 为4G上传获取采集时间戳（方案1实现）
 * 
 * @details 使用bm8563_get_time_string()函数直接获取格式化的时间字符串
 *          格式: "YYYYMMDDHHmmss" (如: "20241114164235")
 * 
 * @param[out] timestamp_buffer 时间戳缓冲区 (至少15字节)
 * 
 * @return true: 获取成功, false: 获取失败
 *****************************************************************************************
 */
bool get_collection_timestamp_for_4g(char *timestamp_buffer)
{
    return fourg_time_get_collection_timestamp(timestamp_buffer);
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
        APP_LOG_ERROR("%s Invalid parameters for JSON send", TAG);
        return;
    }
    
    APP_LOG_INFO("%s Sending %s", TAG, message_type);
    uart1_send_json_to_4g(json_string);
    free(json_string);
    
    // 标准化延时，避免JSON消息粘连
    sys_delay_ms(500);
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
        APP_LOG_INFO("%s Querying IMEI (attempt %d/%d)...", TAG, imei_retry_count + 1, max_imei_retries);
        
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
            APP_LOG_INFO("%s IMEI successfully obtained: %s", TAG, s_device_id);
            
            // 动态更新蓝牙名称（如果IMEI后四位与当前名称不符）
            extern void update_ble_name_with_imei(void);
            update_ble_name_with_imei();
            
            return true;
        }
        
        imei_retry_count++;
        if (imei_retry_count < max_imei_retries)
        {
            APP_LOG_WARNING("%s IMEI query failed, retrying...", TAG);
            sys_delay_ms(200);
        }
    }
    
    APP_LOG_WARNING("%s Failed to get IMEI after %d attempts", TAG, max_imei_retries);
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
void ble_4g_protocol_get_device_id(char *p_device_id_buffer, uint16_t buffer_size)
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
        APP_LOG_DEBUG("%s Device ID (IMEI): %s", TAG, p_device_id_buffer);
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
        
        APP_LOG_DEBUG("%s Device ID (IMEI) updated: %s", TAG, p_device_id_buffer);
    }
    else
    {
        // 如果 IMEI 仍不可用，使用统一的IMEI获取函数（避免重复逻辑）
        APP_LOG_WARNING("%s IMEI not available, attempting to force IMEI query", TAG);
        
        if (ble_4g_protocol_force_get_imei())
        {
            strncpy(p_device_id_buffer, s_device_id, buffer_size - 1);
            p_device_id_buffer[buffer_size - 1] = '\0';
            APP_LOG_INFO("%s Device ID (IMEI) force updated: %s", TAG, p_device_id_buffer);
        }
        else
        {
            // 最后的fallback：使用MAC地址作为设备ID
            if (strlen(g_at_collector.device_id) > 0)
            {
                strncpy(p_device_id_buffer, g_at_collector.device_id, buffer_size - 1);
                p_device_id_buffer[buffer_size - 1] = '\0';
                APP_LOG_WARNING("%s Using MAC address as device ID: %s", TAG, p_device_id_buffer);
            }
            else
            {
                // 真正的最后fallback
                strncpy(p_device_id_buffer, "000000000000000", buffer_size - 1);
                p_device_id_buffer[buffer_size - 1] = '\0';
                APP_LOG_ERROR("%s No IMEI or MAC available, using error ID: %s", TAG, p_device_id_buffer);
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
    strcpy(s_device_info.device_ver, "1.0.1");
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
    s_status_info.device_LTE_signal = 0;  // 4G信号值
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
    // 1. 传感器状态 (sensor_status) 在 ble_4g_protocol_read_sensor_with_power_mgmt 中更新

    // 2. 从AT收集器获取缓存的4G信号强度
    s_status_info.device_LTE_signal = g_at_collector.signal_quality;
    APP_LOG_INFO("%s Using cached 4G signal strength (CSQ): %d", TAG, s_status_info.device_LTE_signal);

    // 3. 从ble_protocol模块获取GPS状态等其他信息
    status_info_t ble_status_info = {0};
    // ble_protocol_get_status_info(&ble_status_info);

    // 更新GPS状态（从AT收集器获取）
    shared_params_set_device_gps_status(g_at_collector.gps_status);
    s_status_info.device_GPS_status = g_shared_params.device_GPS_status;

    // 注意：水浸状态已在 sensor_collect_timer_handler() 中通过 water_sensor_get_status() 更新
    // 这里不再覆盖，保持水浸传感器的实时状态
    // shared_params_set_device_water(ble_status_info.device_status & 0x01);  // 已删除，避免覆盖
    
    // 更新移动状态到共享参数
    shared_params_set_device_move((ble_status_info.device_status >> 1) & 0x01);

    APP_LOG_INFO("%s Status info updated: water=%d, sensor=%d, move=%d, signal=%d, gps=%d", 
                 TAG,
                 g_shared_params.device_water,
                 g_shared_params.sensor_status,
                 g_shared_params.device_move,
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建header（使用DTU特殊字段替换IMEI）
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_DATA_REPORT);
    cJSON_AddStringToObject(header, "device_ID", "${IMEI}");
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 使用特殊字段让4G模块自动转换
    char methane_str[32];
    snprintf(methane_str, sizeof(methane_str), "%.2f,%.1f", 
             p_data->methane_vol, p_data->methane_lel);
    cJSON_AddStringToObject(body, "sensor_methane", methane_str);
    
    cJSON_AddNumberToObject(body, "sensor_TEMP", p_data->temperature);
    
    char battery_str[32];
    snprintf(battery_str, sizeof(battery_str), "%.2f,%d", 
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
    
    // 构建body - 从共享参数获取状态信息
    cJSON_AddNumberToObject(body, "device_water", g_shared_params.device_water);
    cJSON_AddNumberToObject(body, "sensor_status", g_shared_params.sensor_status);
    cJSON_AddNumberToObject(body, "device_move", g_shared_params.device_move);
    // 优先使用缓存的信号强度，如果无效则回退到DTU特殊字段
    if (s_status_info.device_LTE_signal > 0 && s_status_info.device_LTE_signal != 99) 
    {
        char csq_str[4];
        snprintf(csq_str, sizeof(csq_str), "%d", s_status_info.device_LTE_signal);
        cJSON_AddStringToObject(body, "device_LTE_signal", csq_str);
    } 
    else 
    {
        cJSON_AddStringToObject(body, "device_LTE_signal", "${CSQ}"); // 回退方案
    }
    cJSON_AddNumberToObject(body, "device_GPS_status", g_shared_params.device_GPS_status);
    
    // 使用特殊字段获取定位信息（格式化为6位小数）
    char location_str[32];
    snprintf(location_str, sizeof(location_str), "%.6f,%.6f", 
             g_shared_params.location_lon, g_shared_params.location_lat);
    cJSON_AddStringToObject(body, "device_location", location_str);
    
    char install_location_str[32];
    snprintf(install_location_str, sizeof(install_location_str), "%.6f,%.6f", 
             g_shared_params.install_lon, g_shared_params.install_lat);
    cJSON_AddStringToObject(body, "device_installation_location", install_location_str);
    
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
    // 甲烷阈值按两位小数四舍五入后再写入JSON，避免2.0999999046等显示
    cJSON_AddNumberToObject(body, "methane_threshold", round_to_2_decimal(g_shared_params.methane_threshold));
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
 * 
 * 修改逻辑：优先检测水浸，如有水浸则跳过传感器采集
 *****************************************************************************************
 */
static void sensor_collect_timer_handler(void *p_context)
{
    // 步骤1: 优先检测水浸
    uint8_t water_status = water_sensor_read_with_power_mgmt();
    shared_params_set_device_water(water_status);
    
    if (water_status == 1) {  // 水浸告警
        shared_params_set_sensor_status(1);
        update_status_info_from_sources();
        if (s_collected_data_count > 0) {
            s_collected_data_count = 0;
            s_data_collection_index = 0;
        }
        return;
    }
    
    // 步骤2: 正常采集传感器
    ble_4g_sensor_data_t sensor_data;
    if (ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data)) {
        memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        
        char timestamp[RTC_TIME_STRING_LEN];
        if (get_collection_timestamp_for_4g(timestamp)) {
            strncpy(s_current_sensor_data_4g.collect_time, timestamp, sizeof(s_current_sensor_data_4g.collect_time) - 1);
        }
        
        update_status_info_from_sources();
        
        // 存储到累积数组
        memcpy(&s_collected_data_array[s_data_collection_index], &s_current_sensor_data_4g, sizeof(ble_4g_sensor_data_t));
        s_data_collection_index = (s_data_collection_index + 1) % MAX_COLLECTED_DATA_COUNT;
        if (s_collected_data_count < MAX_COLLECTED_DATA_COUNT) s_collected_data_count++;
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
        
        APP_LOG_INFO("%s All collected data sent, buffer cleared", TAG);
        
        // 所有105和103数据已经发送完毕，现在发送静态信息：102设备信息、104参数设置、120设置查询
        // 注意：103状态信息已经跟每个105一起发送了，这里不再重复发送
        APP_LOG_INFO("%s Sending device info report (code 102) - static info", TAG);
        ble_4g_protocol_send_device_info_report();
        
        APP_LOG_INFO("%s Sending param info report (code 104) - static info", TAG);
        ble_4g_protocol_send_param_info_report();
        
        // 最后发送设置查询
        APP_LOG_INFO("%s Sending settings query (code 120)", TAG);
        ble_4g_protocol_send_settings_query();
        
        return;
    }
    
    // 计算实际索引（从最旧的数据开始上报）
    uint8_t report_index = (s_data_collection_index - s_total_data_to_send + s_send_data_index) % MAX_COLLECTED_DATA_COUNT;
    
    APP_LOG_INFO("%s Sending data point %d/%d", TAG, s_send_data_index + 1, s_total_data_to_send);
    
    // 发送105监测数据
    ble_4g_protocol_send_data_report(&s_collected_data_array[report_index]);
    
    // 每次105之后都发送103状态信息（因为状态是动态变化的）
    APP_LOG_INFO("%s Sending status info report (code 103) with data point %d", TAG, s_send_data_index + 1);
    ble_4g_protocol_send_status_info_report();
    
    s_send_data_index++;
}

/**
 *****************************************************************************************
 * @brief Data report timer handler.
 * 
 * 上报定时器处理函数：触发延时发送流程
 *****************************************************************************************
 */
static void data_report_timer_handler(void *p_context)
{
    update_status_info_from_sources();
    
    if (s_collected_data_count == 0 && g_shared_params.device_water != 1) {
        // 非水浸状态但无数据，尝试即时采集
        ble_4g_sensor_data_t sensor_data;
        if (ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data)) {
            memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        }
    }
    ble_4g_protocol_upload_with_power_mgmt();
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

// 初始化4G协议模块：配置电源初始状态、水浸与传感器状态、创建定时器并执行首次上传
void ble_4g_protocol_init(void)
{
    if (s_protocol_initialized) return;
    
    // 初始化电源控制
    ble_4g_protocol_sensor_power_control(false);
    gpio_4g_power_en_set(false);
    
    sdk_err_t err_code;
    
    // 初始化各种信息结构
    ble_4g_protocol_init_device_info();
    ble_4g_protocol_init_status_info();
    ble_4g_protocol_init_param_settings();
    
    // 初始化水浸传感器
    if (water_sensor_init()) {
        shared_params_set_device_water(water_sensor_read_with_power_mgmt());
    }
    
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
    APP_LOG_INFO("%s 4G protocol initialized successfully", TAG);
    
    // 执行RTC调试测试
    APP_LOG_INFO("%s Running RTC debug test during 4G protocol initialization", TAG);
    rtc_debug_test();
    
    // 初始化完成后执行首次上传（使用统一的电源管理流程）
    APP_LOG_INFO("%s Performing initial upload with power management", TAG);

    // 检查初始水浸状态，如果设备启动时就有水浸，则跳过首次传感器采集
    if (g_shared_params.device_water == 1) // 1 = WET
    {
        APP_LOG_WARNING("%s Device started in water alarm state. Skipping initial sensor data collection.", TAG);
        // 设置传感器状态为异常
        shared_params_set_sensor_status(1);
    }
    else
    {
        // 如果设备启动时无水浸，则执行首次传感器数据采集
        APP_LOG_INFO("%s No water alarm on init. Performing initial sensor data collection.", TAG);
        ble_4g_sensor_data_t sensor_data;
        bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
        if (data_valid)
        {
            memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        }
        else
        {
            APP_LOG_WARNING("%s Failed to read sensor data during init, using default data", TAG);
        }
    }

    // 2. 更新状态信息
    update_status_info_from_sources();

    // 3. 使用统一的电源管理流程进行首次上传
    APP_LOG_INFO("%s Executing initial upload with full power management cycle", TAG);
    ble_4g_protocol_upload_with_power_mgmt();
}


/**
 * @brief 处理来自4G模块的JSON下行数据
 * @param p_data JSON数据指针
 * @param length 数据长度
 */
void ble_4g_protocol_data_process(const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized || !p_data || length == 0 || length >= JSON_BUFFER_SIZE) return;
    
    // 复制并终止字符串
    char json_str[JSON_BUFFER_SIZE];
    memcpy(json_str, p_data, length);
    json_str[length] = '\0';
    
    // 解析JSON结构
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return;
    
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (!header) { cJSON_Delete(json); return; }
    
    // 验证设备ID是否匹配本机
    cJSON *device_id_item = cJSON_GetObjectItem(header, "device_ID");
    if (!device_id_item || !cJSON_IsString(device_id_item)) { cJSON_Delete(json); return; }
    
    char local_device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(local_device_id, sizeof(local_device_id));
    if (strcmp(local_device_id, device_id_item->valuestring) != 0) { cJSON_Delete(json); return; }
    
    // 获取命令码
    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (!code_item || !cJSON_IsNumber(code_item)) { cJSON_Delete(json); return; }
    
    int cmd_code = code_item->valueint;
    cJSON *body = cJSON_GetObjectItem(json, "body");
    char *response_json = NULL;
    
    // 根据命令码分发到参数处理模块
    switch (cmd_code) {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET:    // 106 - 采集周期
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:     // 107 - 上报周期
        case PROTOCOL_4G_CMD_THRESHOLD_SET:       // 108 - 报警阈值
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET: // 110 - 水浸阈值
            response_json = ble_4g_param_process_json_command(cmd_code, body);
            break;
        default: break;
    }
    
    // 发送响应并清理
    if (response_json) send_json_with_delay(response_json, "param response");
    cJSON_Delete(json);
}

/** @brief 发送设备信息上报(code 102) */
void ble_4g_protocol_send_device_info_report(void)
{
    if (!s_protocol_initialized) return;
    char *json = ble_4g_protocol_create_device_info_json();
    if (json) send_json_with_delay(json, "code 102");
}

/** @brief 发送设备状态上报(code 103) */
void ble_4g_protocol_send_status_info_report(void)
{
    if (!s_protocol_initialized) return;
    char *json = ble_4g_protocol_create_status_info_json();
    if (json) send_json_with_delay(json, "code 103");
}

/** @brief 发送参数信息上报(code 104) */
void ble_4g_protocol_send_param_info_report(void)
{
    if (!s_protocol_initialized) return;
    char *json = ble_4g_protocol_create_param_info_json();
    if (json) send_json_with_delay(json, "code 104");
}

/** @brief 发送传感器数据上报(code 105) */
void ble_4g_protocol_send_data_report(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (!s_protocol_initialized || !p_sensor_data) return;
    char *json = ble_4g_protocol_create_data_report_json(p_sensor_data);
    if (json) send_json_with_delay(json, "code 105");
}

/** @brief 发送参数查询(code 120) */
void ble_4g_protocol_send_settings_query(void)
{
    if (!s_protocol_initialized) return;
    char *json = ble_4g_protocol_create_settings_query_json();
    if (json) send_json_with_delay(json, "code 120");
}

/**
 * @brief 处理参数设置命令
 * @param cmd_code 命令码(106/107/108/110)
 * @param p_data 参数数据
 * @param length 数据长度
 */
void ble_4g_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized) return;
    
    switch (cmd_code) {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET: // 106 - 采集周期
            if (length >= 2) {
                uint16_t val = (p_data[0] << 8) | p_data[1];
                if (val >= 1 && val <= 1440 && shared_params_set_collect_time(val))
                    ble_4g_protocol_restart_collect_timer();
            }
            break;
            
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET: // 107 - 上报周期
            if (length >= 2) {
                uint16_t val = (p_data[0] << 8) | p_data[1];
                if (val >= 1 && val <= 1440 && shared_params_set_update_time(val))
                    ble_4g_protocol_restart_report_timer();
            }
            break;
            
        case PROTOCOL_4G_CMD_THRESHOLD_SET: // 108 - 甲烷/温度阈值
            if (length >= 8) {
                float ch4; int16_t temp_h, temp_l;
                memcpy(&ch4, &p_data[0], 4);
                memcpy(&temp_h, &p_data[4], 2);
                memcpy(&temp_l, &p_data[6], 2);
                shared_params_set_methane_threshold(ch4);
                shared_params_set_temp_thresholds(temp_h, temp_l);
            }
            break;
            
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET: // 110 - 水浸阈值
            if (length >= 2)
                shared_params_set_water_threshold((p_data[0] << 8) | p_data[1]);
            break;
            
        default: break;
    }
}

/** @brief %vol转%LEL (5%vol=100%LEL) */
float ble_4g_protocol_vol_to_lel(float vol_percent)
{
    return (vol_percent / METHANE_MAX_VOL_PERCENT) * METHANE_MAX_LEL_PERCENT;
}

/** @brief 获取最新传感器数据 */
bool ble_4g_protocol_get_sensor_data(ble_4g_sensor_data_t *p_sensor_data)
{
    if (!p_sensor_data) return false;
    update_sensor_data_from_parser();
    memcpy(p_sensor_data, &s_current_sensor_data_4g, sizeof(ble_4g_sensor_data_t));
    return s_current_sensor_data_4g.is_valid;
}

/**
 *****************************************************************************************
 * @brief Get sensor data without triggering threshold check (for timer upload).
 *
 * @param[out] p_sensor_data: Pointer to store sensor data.
 *
 * @return true if data is valid, false otherwise.
 *****************************************************************************************
 */
static bool ble_4g_protocol_get_sensor_data_no_threshold_check(ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return false;
    }
    
    // 直接返回当前缓存的传感器数据，不触发阈值检查
    memcpy(p_sensor_data, &s_current_sensor_data_4g, sizeof(ble_4g_sensor_data_t));
    
    APP_LOG_DEBUG("%s Timer upload: returning cached sensor data (valid: %s)", 
                  TAG, s_current_sensor_data_4g.is_valid ? "true" : "false");
    
    return s_current_sensor_data_4g.is_valid;
}

// 获取当前设备信息结构（如固件版本号）
void ble_4g_protocol_get_device_info(ble_4g_device_info_t *p_device_info)
{
    if (p_device_info != NULL)
    {
        memcpy(p_device_info, &s_device_info, sizeof(ble_4g_device_info_t));
    }
}

// 获取当前设备状态信息结构（水浸、传感器状态、移动状态、信号等）
void ble_4g_protocol_get_status_info(ble_4g_status_info_t *p_status_info)
{
    if (p_status_info != NULL)
    {
        memcpy(p_status_info, &s_status_info, sizeof(ble_4g_status_info_t));
    }
}

// 以旧结构体形式导出当前参数配置，便于兼容旧接口
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

/** @brief 启动采集定时器 */
void ble_4g_protocol_start_collect_timer(void)
{
    if (!s_protocol_initialized) return;
    uint32_t ms = g_shared_params.device_collect_time * 60 * 1000;
    APP_ERROR_CHECK(app_timer_start(m_sensor_collect_timer, ms, NULL));
}

/** @brief 启动上报定时器 */
void ble_4g_protocol_start_report_timer(void)
{
    if (!s_protocol_initialized) return;
    uint32_t ms = g_shared_params.device_updata_time * 60 * 1000;
    APP_ERROR_CHECK(app_timer_start(m_data_report_timer, ms, NULL));
}

/** @brief 停止采集定时器 */
void ble_4g_protocol_stop_collect_timer(void)
{
    if (!s_protocol_initialized) return;
    app_timer_stop(m_sensor_collect_timer);
}

/** @brief 停止上报定时器 */
void ble_4g_protocol_stop_report_timer(void)
{
    if (!s_protocol_initialized) return;
    app_timer_stop(m_data_report_timer);
}

/** @brief 重启采集定时器 */
void ble_4g_protocol_restart_collect_timer(void)
{
    if (!s_protocol_initialized) return;
    app_timer_stop(m_sensor_collect_timer);
    uint32_t ms = g_shared_params.device_collect_time * 60 * 1000;
    APP_ERROR_CHECK(app_timer_start(m_sensor_collect_timer, ms, NULL));
}

/** @brief 重启上报定时器 */
void ble_4g_protocol_restart_report_timer(void)
{
    if (!s_protocol_initialized) return;
    app_timer_stop(m_data_report_timer);
    uint32_t ms = g_shared_params.device_updata_time * 60 * 1000;
    APP_ERROR_CHECK(app_timer_start(m_data_report_timer, ms, NULL));
}

/** @brief 更新传感器数据 */
void ble_4g_protocol_update_sensor_data(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data) memcpy(&s_current_sensor_data_4g, p_sensor_data, sizeof(ble_4g_sensor_data_t));
}

/** @brief 获取已采集数据条数 */
uint8_t ble_4g_protocol_get_collected_data_count(void) { return s_collected_data_count; }

/**
 *****************************************************************************************
 * @brief Clear collected data buffer.
 *****************************************************************************************
 */
void ble_4g_protocol_clear_collected_data(void)
{
    s_collected_data_count = 0;
    s_data_collection_index = 0;
    APP_LOG_INFO("%s Collected data buffer cleared", TAG);
}

// 在阈值超限等场景下，使用当前告警传感器数据立即触发一次完整上传
void ble_4g_protocol_trigger_immediate_upload(const ble_4g_sensor_data_t *p_sensor_data)
{
    if (!p_sensor_data || !p_sensor_data->is_valid) {
        APP_LOG_WARNING("%s Invalid sensor data for immediate upload", TAG);
        return;
    }
    
    APP_LOG_INFO("%s Triggering immediate alarm upload due to threshold exceeded", TAG);
    
    // 更新当前传感器数据为报警数据
    memcpy(&s_current_sensor_data_4g, p_sensor_data, sizeof(ble_4g_sensor_data_t));
    
    // 更新状态信息
    update_status_info_from_sources();
    
    // 直接复用定时上传功能，包含完整的电源管理
    APP_LOG_INFO("%s Reusing scheduled upload function with power management for alarm", TAG);
    ble_4g_protocol_upload_with_power_mgmt();
}

// 发送所有静态信息报文（102设备信息、104参数信息、120设置查询）
void ble_4g_protocol_send_static_info(void)
{
    APP_LOG_INFO("%s Sending static information reports", TAG);
    
    // 发送设备信息报告 (code 102)
    APP_LOG_INFO("%s Sending device info report (code 102) - static info", TAG);
    ble_4g_protocol_send_device_info_report();
    
    // 发送参数信息报告 (code 104)
    APP_LOG_INFO("%s Sending param info report (code 104) - static info", TAG);
    ble_4g_protocol_send_param_info_report();
    
    // 发送设置查询 (code 120)
    APP_LOG_INFO("%s Sending settings query (code 120)", TAG);
    ble_4g_protocol_send_settings_query();
}

/*
 * POWER MANAGEMENT FUNCTIONS
 *****************************************************************************************
 */

// 控制传感器电源引脚S_EN的开关，用于配合采集电源管理
void ble_4g_protocol_sensor_power_control(bool enable)
{
    if (enable) {
        app_io_write_pin(POWER_GPIO_TYPE, SENSOR_POWER_PIN, APP_IO_PIN_SET);
        APP_LOG_INFO("%s Sensor power ON (S_EN)", TAG);
    } else {
        app_io_write_pin(POWER_GPIO_TYPE, SENSOR_POWER_PIN, APP_IO_PIN_RESET);
        APP_LOG_INFO("%s Sensor power OFF (S_EN)", TAG);
    }
}



bool ble_4g_protocol_read_sensor_with_power_mgmt(ble_4g_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL) {
        APP_LOG_ERROR("%s Invalid sensor data pointer", TAG);
        return false;
    }

    APP_LOG_INFO("%s Reading sensor with power management", TAG);
    
    // 1. 打开总电源、传感器UART并上电传感器
    gpio_p_m_en_set(true);
    sensor_uart_open();
    ble_4g_protocol_sensor_power_control(true);
    
    // 2. 等待传感器稳定和初始化
    APP_LOG_INFO("%s Waiting for sensor stabilization...", TAG);
    sys_delay_ms(5000);  // 增加稳定时间到5秒
    
    // 3. 清除旧的传感器数据标志，准备接收新数据
    sensor_data_clear_flag();
    
    // 4. 等待接收新的传感器数据（传感器会自动发送数据）
    APP_LOG_INFO("%s Waiting for fresh sensor data...", TAG);
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
            APP_LOG_INFO("%s Fresh sensor data received after %d00ms", TAG, i+1);
            break;
        }
        sys_delay_ms(100);  // 每100ms检查一次
    }
    
    // 5. 读取传感器数据 - 使用不触发阈值检查的版本，避免重复上传
    bool result = false;
    if (data_received)
    {
        // 根据状态码更新传感器状态
        sensor_data_t raw_data = {0};
        sensor_data_get_latest(&raw_data);
        if (raw_data.data_valid && raw_data.status_code == 0) {
            shared_params_set_sensor_status(0); // 传感器正常
        } else {
            shared_params_set_sensor_status(1); // 传感器异常
            APP_LOG_WARNING("%s Sensor status ERROR (status code: %d, valid: %d)", 
                            TAG, raw_data.status_code, raw_data.data_valid);
        }
        result = ble_4g_protocol_get_sensor_data_no_threshold_check(p_sensor_data);
    }
    else
    {
        APP_LOG_WARNING("%s Timeout waiting for sensor data, setting status to error", TAG);
        shared_params_set_sensor_status(1); // 无数据，传感器异常
        result = ble_4g_protocol_get_sensor_data_no_threshold_check(p_sensor_data);
    }
    
    // 注意：水浸传感器状态已在 sensor_collect_timer_handler() 中优先检测
    // 此处不再重复读取，避免重复上电/断电操作
    
    // 6. 获取采集时间戳并更新到传感器数据中
    if (result && p_sensor_data != NULL) {
        char timestamp[RTC_TIME_STRING_LEN];
        if (get_collection_timestamp_for_4g(timestamp)) {
            // 将时间戳复制到传感器数据结构中
            strncpy(p_sensor_data->collect_time, timestamp, sizeof(p_sensor_data->collect_time) - 1);
            p_sensor_data->collect_time[sizeof(p_sensor_data->collect_time) - 1] = '\0';
            APP_LOG_INFO("%s Sensor data timestamp updated: %s", TAG, p_sensor_data->collect_time);
        } else {
            APP_LOG_WARNING("%s Failed to get RTC timestamp, using default", TAG);
        }
    }
    
    // 7. 断电传感器并关闭UART和总电源
    ble_4g_protocol_sensor_power_control(false);
    sensor_uart_close();
    gpio_p_m_en_set(false);
    
    if (result && data_received) {
        APP_LOG_INFO("%s Fresh sensor data read successfully with timestamp", TAG);
    } else if (result) {
        APP_LOG_WARNING("%s Using cached sensor data with timestamp", TAG);
    } else {
        APP_LOG_ERROR("%s Failed to read sensor data", TAG);
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
    APP_LOG_INFO("%s Executing core upload logic", TAG);

    // 1. 发送动态信息
    APP_LOG_INFO("%s Uploading: sending current sensor data (code 105)", TAG);
    ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);

    APP_LOG_INFO("%s Uploading: sending status info (code 103)", TAG);
    ble_4g_protocol_send_status_info_report();

    // 2. 发送静态信息
    APP_LOG_INFO("%s Uploading: sending device info (code 102)", TAG);
    ble_4g_protocol_send_device_info_report();

    APP_LOG_INFO("%s Uploading: sending param info (code 104)", TAG);
    ble_4g_protocol_send_param_info_report();

    // 3. 发送设置查询
    APP_LOG_INFO("%s Uploading: sending settings query (code 120)", TAG);
    ble_4g_protocol_send_settings_query();

    APP_LOG_INFO("%s Core upload logic finished", TAG);
}


/**
 *****************************************************************************************
 * @brief Query and cache key DTU information like IMEI and CSQ.
 * 
 * This function should only be called when the 4G module is powered on.
 *****************************************************************************************
 */
static void ble_4g_protocol_update_dtu_info_cache(void)
{
    APP_LOG_INFO("%s Updating DTU info cache (IMEI, CSQ)...", TAG);

    // 1. 强制获取并缓存IMEI
    (void)ble_4g_protocol_force_get_imei();

    // 2. 查询并缓存信号强度 (CSQ)
     const char* csq_cmd = "adminAT+CSQ\r\n";
     SEND_AT_COMMAND_ASYNC(csq_cmd);
     sys_delay_ms(500); // 等待AT响应

    // g_at_collector.signal_quality 会被AT命令处理器更新
    APP_LOG_INFO("%s CSQ updated to: %d", TAG, g_at_collector.signal_quality);

    // 3. 查询并缓存ICCID
     const char* iccid_cmd = "adminAT+ICCID?\r\n";
     SEND_AT_COMMAND_ASYNC(iccid_cmd);
     sys_delay_ms(500); // 等待AT响应
    APP_LOG_INFO("%s ICCID updated to: %s", TAG, g_at_collector.iccid);

    // 4. 查询并缓存GPS坐标
     const char* gps_cmd = "adminAT+GPS\r\n";
     SEND_AT_COMMAND_ASYNC(gps_cmd);
     sys_delay_ms(500); // 等待AT响应
    APP_LOG_INFO("%s GPS coordinate query sent.", TAG);
}

static void ble_4g_protocol_apply_server_config_if_needed(void)
{
    if (!s_server_config_changed)
    {
        APP_LOG_INFO("%s Server configuration not changed, skip DTU reconfig", TAG);
        return;
    }

    APP_LOG_INFO("%s Applying updated server configuration to DTU...", TAG);

    char at_cmd[128];

    snprintf(at_cmd, sizeof(at_cmd), "adminAT+MQTTSV1=%s,%d\r\n",
             g_shared_params.server_address,
             (int)g_shared_params.server_port);
    SEND_AT_COMMAND_ASYNC(at_cmd);
    sys_delay_ms(500);

    const char *client_id = "${IMEI}";
    snprintf(at_cmd, sizeof(at_cmd), "adminAT+MQTTCONN1=%s,%s,%s,60,1\r\n",
             client_id,
             g_shared_params.username,
             g_shared_params.password);
    SEND_AT_COMMAND_ASYNC(at_cmd);
    sys_delay_ms(500);

    const char *report_topic = "/methane_sensor/test/report";
    snprintf(at_cmd, sizeof(at_cmd), "adminAT+MQTTPUB1=%s,0,0\r\n", report_topic);
    SEND_AT_COMMAND_ASYNC(at_cmd);
    sys_delay_ms(500);

    const char *command_topic = "/methane_sensor/test/command";
    snprintf(at_cmd, sizeof(at_cmd), "adminAT+MQTTSUB1=%s,0\r\n", command_topic);
    SEND_AT_COMMAND_ASYNC(at_cmd);
    sys_delay_ms(500);

    const char *save_cmd = "adminAT+S\r\n";
    SEND_AT_COMMAND_ASYNC(save_cmd);
    sys_delay_ms(10000);

    s_server_config_changed = false;
    APP_LOG_INFO("%s Server configuration applied to DTU and flag cleared", TAG);
}

// 打开4G/DTU电源域和UART，并等待模块上电稳定
static void dtu_power_on_and_wait(void)
{
    gpio_p_m_en_set(true);
    fourg_uart_open();
    gpio_4g_power_en_set(true);
    sys_delay_ms(10000);
}

// 关闭4G/DTU电源和UART，结束一次完整的上传周期
static void dtu_power_off(void)
{
    gpio_4g_power_en_set(false);
    fourg_uart_close();
    gpio_p_m_en_set(false);
    APP_LOG_INFO("%s 4G/DTU module powered off", TAG);
}

// 在4G/DTU已上电的前提下，根据水浸与传感器状态以及采集缓存决定发送哪些105/103报文
static void upload_dynamic_reports_no_power_mgmt(void)
{
    // 告警优先级：若存在水浸，则只上报103，不发送任何105数据
    if (g_shared_params.device_water != 0 )
    {
        APP_LOG_WARNING("%s Alarm or sensor fault active. Suppressing all 105 data reports. Sending status (103) only.", TAG);
        ble_4g_protocol_send_status_info_report();
        return;
    }

    if (s_collected_data_count > 0)
    {
        uint8_t total = s_collected_data_count;
        uint8_t start_index = (s_data_collection_index + MAX_COLLECTED_DATA_COUNT - s_collected_data_count) % MAX_COLLECTED_DATA_COUNT;
        APP_LOG_INFO("%s No water alarm and sensor OK. Uploading %d collected data points (105).", TAG, total);
        for (uint8_t i = 0; i < total; i++)
        {
            uint8_t current_index = (start_index + i) % MAX_COLLECTED_DATA_COUNT;
            ble_4g_protocol_send_data_report(&s_collected_data_array[current_index]);
            ble_4g_protocol_send_status_info_report();
        }
        ble_4g_protocol_clear_collected_data();
    }
    else
    {
        APP_LOG_INFO("%s No collected data, sending current sensor data if valid", TAG);
        if (s_current_sensor_data_4g.is_valid)
        {
            ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);
        }
        ble_4g_protocol_send_status_info_report();
    }
}

// 标记服务器配置已被修改，下次4G上电时会重新下发MQTT相关参数到DTU
void ble_4g_protocol_mark_server_config_changed(void)
{
    s_server_config_changed = true;
    APP_LOG_INFO("%s Mark server configuration changed flag", TAG);
}

// 执行一次带4G/DTU电源管理的完整上传流程（上电→更新配置→上传→等待下行→下电）
void ble_4g_protocol_upload_with_power_mgmt(void)
{
    APP_LOG_INFO("%s Starting upload with 4G/DTU power management", TAG);

    dtu_power_on_and_wait();

    ble_4g_protocol_apply_server_config_if_needed();
    ble_4g_protocol_update_dtu_info_cache();

    upload_dynamic_reports_no_power_mgmt();

    ble_4g_protocol_send_static_info();

    sys_delay_ms(10000);

    dtu_power_off();
}

