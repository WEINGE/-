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
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "app_timer.h"        // 为了使用定时器相关函数
#include <stdlib.h>           // 为了使用 free 函数
#include "grx_sys.h"          // 为了使用 sdk_err_t 类型
#include "bm8563_rtc.h"       // 为了使用RTC时间读取功能
#include "water_sensor.h"     // 水浸传感器驱动

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
    APP_LOG_INFO("%s === RTC Debug Test Start ===", DEBUG_TAG);
    
    // 1. 检查RTC是否运行
    bool is_running = bm8563_is_running();
    APP_LOG_INFO("%s RTC is running: %s", DEBUG_TAG, is_running ? "YES" : "NO");
    
    // 2. 尝试读取原始时间数据
    rtc_time_t rtc_time;
    bool read_success = bm8563_read_time(&rtc_time);
    APP_LOG_INFO("%s Raw time read success: %s", DEBUG_TAG, read_success ? "YES" : "NO");
    
    if (read_success) {
        APP_LOG_INFO("%s Raw time: %04d-%02d-%02d %02d:%02d:%02d (weekday: %d)",
                     DEBUG_TAG, rtc_time.year, rtc_time.month, rtc_time.day,
                     rtc_time.hour, rtc_time.minute, rtc_time.second, rtc_time.weekday);
    }
    
    // 3. 测试格式化时间字符串
    char time_str[RTC_TIME_STRING_LEN];
    bool format_success = bm8563_get_time_string(time_str);
    APP_LOG_INFO("%s Formatted time success: %s", DEBUG_TAG, format_success ? "YES" : "NO");
    
    if (format_success) {
        APP_LOG_INFO("%s Formatted time: %s (length: %d)", DEBUG_TAG, time_str, strlen(time_str));
    }
    
    // 4. 如果RTC没有运行，尝试启动
    if (!is_running) {
        APP_LOG_INFO("%s Attempting to start RTC...", DEBUG_TAG);
        bool start_success = bm8563_start();
        APP_LOG_INFO("%s RTC start result: %s", DEBUG_TAG, start_success ? "SUCCESS" : "FAILED");
        
        // 重新检查状态
        is_running = bm8563_is_running();
        APP_LOG_INFO("%s RTC is now running: %s", DEBUG_TAG, is_running ? "YES" : "NO");
    }
    
    APP_LOG_INFO("%s === RTC Debug Test End ===", DEBUG_TAG);
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
    if (timestamp_buffer == NULL) {
        APP_LOG_ERROR("%s Invalid timestamp buffer pointer", DEBUG_TAG);
        return false;
    }
    
    // 首先检查RTC是否正常工作
    if (!bm8563_is_running()) {
        APP_LOG_WARNING("%s RTC is not running, attempting to start", DEBUG_TAG);
        if (!bm8563_start()) {
            APP_LOG_ERROR("%s Failed to start RTC, using default timestamp", DEBUG_TAG);
            strcpy(timestamp_buffer, "20241114164200");
            return false;
        }
    }
    
    // 直接获取格式化的时间字符串 "YYYYMMDDHHmmss"
    char full_timestamp[16];
    if (!bm8563_get_time_string(full_timestamp)) {
        APP_LOG_ERROR("%s Failed to get RTC time for 4G upload", DEBUG_TAG);
        strcpy(timestamp_buffer, "202411141642");
        return false;
    }
    
    // 如果时间为默认值，记录警告但继续使用
    if (strncmp(full_timestamp, "2000", 4) == 0) {
        APP_LOG_WARNING("%s RTC time is default (%s), using default timestamp", DEBUG_TAG, full_timestamp);
    }
    
    // 验证时间戳格式和长度
    size_t len = strlen(full_timestamp);
    if (len != 14) {
        APP_LOG_WARNING("%s Invalid timestamp length: %d, expected 14. Timestamp: %s", 
                        DEBUG_TAG, len, full_timestamp);
        
        // 如果长度不对，尝试补零或截断
        if (len < 14) {
            // 长度不足，补零
            while (strlen(full_timestamp) < 14) {
                strcat(full_timestamp, "0");
            }
        } else if (len > 14) {
            // 长度过长，截断
            full_timestamp[14] = '\0';
        }
        APP_LOG_INFO("%s Corrected timestamp: %s", DEBUG_TAG, full_timestamp);
    }
    
    // 截取前12位（YYYYMMDDHHmm），去掉秒
    strncpy(timestamp_buffer, full_timestamp, 12);
    timestamp_buffer[12] = '\0';
    
    APP_LOG_INFO("%s Collection timestamp for 4G (12-digit): %s", DEBUG_TAG, timestamp_buffer);
    return true;
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
            
            // 动态更新蓝牙名称（如果IMEI后四位与当前名称不符）
            extern void update_ble_name_with_imei(void);
            update_ble_name_with_imei();
            
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
                strncpy(p_device_id_buffer, "000000000000000", buffer_size - 1);
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
    APP_LOG_INFO("%s Using cached 4G signal strength (CSQ): %d", DEBUG_TAG, s_status_info.device_LTE_signal);

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
                 DEBUG_TAG,
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
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
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
 * 
 * 修改逻辑：优先检测水浸，如有水浸则跳过传感器采集
 *****************************************************************************************
 */
static void sensor_collect_timer_handler(void *p_context)
{
    APP_LOG_INFO("%s Sensor collect timer triggered - collecting data with power management", DEBUG_TAG);
    
    // ========== 步骤1: 优先检测水浸（节能优化） ==========
    APP_LOG_INFO("%s [STEP 1] Priority check: Reading water sensor first", DEBUG_TAG);
    uint8_t water_status = water_sensor_read_with_power_mgmt();
    shared_params_set_device_water(water_status);
    APP_LOG_INFO("%s Water sensor status: %s (%d)", 
                 DEBUG_TAG, 
                 water_status == 0 ? "DRY" : "WET", 
                 water_status);
    
    // 如果检测到水浸，跳过传感器采集，只更新状态信息
    if (water_status == 1) {  // 1 = WET (有水浸)
        APP_LOG_WARNING("%s *** WATER ALARM DETECTED! Skipping gas sensor collection to save power ***", DEBUG_TAG);
        
        // 设置传感器状态为异常（因为未采集）
        shared_params_set_sensor_status(1);
        
        // 更新状态信息（103）- 包含水浸告警状态
        update_status_info_from_sources();
        
        // 关键修复：清空任何可能存在的旧的传感器数据，确保水浸告警期间不会上报过时的105消息
        if (s_collected_data_count > 0) {
            APP_LOG_WARNING("%s Clearing %d previously collected sensor data points due to water alarm.", DEBUG_TAG, s_collected_data_count);
            s_collected_data_count = 0;
            s_data_collection_index = 0;
        }
        
        APP_LOG_INFO("%s Water alarm mode: Status info (103) updated, no sensor data (105) collected", DEBUG_TAG);
        APP_LOG_INFO("%s Collection completed in water alarm mode (power saved)", DEBUG_TAG);
        return;  // 直接返回，不采集传感器
    }
    
    // ========== 步骤2: 无水浸，继续正常采集传感器 ==========
    APP_LOG_INFO("%s [STEP 2] No water detected, proceeding with normal sensor collection", DEBUG_TAG);
    
    // 使用电源管理读取传感器数据
    ble_4g_sensor_data_t sensor_data;
    bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
    
    if (data_valid)
    {
        // 1. 更新当前传感器数据
        memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        
        // 2. 为当前传感器数据添加采集时间戳
        char timestamp[RTC_TIME_STRING_LEN];
        if (get_collection_timestamp_for_4g(timestamp)) {
            strncpy(s_current_sensor_data_4g.collect_time, timestamp, sizeof(s_current_sensor_data_4g.collect_time) - 1);
            s_current_sensor_data_4g.collect_time[sizeof(s_current_sensor_data_4g.collect_time) - 1] = '\0';
            APP_LOG_INFO("%s Collection timer: timestamp updated: %s", DEBUG_TAG, s_current_sensor_data_4g.collect_time);
        } else {
            APP_LOG_WARNING("%s Collection timer: failed to get RTC timestamp", DEBUG_TAG);
        }
        
        // 注意：水浸状态已在步骤1中读取并更新，此处不再重复读取
        
        // 3. 更新状态信息（103）- 使其与监测数据同步采集
        update_status_info_from_sources();
        
        // 4. 将当前数据存储到累积数组中
        if (s_collected_data_count < MAX_COLLECTED_DATA_COUNT)
        {
            memcpy(&s_collected_data_array[s_data_collection_index], &s_current_sensor_data_4g, 
                   sizeof(ble_4g_sensor_data_t));
            
            s_data_collection_index = (s_data_collection_index + 1) % MAX_COLLECTED_DATA_COUNT;
            s_collected_data_count++;
            
            APP_LOG_INFO("%s Data collected with power management and timestamp, count: %d", DEBUG_TAG, s_collected_data_count);
        }
        else
        {
            // 数组已满，覆盖最旧的数据
            memcpy(&s_collected_data_array[s_data_collection_index], &s_current_sensor_data_4g, 
                   sizeof(ble_4g_sensor_data_t));
            
            s_data_collection_index = (s_data_collection_index + 1) % MAX_COLLECTED_DATA_COUNT;
            
            APP_LOG_INFO("%s Data collected with timestamp, array full, overwriting old data", DEBUG_TAG);
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
    
    // 步骤1: 始终更新最新的状态信息 (103)
    update_status_info_from_sources();
    
    // 步骤2: 检查是否有已采集的传感器数据 (105)
    if (s_collected_data_count == 0)
    {
        APP_LOG_WARNING("%s No collected sensor data (105) to report.", DEBUG_TAG);
        
        // 检查当前是否处于水浸状态
        if (g_shared_params.device_water == 1) // 1 = WET
        {
            // 如果是水浸状态，说明没有105数据是正常的。此时只上报103状态信息即可。
            APP_LOG_INFO("%s In water alarm state. Reporting status info (103) only.", DEBUG_TAG);
            
            // 直接调用上传函数。该函数会发现没有105数据，但会发送最新的103状态信息。
            ble_4g_protocol_upload_with_power_mgmt();
        }
        else
        {
            // 如果不是水浸状态但依然没有数据，可能是设备刚启动或采集失败。
            // 尝试进行一次即时采集并上报。
            APP_LOG_INFO("%s Not in water alarm state. Attempting an immediate collection and report.", DEBUG_TAG);
            
            ble_4g_sensor_data_t sensor_data;
            bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
            
            if (data_valid)
            {
                memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
            }
            
            // 使用DTU电源管理上传单条数据
            ble_4g_protocol_upload_with_power_mgmt();
        }
    }
    else
    {
        // 如果有累积的传感器数据，正常上报所有数据
        APP_LOG_INFO("%s %d data points ready to report with DTU power management", DEBUG_TAG, s_collected_data_count);
        
        // 使用DTU电源管理上传所有累积数据
        ble_4g_protocol_upload_with_power_mgmt();
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
    
    // 初始化水浸传感器（初始状态断电，节能模式）
    APP_LOG_INFO("%s Initializing water sensor", DEBUG_TAG);
    if (water_sensor_init()) {
        APP_LOG_INFO("%s Water sensor initialized successfully (power saving mode)", DEBUG_TAG);
        // 读取初始状态并更新到共享参数（使用电源管理接口）
        uint8_t initial_water_status = water_sensor_read_with_power_mgmt();
        shared_params_set_device_water(initial_water_status);
        APP_LOG_INFO("%s Initial water sensor status (with power mgmt): %s (%d)", 
                     DEBUG_TAG, 
                     initial_water_status == 0 ? "DRY" : "WET", 
                     initial_water_status);
    } else {
        APP_LOG_ERROR("%s Failed to initialize water sensor", DEBUG_TAG);
    }
    
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
    
    // 执行RTC调试测试
    APP_LOG_INFO("%s Running RTC debug test during 4G protocol initialization", DEBUG_TAG);
    rtc_debug_test();
    
    // 初始化完成后执行首次上传（使用统一的电源管理流程）
    APP_LOG_INFO("%s Performing initial upload with power management", DEBUG_TAG);

    // 检查初始水浸状态，如果设备启动时就有水浸，则跳过首次传感器采集
    if (g_shared_params.device_water == 1) // 1 = WET
    {
        APP_LOG_WARNING("%s Device started in water alarm state. Skipping initial sensor data collection.", DEBUG_TAG);
        // 设置传感器状态为异常
        shared_params_set_sensor_status(1);
    }
    else
    {
        // 如果设备启动时无水浸，则执行首次传感器数据采集
        APP_LOG_INFO("%s No water alarm on init. Performing initial sensor data collection.", DEBUG_TAG);
        ble_4g_sensor_data_t sensor_data;
        bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
        if (data_valid)
        {
            memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        }
        else
        {
            APP_LOG_WARNING("%s Failed to read sensor data during init, using default data", DEBUG_TAG);
        }
    }

    // 2. 更新状态信息
    update_status_info_from_sources();

    // 3. 使用统一的电源管理流程进行首次上传
    APP_LOG_INFO("%s Executing initial upload with full power management cycle", DEBUG_TAG);
    ble_4g_protocol_upload_with_power_mgmt();
}

/**
 *****************************************************************************************
 * @brief Create JSON response for collect time setting (code 106).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_collect_time_response(int result, uint16_t collect_time)
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
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_COLLECT_TIME_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 如果成功，添加body
    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "collect_time_set", collect_time);
            cJSON_AddItemToObject(json, "body", body);
        }
    }
    
    // 添加result
    cJSON_AddNumberToObject(json, "result", result);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON response for update time setting (code 107).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_update_time_response(int result, uint16_t update_time)
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
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_UPDATE_TIME_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 如果成功，添加body
    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "updata_time_set", update_time);
            cJSON_AddItemToObject(json, "body", body);
        }
    }
    
    // 添加result
    cJSON_AddNumberToObject(json, "result", result);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON response for threshold setting (code 108).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_threshold_response(int result, float methane_threshold, 
                                                        int16_t temp_high, int16_t temp_low)
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
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_THRESHOLD_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 如果成功，添加body
    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "methane_threshold_set", methane_threshold);
            cJSON_AddNumberToObject(body, "TEMPH_threshold_set", temp_high);
            cJSON_AddNumberToObject(body, "TEMPL_threshold_set", temp_low);
            cJSON_AddItemToObject(json, "body", body);
        }
    }
    
    // 添加result
    cJSON_AddNumberToObject(json, "result", result);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON response for water threshold setting (code 110).
 *****************************************************************************************
 */
static char* ble_4g_protocol_create_water_threshold_response(int result, uint16_t water_threshold)
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
    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_WATER_THRESHOLD_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);
    
    // 如果成功，添加body
    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "water_threshold_set", water_threshold);
            cJSON_AddItemToObject(json, "body", body);
        }
    }
    
    // 添加result
    cJSON_AddNumberToObject(json, "result", result);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
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
    
    // 解析JSON
    cJSON *json = cJSON_Parse(json_str);
    if (json == NULL)
    {
        APP_LOG_ERROR("%s Failed to parse JSON", DEBUG_TAG);
        return;
    }
    
    // 解析header
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (header == NULL)
    {
        APP_LOG_ERROR("%s No header in JSON", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    // 获取并验证 device_ID
    cJSON *device_id_item = cJSON_GetObjectItem(header, "device_ID");
    if (device_id_item == NULL || !cJSON_IsString(device_id_item))
    {
        APP_LOG_ERROR("%s Invalid or missing device_ID in header", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    // 获取本机设备ID (IMEI)
    char local_device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(local_device_id, sizeof(local_device_id));
    
    // 比较 device_ID 是否匹配
    const char *received_device_id = device_id_item->valuestring;
    if (strcmp(local_device_id, received_device_id) != 0)
    {
        APP_LOG_WARNING("%s Device ID mismatch! Local: %s, Received: %s - Ignoring command", 
                        DEBUG_TAG, local_device_id, received_device_id);
        cJSON_Delete(json);
        return;
    }
    
    APP_LOG_INFO("%s Device ID verified: %s", DEBUG_TAG, local_device_id);
    
    // 获取命令代码
    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (code_item == NULL || !cJSON_IsNumber(code_item))
    {
        APP_LOG_ERROR("%s Invalid or missing code in header", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    int cmd_code = code_item->valueint;
    APP_LOG_INFO("%s Received command code: %d", DEBUG_TAG, cmd_code);
    
    // 解析body
    cJSON *body = cJSON_GetObjectItem(json, "body");
    
    // 根据命令代码处理不同的设置指令
    int result = PROTOCOL_4G_RESULT_SET_FAILED;
    char *response_json = NULL;
    
    switch (cmd_code)
    {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET: // 106 - 检测周期设置
        {
            if (body == NULL)
            {
                APP_LOG_ERROR("%s No body in collect time set command", DEBUG_TAG);
                break;
            }
            
            cJSON *collect_time_item = cJSON_GetObjectItem(body, "collect_time_set");
            if (collect_time_item == NULL || !cJSON_IsNumber(collect_time_item))
            {
                APP_LOG_ERROR("%s Invalid collect_time_set parameter", DEBUG_TAG);
                break;
            }
            
            uint16_t new_collect_time = (uint16_t)collect_time_item->valueint;
            APP_LOG_INFO("%s Setting collect time to: %d minutes", DEBUG_TAG, new_collect_time);
            
            // 参数范围验证 (1-1440分钟)
            if (new_collect_time >= 1 && new_collect_time <= 1440)
            {
                if (shared_params_set_collect_time(new_collect_time))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Collect time set successfully", DEBUG_TAG);
                    
                    // 重启采集定时器
                    ble_4g_protocol_restart_collect_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Failed to set collect time", DEBUG_TAG);
                }
            }
            else
            {
                APP_LOG_ERROR("%s Invalid collect time: %d (range: 1-1440)", DEBUG_TAG, new_collect_time);
            }
            
            // 创建响应
            response_json = ble_4g_protocol_create_collect_time_response(result, 
                                                                          g_shared_params.device_collect_time);
            break;
        }
        
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET: // 107 - 数据上报周期设置
        {
            if (body == NULL)
            {
                APP_LOG_ERROR("%s No body in update time set command", DEBUG_TAG);
                break;
            }
            
            cJSON *update_time_item = cJSON_GetObjectItem(body, "updata_time_set");
            if (update_time_item == NULL || !cJSON_IsNumber(update_time_item))
            {
                APP_LOG_ERROR("%s Invalid updata_time_set parameter", DEBUG_TAG);
                break;
            }
            
            uint16_t new_update_time = (uint16_t)update_time_item->valueint;
            APP_LOG_INFO("%s Setting update time to: %d minutes", DEBUG_TAG, new_update_time);
            
            // 参数范围验证 (1-1440分钟)
            if (new_update_time >= 1 && new_update_time <= 1440)
            {
                if (shared_params_set_update_time(new_update_time))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Update time set successfully", DEBUG_TAG);
                    
                    // 重启上报定时器
                    ble_4g_protocol_restart_report_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Failed to set update time", DEBUG_TAG);
                }
            }
            else
            {
                APP_LOG_ERROR("%s Invalid update time: %d (range: 1-1440)", DEBUG_TAG, new_update_time);
            }
            
            // 创建响应
            response_json = ble_4g_protocol_create_update_time_response(result, 
                                                                         g_shared_params.device_updata_time);
            break;
        }
        
        case PROTOCOL_4G_CMD_THRESHOLD_SET: // 108 - 甲烷及温度报警阈值设置
        {
            if (body == NULL)
            {
                APP_LOG_ERROR("%s No body in threshold set command", DEBUG_TAG);
                break;
            }
            
            cJSON *methane_item = cJSON_GetObjectItem(body, "methane_threshold_set");
            cJSON *temp_high_item = cJSON_GetObjectItem(body, "TEMPH_threshold_set");
            cJSON *temp_low_item = cJSON_GetObjectItem(body, "TEMPL_threshold_set");
            
            if (methane_item == NULL || !cJSON_IsNumber(methane_item) ||
                temp_high_item == NULL || !cJSON_IsNumber(temp_high_item) ||
                temp_low_item == NULL || !cJSON_IsNumber(temp_low_item))
            {
                APP_LOG_ERROR("%s Invalid threshold parameters", DEBUG_TAG);
                break;
            }
            
            float new_methane_threshold = (float)methane_item->valuedouble;
            int16_t new_temp_high = (int16_t)temp_high_item->valueint;
            int16_t new_temp_low = (int16_t)temp_low_item->valueint;
            
            APP_LOG_INFO("%s Setting thresholds: CH4=%.2f, TEMP_H=%d, TEMP_L=%d", 
                         DEBUG_TAG, new_methane_threshold, new_temp_high, new_temp_low);
            
            // 设置阈值
            if (shared_params_set_methane_threshold(new_methane_threshold) &&
                shared_params_set_temp_thresholds(new_temp_high, new_temp_low))
            {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Thresholds set successfully", DEBUG_TAG);
            }
            else
            {
                APP_LOG_ERROR("%s Failed to set thresholds", DEBUG_TAG);
            }
            
            // 创建响应
            response_json = ble_4g_protocol_create_threshold_response(result,
                                                                       g_shared_params.methane_threshold,
                                                                       g_shared_params.temp_high_threshold,
                                                                       g_shared_params.temp_low_threshold);
            break;
        }
        
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET: // 110 - 水浸报警阈值设置
        {
            if (body == NULL)
            {
                APP_LOG_ERROR("%s No body in water threshold set command", DEBUG_TAG);
                break;
            }
            
            cJSON *water_threshold_item = cJSON_GetObjectItem(body, "water_threshold_set");
            if (water_threshold_item == NULL || !cJSON_IsNumber(water_threshold_item))
            {
                APP_LOG_ERROR("%s Invalid water_threshold_set parameter", DEBUG_TAG);
                break;
            }
            
            uint16_t new_water_threshold = (uint16_t)water_threshold_item->valueint;
            APP_LOG_INFO("%s Setting water threshold to: %d", DEBUG_TAG, new_water_threshold);
            
            // 设置水浸阈值
            if (shared_params_set_water_threshold(new_water_threshold))
            {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Water threshold set successfully", DEBUG_TAG);
            }
            else
            {
                APP_LOG_ERROR("%s Failed to set water threshold", DEBUG_TAG);
            }
            
            // 创建响应
            response_json = ble_4g_protocol_create_water_threshold_response(result,
                                                                             g_shared_params.water_threshold);
            break;
        }
        
        default:
            APP_LOG_WARNING("%s Unknown command code: %d", DEBUG_TAG, cmd_code);
            break;
    }
    
    // 发送响应
    if (response_json != NULL)
    {
        APP_LOG_INFO("%s Sending response for command %d", DEBUG_TAG, cmd_code);
        send_json_with_delay(response_json, "parameter setting response");
    }
    
    // 清理
    cJSON_Delete(json);
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
    
    APP_LOG_INFO("%s Triggering immediate alarm upload due to threshold exceeded", DEBUG_TAG);
    
    // 更新当前传感器数据为报警数据
    memcpy(&s_current_sensor_data_4g, p_sensor_data, sizeof(ble_4g_sensor_data_t));
    
    // 更新状态信息
    update_status_info_from_sources();
    
    // 直接复用定时上传功能，包含完整的电源管理
    APP_LOG_INFO("%s Reusing scheduled upload function with power management for alarm", DEBUG_TAG);
    ble_4g_protocol_upload_with_power_mgmt();
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
    
    // 1. 打开总电源、传感器UART并上电传感器
    gpio_p_m_en_set(true);
    sensor_uart_open();
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
                            DEBUG_TAG, raw_data.status_code, raw_data.data_valid);
        }
        result = ble_4g_protocol_get_sensor_data_no_threshold_check(p_sensor_data);
    }
    else
    {
        APP_LOG_WARNING("%s Timeout waiting for sensor data, setting status to error", DEBUG_TAG);
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
            APP_LOG_INFO("%s Sensor data timestamp updated: %s", DEBUG_TAG, p_sensor_data->collect_time);
        } else {
            APP_LOG_WARNING("%s Failed to get RTC timestamp, using default", DEBUG_TAG);
        }
    }
    
    // 7. 断电传感器并关闭UART和总电源
    ble_4g_protocol_sensor_power_control(false);
    sensor_uart_close();
    gpio_p_m_en_set(false);
    
    if (result && data_received) {
        APP_LOG_INFO("%s Fresh sensor data read successfully with timestamp", DEBUG_TAG);
    } else if (result) {
        APP_LOG_WARNING("%s Using cached sensor data with timestamp", DEBUG_TAG);
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


/**
 *****************************************************************************************
 * @brief Query and cache key DTU information like IMEI and CSQ.
 * 
 * This function should only be called when the 4G module is powered on.
 *****************************************************************************************
 */
static void ble_4g_protocol_update_dtu_info_cache(void)
{
    APP_LOG_INFO("%s Updating DTU info cache (IMEI, CSQ)...", DEBUG_TAG);

    // 1. 强制获取并缓存IMEI
    (void)ble_4g_protocol_force_get_imei();

    // 2. 查询并缓存信号强度 (CSQ)
     const char* csq_cmd = "adminAT+CSQ\r\n";
     SEND_AT_COMMAND_ASYNC(csq_cmd);
     sys_delay_ms(500); // 等待AT响应

    // g_at_collector.signal_quality 会被AT命令处理器更新
    APP_LOG_INFO("%s CSQ updated to: %d", DEBUG_TAG, g_at_collector.signal_quality);

    // 3. 查询并缓存ICCID
     const char* iccid_cmd = "adminAT+ICCID?\r\n";
     SEND_AT_COMMAND_ASYNC(iccid_cmd);
     sys_delay_ms(500); // 等待AT响应
    APP_LOG_INFO("%s ICCID updated to: %s", DEBUG_TAG, g_at_collector.iccid);

    // 4. 查询并缓存GPS坐标
     const char* gps_cmd = "adminAT+GPS\r\n";
     SEND_AT_COMMAND_ASYNC(gps_cmd);
     sys_delay_ms(500); // 等待AT响应
    APP_LOG_INFO("%s GPS coordinate query sent.", DEBUG_TAG);
}

static void ble_4g_protocol_apply_server_config_if_needed(void)
{
    if (!s_server_config_changed)
    {
        APP_LOG_INFO("%s Server configuration not changed, skip DTU reconfig", DEBUG_TAG);
        return;
    }

    APP_LOG_INFO("%s Applying updated server configuration to DTU...", DEBUG_TAG);

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
    APP_LOG_INFO("%s Server configuration applied to DTU and flag cleared", DEBUG_TAG);
}

void ble_4g_protocol_mark_server_config_changed(void)
{
    s_server_config_changed = true;
    APP_LOG_INFO("%s Mark server configuration changed flag", DEBUG_TAG);
}

void ble_4g_protocol_upload_with_power_mgmt(void)
{
    APP_LOG_INFO("%s Starting upload with 4G/DTU power management", DEBUG_TAG);

    // 1. 打开4G UART并上电4G/DTU模块并等待稳定
    gpio_p_m_en_set(true);
    fourg_uart_open();
    gpio_4g_power_en_set(true);
    sys_delay_ms(10000);

    // 1.5 如果服务器配置有变更，优先下发新的服务器配置并保存到DTU
    ble_4g_protocol_apply_server_config_if_needed();

    // 2. 更新并缓存DTU关键信息（IMEI, CSQ）
    ble_4g_protocol_update_dtu_info_cache();

    // 3. 批量发送采集数据（先发动态，再发静态与查询）
    // 关键修复：只有在没有水浸的情况下才上报105数据
    if (g_shared_params.device_water == 0) // 0 = DRY
    {
        if (s_collected_data_count > 0)
        {
            // 从最旧的数据开始上报
            uint8_t total = s_collected_data_count;
            uint8_t start_index = (s_data_collection_index + MAX_COLLECTED_DATA_COUNT - s_collected_data_count) % MAX_COLLECTED_DATA_COUNT;
            APP_LOG_INFO("%s No water alarm. Uploading %d collected data points (105).", DEBUG_TAG, total);
            for (uint8_t i = 0; i < total; i++)
            {
                uint8_t current_index = (start_index + i) % MAX_COLLECTED_DATA_COUNT;
                // 发送 105 监测数据
                ble_4g_protocol_send_data_report(&s_collected_data_array[current_index]);
                // 每次105后都跟一个103状态信息
                ble_4g_protocol_send_status_info_report();
            }
            // 发送完批量数据后清空缓冲
            ble_4g_protocol_clear_collected_data();
        }
        else
        {
            // 如果没有累积数据，则发送当前数据（如果有效）
            APP_LOG_INFO("%s No collected data, sending current sensor data if valid", DEBUG_TAG);
            if (s_current_sensor_data_4g.is_valid)
            {
                ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);
            }
            ble_4g_protocol_send_status_info_report();
        }
    }
    else
    {
        // 如果有水浸，则只发送103状态报告
        APP_LOG_WARNING("%s Water alarm is active. Suppressing all 105 data reports. Sending status (103) only.", DEBUG_TAG);
        ble_4g_protocol_send_status_info_report();
    }

    // 4. 发送静态信息与参数信息、设置查询
    ble_4g_protocol_send_static_info();

    // 5. 等待平台可能下发的设置指令
    sys_delay_ms(10000);

    // 6. 断电4G/DTU模块并关闭UART
    gpio_4g_power_en_set(false);
    fourg_uart_close();
    gpio_p_m_en_set(false);
    APP_LOG_INFO("%s 4G/DTU module powered off", DEBUG_TAG);
}

