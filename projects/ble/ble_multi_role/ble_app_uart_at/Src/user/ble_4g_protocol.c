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
#include "wf5803f_driver.h"   // 为了使用水浸检测功能
#include "ble_4g_param_handler.h"  // 为了处理参数设置命令
#include "battery_voltage_reader.h"  // 为了使用电池电压读取功能
#include "user_periph_setup.h"       // 为了使用看门狗喂狗功能
#include "water_level_sensor.h"      // MER-MCP1081-22-150 电子水尺液位传感模组

/*
 * EXTERNAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
extern void gpio_4g_power_en_set(bool enable);
extern bool gpio_4g_power_en_get(void);
extern void gpio_p_m_en_set(bool enable);  // 外设电源域控制（参考备份版本）
extern void fourg_uart_open(void);
extern void fourg_uart_close(void);

// 前置声明 - 水浸模式控制函数
static void ble_4g_protocol_enter_flood_mode(void);
static void ble_4g_protocol_exit_flood_mode(void);
extern bool gpio_4g_power_en_get(void);

/**
 * @brief 带看门狗喂狗的延时函数
 * 
 * 每隔一定时间喂狗一次，避免长延时导致看门狗超时复位
 * 
 * @param total_ms 总延时时间(毫秒)
 */
static void delay_with_watchdog_feed(uint32_t total_ms)
{
    const uint32_t FEED_INTERVAL_MS = 5000;  // 每5秒喂狗一次
    
    while (total_ms > 0)
    {
        uint32_t delay_chunk = (total_ms > FEED_INTERVAL_MS) ? FEED_INTERVAL_MS : total_ms;
        sys_delay_ms(delay_chunk);
        watchdog_feed();  // 喂狗
        total_ms -= delay_chunk;
    }
}
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
// 优化：增大缓冲区以支持更长的上传周期（如采集1分钟，上传30分钟）
#define MAX_COLLECTED_DATA_COUNT 30  // 最大存储30次采集数据
static ble_4g_sensor_data_t s_collected_data_array[MAX_COLLECTED_DATA_COUNT];
static uint8_t s_collected_data_count = 0;
static uint8_t s_data_collection_index = 0;

// 延时发送机制
#define DELAYED_SEND_INTERVAL_MS 500  // 每条消息之间延迟500ms
static uint8_t s_send_data_index = 0;  // 当前发送的数据索引
static uint8_t s_total_data_to_send = 0;  // 总共需要发送的数据数量
static bool s_is_sending = false;  // 是否正在发送数据

// 水浸模式管理
static bool s_flood_mode_active = false;         // 是否处于水浸报警模式
static uint16_t s_normal_collect_interval = 60;  // 正常采集间隔（分钟），保存以便恢复
static uint16_t s_normal_upload_interval = 1440; // 正常上传间隔（分钟），保存以便恢复
static bool s_baseline_initialized = false;      // 基准压力是否已初始化
#define FLOOD_MODE_COLLECT_INTERVAL 3  // 水浸模式采集间隔（3分钟）
#define FLOOD_MODE_UPLOAD_INTERVAL 3   // 水浸模式上传间隔（3分钟）
// 水深阈值现在从共享参数获取，单位cm，默认5cm

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief 验证定时器参数合理性
 * 
 * @details 检查采集间隔和上传间隔的配置是否合理，避免缓冲区溢出
 * @return true 参数合理，false 参数不合理
 *****************************************************************************************
 */
static bool validate_timer_intervals(void)
{
    uint16_t collect_min = g_shared_params.device_collect_time;
    uint16_t upload_min = g_shared_params.device_updata_time;
    
    // 检查1：上传间隔应该 >= 采集间隔（推荐）
    if (upload_min < collect_min) {
        APP_LOG_WARNING("%s Upload interval (%d min) < Collect interval (%d min), "
                       "this may cause frequent DTU power cycles", 
                       DEBUG_TAG, upload_min, collect_min);
        // 注意：这不是错误，只是不推荐的配置
    }
    
    // 检查2：累积次数不应超过缓冲区
    if (collect_min == 0) {
        APP_LOG_ERROR("%s Collect interval is 0, invalid!", DEBUG_TAG);
        return false;
    }
    
    uint16_t estimated_count = upload_min / collect_min;
    if (estimated_count > MAX_COLLECTED_DATA_COUNT) {
        APP_LOG_ERROR("%s Estimated data count (%d) > buffer size (%d), data will be lost!", 
                     DEBUG_TAG, estimated_count, MAX_COLLECTED_DATA_COUNT);
        APP_LOG_ERROR("%s Please increase upload interval or decrease collect interval", DEBUG_TAG);
        return false;
    }
    
    // 参数合理
    APP_LOG_INFO("%s Timer intervals validated: collect=%d min, upload=%d min, estimated_count=%d/%d", 
                DEBUG_TAG, collect_min, upload_min, estimated_count, MAX_COLLECTED_DATA_COUNT);
    return true;
}

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
            strcpy(timestamp_buffer, "20240101000000");
            return false;
        }
    }
    
    // 直接获取格式化的时间字符串 "YYYYMMDDHHmmss"
    if (!bm8563_get_time_string(timestamp_buffer)) {
        APP_LOG_ERROR("%s Failed to get RTC time for 4G upload", DEBUG_TAG);
        strcpy(timestamp_buffer, "20000101000000");
        return false;
    }
    
    // 如果时间为默认值，记录警告但继续使用
    if (strncmp(timestamp_buffer, "2000", 4) == 0) {
        APP_LOG_WARNING("%s RTC time is default (%s), using default timestamp", DEBUG_TAG, timestamp_buffer);
    }
    
    // 验证时间戳格式和长度
    size_t len = strlen(timestamp_buffer);
    if (len != 14) {
        APP_LOG_WARNING("%s Invalid timestamp length: %d, expected 14. Timestamp: %s", 
                        DEBUG_TAG, len, timestamp_buffer);
        
        // 如果长度不对，尝试补零或截断
        if (len < 14) {
            // 长度不足，补零
            while (strlen(timestamp_buffer) < 14) {
                strcat(timestamp_buffer, "0");
            }
        } else if (len > 14) {
            // 长度过长，截断
            timestamp_buffer[14] = '\0';
        }
        APP_LOG_INFO("%s Corrected timestamp: %s", DEBUG_TAG, timestamp_buffer);
    }
    
    APP_LOG_INFO("%s Collection timestamp for 4G: %s", DEBUG_TAG, timestamp_buffer);
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
    // 注意：移除换行符发送，因为DTU可能将换行符作为消息结束标志导致解析异常
    free(json_string);
    
    // 标准化延时，等待DTU发送完成，避免JSON消息粘连
    sys_delay_ms(300);  // 恢复为300ms，与test2.0保持一致
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

/**
 *****************************************************************************************
 * @brief Mark that server configuration has been changed.
 *        This will trigger re-sending config to DTU on next power-up.
 *****************************************************************************************
 */
void ble_4g_protocol_mark_server_config_changed(void)
{
    APP_LOG_INFO("%s Server config marked as changed", DEBUG_TAG);
    // 这里可以设置一个标志位，下次上电时向DTU下发新配置
    // 目前仅记录日志，实际配置在shared_params中已经保存
}
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

    // 更新水浸状态和移动状态到共享参数
    shared_params_set_device_water(ble_status_info.device_status & 0x01);
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
    // sensor_pressure: 气压和水深 "pressure,water_depth" (hPa,cm)
    // 直接使用结构体中已计算好的水深值
    char pressure_str[32];
    snprintf(pressure_str, sizeof(pressure_str), "%.2f,%.1f", 
             p_data->pressure_hpa, p_data->water_depth_cm);
    cJSON_AddStringToObject(body, "sensor_pressure", pressure_str);
    
    cJSON_AddNumberToObject(body, "sensor_TEMP", p_data->temperature_c);
    
    char battery_str[32];
    snprintf(battery_str, sizeof(battery_str), "%.3f,%d", 
             p_data->battery_voltage, p_data->battery_percent);
    cJSON_AddStringToObject(body, "sensor_battery", battery_str);
    
    cJSON_AddStringToObject(body, "collect_time", p_data->collect_time);
    
    // 水位传感器数据 (MER-MCP1081-22-150 电子水尺)
    // water_level: "档位,水位高度cm,温度" 格式
    if (p_data->water_level_grade != 0xFF) {
        char water_level_str[48];
        snprintf(water_level_str, sizeof(water_level_str), "%d,%.1f,%.1f", 
                 p_data->water_level_grade, 
                 p_data->water_level_height_cm,
                 p_data->water_level_temp_c);
        cJSON_AddStringToObject(body, "water_level", water_level_str);
        
        // water_level_cap: "C0,C1,C2,C3,C4,C5,C6" 电容值(pF)
        char cap_str[128];
        snprintf(cap_str, sizeof(cap_str), "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f",
                 p_data->water_level_cap[0], p_data->water_level_cap[1],
                 p_data->water_level_cap[2], p_data->water_level_cap[3],
                 p_data->water_level_cap[4], p_data->water_level_cap[5],
                 p_data->water_level_cap[6]);
        cJSON_AddStringToObject(body, "water_level_cap", cap_str);
    }
    
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
    
    // 构建body - 参考2.0版本蓝牙协议的设备信息字段
    // IMEI
    if (strlen(g_at_collector.imei) > 0) {
        cJSON_AddStringToObject(body, "IMEI", g_at_collector.imei);
        cJSON_AddStringToObject(body, "device_ID", g_at_collector.imei);
    } else {
        cJSON_AddStringToObject(body, "IMEI", "0");
        cJSON_AddStringToObject(body, "device_ID", device_id);  // 降级使用MAC地址
    }
    
    // SIM_ID (ICCID)
    if (strlen(g_at_collector.iccid) > 0) {
        cJSON_AddStringToObject(body, "SIM_ID", g_at_collector.iccid);
    } else {
        cJSON_AddStringToObject(body, "SIM_ID", "0");
    }
    
    // 设备版本
    cJSON_AddStringToObject(body, "device_ver", s_device_info.device_ver);
    
    // 设备当前位置（GPS坐标）
    char location_str[64];
    snprintf(location_str, sizeof(location_str), "%.6f,%.6f",
            g_shared_params.location_lon, g_shared_params.location_lat);
    cJSON_AddStringToObject(body, "device_location", location_str);

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
    
    // 使用缓存的GPS数据（特殊字段不是所有位置都能替换）
    // 当前位置
    char location_str[48];
    if (strlen(g_at_collector.longitude) > 0 && strlen(g_at_collector.latitude) > 0) {
        snprintf(location_str, sizeof(location_str), "%s,%s", 
                 g_at_collector.longitude, g_at_collector.latitude);
    } else {
        snprintf(location_str, sizeof(location_str), "%.6f,%.6f", 
                 g_shared_params.location_lon, g_shared_params.location_lat);
    }
    cJSON_AddStringToObject(body, "device_location", location_str);
    
    // 安装位置（使用保存的安装坐标）
    char install_location_str[48];
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
    cJSON_AddNumberToObject(body, "water_depth_threshold_cm", g_shared_params.water_depth_threshold_cm);
    cJSON_AddNumberToObject(body, "TEMPH_threshold", g_shared_params.temp_high_threshold);
    cJSON_AddNumberToObject(body, "TEMPL_threshold", g_shared_params.temp_low_threshold);
    cJSON_AddNumberToObject(body, "water_threshold", g_shared_params.water_threshold);  // 兼容旧版
    
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
        
        // 2. 为当前传感器数据添加采集时间戳
        char timestamp[RTC_TIME_STRING_LEN];
        if (get_collection_timestamp_for_4g(timestamp)) {
            strncpy(s_current_sensor_data_4g.collect_time, timestamp, sizeof(s_current_sensor_data_4g.collect_time) - 1);
            s_current_sensor_data_4g.collect_time[sizeof(s_current_sensor_data_4g.collect_time) - 1] = '\0';
            APP_LOG_INFO("%s Collection timer: timestamp updated: %s", DEBUG_TAG, s_current_sensor_data_4g.collect_time);
        } else {
            APP_LOG_WARNING("%s Collection timer: failed to get RTC timestamp", DEBUG_TAG);
        }
        
        // 2.5 ✅ 首次数据采集成功后，设置水浸检测基准压力
        if (!s_baseline_initialized) {
            APP_LOG_INFO("%s Setting flood detection baseline from first reading...", DEBUG_TAG);
            if (wf5803f_set_baseline_pressure(0.0f)) {  // 0表示使用当前读数
                s_baseline_initialized = true;
                float baseline = wf5803f_get_baseline_pressure();
                APP_LOG_INFO("%s Baseline pressure initialized: %.2f hPa", DEBUG_TAG, baseline);
            } else {
                APP_LOG_ERROR("%s Failed to initialize baseline pressure", DEBUG_TAG);
            }
        }
        
        // 3. ✨ 水浸检测和模式切换（混合策略）
        // 从共享参数获取水深阈值(cm)，转换为压力阈值(hPa)
        float water_depth_cm = shared_params_get_water_depth_threshold();
        float pressure_threshold_hpa = wf5803f_water_depth_to_pressure(water_depth_cm);
        
        bool flood_detected_single = wf5803f_detect_flood(pressure_threshold_hpa);
        
        // ✅ 简化水浸检测：直接使用滤波后的缓存数据判断，不再进行多次采样确认
        // （因为传感器已经deinit省电，无法进行多次采样）
        if (flood_detected_single && !s_flood_mode_active) {
            // 检测到水浸，进入报警模式
            APP_LOG_WARNING("%s ⚠️ FLOOD DETECTED! Water depth exceeds threshold. Entering flood mode...", DEBUG_TAG);
            ble_4g_protocol_enter_flood_mode();
            shared_params_set_device_water(1);
        } else if (!flood_detected_single && s_flood_mode_active) {
            // 水浸消除，退出报警模式
            APP_LOG_INFO("%s [OK] Flood cleared. Exiting flood mode...", DEBUG_TAG);
            ble_4g_protocol_exit_flood_mode();
            shared_params_set_device_water(0);
        }
        
        // ✅ 额外保护：验证水浸模式下采集/上传时间是否正确
        if (s_flood_mode_active) {
            bool need_fix = false;
            if (g_shared_params.device_collect_time != FLOOD_MODE_COLLECT_INTERVAL) {
                APP_LOG_WARNING("%s Flood mode: collect time incorrect (%d != %d), fixing...", 
                               DEBUG_TAG, g_shared_params.device_collect_time, FLOOD_MODE_COLLECT_INTERVAL);
                g_shared_params.device_collect_time = FLOOD_MODE_COLLECT_INTERVAL;
                need_fix = true;
            }
            if (g_shared_params.device_updata_time != FLOOD_MODE_UPLOAD_INTERVAL) {
                APP_LOG_WARNING("%s Flood mode: upload time incorrect (%d != %d), fixing...", 
                               DEBUG_TAG, g_shared_params.device_updata_time, FLOOD_MODE_UPLOAD_INTERVAL);
                g_shared_params.device_updata_time = FLOOD_MODE_UPLOAD_INTERVAL;
                need_fix = true;
            }
            if (need_fix) {
                APP_LOG_INFO("%s Restarting timers with correct flood mode intervals", DEBUG_TAG);
                ble_4g_protocol_restart_collect_timer();
                ble_4g_protocol_restart_report_timer();
            }
        }
        
        // 4. 更新状态信息（103）- 使其与监测数据同步采集
        update_status_info_from_sources();
        
        // 5. 将当前数据存储到累积数组中
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
    
    // 更新状态信息
    update_status_info_from_sources();
    
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
        
        // 使用DTU电源管理上传单条数据
        ble_4g_protocol_upload_with_power_mgmt();
    }
    else
    {
        APP_LOG_INFO("%s %d data points ready to report with DTU power management", DEBUG_TAG, s_collected_data_count);
        
        // 使用DTU电源管理上传所有累积数据（不在这里清空，在上传函数内部处理）
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
    
    // 注意：4G模块电源状态由main.c控制，这里不再关闭
    // 参考备份版本：保持main.c中已开启的4G模块状态
    
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
    
    // 执行RTC调试测试
    APP_LOG_INFO("%s Running RTC debug test during 4G protocol initialization", DEBUG_TAG);
    rtc_debug_test();
    
    // ⚠️ 基准压力设置移至首次数据采集后（此时传感器已上电）
    // 避免在初始化阶段设置（传感器可能断电导致读取失败）
    APP_LOG_INFO("%s Flood detection baseline will be set after first sensor reading", DEBUG_TAG);
    
    // 保存初始正常间隔（用于水浸模式恢复）
    s_normal_collect_interval = g_shared_params.device_collect_time;
    s_normal_upload_interval = g_shared_params.device_updata_time;
    APP_LOG_INFO("%s Saved initial intervals: collect=%d min, upload=%d min",
                 DEBUG_TAG, s_normal_collect_interval, s_normal_upload_interval);
    
    // 初始化完成后执行首次上传（使用统一的电源管理流程）
    APP_LOG_INFO("%s Performing initial upload with power management", DEBUG_TAG);

    // 1. 读取传感器数据
    ble_4g_sensor_data_t sensor_data;
    bool data_valid = ble_4g_protocol_read_sensor_with_power_mgmt(&sensor_data);
    if (data_valid)
    {
        memcpy(&s_current_sensor_data_4g, &sensor_data, sizeof(ble_4g_sensor_data_t));
        
        // ✅ 1.5. 开机启动时设置基准压力（使用首次读数）
        APP_LOG_INFO("%s Setting flood detection baseline from boot reading...", DEBUG_TAG);
        if (wf5803f_set_baseline_pressure(0.0f)) {  // 0表示使用当前读数
            s_baseline_initialized = true;
            float baseline = wf5803f_get_baseline_pressure();
            APP_LOG_INFO("%s Baseline pressure initialized at boot: %.2f hPa", DEBUG_TAG, baseline);
        } else {
            APP_LOG_ERROR("%s Failed to initialize baseline pressure at boot", DEBUG_TAG);
        }
    }
    else
    {
        APP_LOG_WARNING("%s Failed to read sensor data during init, using default data", DEBUG_TAG);
        // update_sensor_data_from_parser();
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

    // 解析服务器下发的设置命令
    cJSON *json = cJSON_Parse(json_str);
    if (json == NULL)
    {
        APP_LOG_ERROR("%s Failed to parse JSON", DEBUG_TAG);
        return;
    }

    // 提取header中的code
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (header == NULL)
    {
        APP_LOG_WARNING("%s No header in JSON", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }

    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (code_item == NULL || !cJSON_IsNumber(code_item))
    {
        APP_LOG_WARNING("%s No valid code in header", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }

    int cmd_code = code_item->valueint;
    cJSON *body = cJSON_GetObjectItem(json, "body");

    APP_LOG_INFO("%s Received command code: %d", DEBUG_TAG, cmd_code);

    // 处理参数设置命令 (106-110)
    char *response = NULL;
    switch (cmd_code)
    {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET:    // 106
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:     // 107
        case PROTOCOL_4G_CMD_THRESHOLD_SET:       // 108
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET: // 110
            response = ble_4g_param_process_json_command(cmd_code, body);
            break;
        default:
            APP_LOG_INFO("%s Unhandled command code: %d", DEBUG_TAG, cmd_code);
            break;
    }

    cJSON_Delete(json);

    // 发送响应
    if (response)
    {
        APP_LOG_INFO("%s Sending response for cmd %d", DEBUG_TAG, cmd_code);
        // 发送JSON响应，末尾添加换行符触发DTU立即发送
        uart1_tx_data_send((uint8_t*)response, strlen(response));
        uart1_tx_data_send((uint8_t*)"\r\n", 2);  // 添加回车换行符作为消息分隔
        sys_delay_ms(2000);  // 等待DTU发送完成（DTU打包超时约1秒）
        free(response);
    }
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
                        APP_LOG_INFO("%s Set collect interval: %d minutes", DEBUG_TAG, new_interval);
                        
                        // 验证参数合理性
                        if (validate_timer_intervals())
                        {
                            result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                            
                            // ✅ 修复：如果处于水浸模式，保存为正常间隔但不重启定时器
                            if (s_flood_mode_active) {
                                s_normal_collect_interval = new_interval;
                                APP_LOG_INFO("%s In flood mode, saved as normal interval (timer stays at 3min)", DEBUG_TAG);
                            } else {
                                // 立即重启采集定时器
                                ble_4g_protocol_restart_collect_timer();
                            }
                        }
                        else
                        {
                            APP_LOG_ERROR("%s Timer interval validation failed, reverting...", DEBUG_TAG);
                            result = PROTOCOL_4G_RESULT_SET_FAILED;
                            // 这里可以选择恢复旧值，但为了简化暂时只是标记失败
                        }
                    }
                    else
                    {
                        result = PROTOCOL_4G_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set collect interval", DEBUG_TAG);
                    }
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
                        APP_LOG_INFO("%s Set report interval: %d minutes", DEBUG_TAG, new_interval);
                        
                        // 验证参数合理性
                        if (validate_timer_intervals())
                        {
                            result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                            
                            // ✅ 修复：如果处于水浸模式，保存为正常间隔但不重启定时器
                            if (s_flood_mode_active) {
                                s_normal_upload_interval = new_interval;
                                APP_LOG_INFO("%s In flood mode, saved as normal interval (timer stays at 3min)", DEBUG_TAG);
                            } else {
                                // 立即重启上报定时器
                                ble_4g_protocol_restart_report_timer();
                            }
                        }
                        else
                        {
                            APP_LOG_ERROR("%s Timer interval validation failed, reverting...", DEBUG_TAG);
                            result = PROTOCOL_4G_RESULT_SET_FAILED;
                            // 这里可以选择恢复旧值，但为了简化暂时只是标记失败
                        }
                    }
                    else
                    {
                        result = PROTOCOL_4G_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set report interval", DEBUG_TAG);
                    }
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
                // 解析水深阈值和温度阈值（兼容原格式：4字节水深 + 2字节高温 + 2字节低温）
                float water_depth_thresh_cm;
                int16_t temp_high, temp_low;
                memcpy(&water_depth_thresh_cm, &p_data[0], 4);
                memcpy(&temp_high, &p_data[4], 2);
                memcpy(&temp_low, &p_data[6], 2);
                
                // 使用共享参数API设置阈值
                if (shared_params_set_water_depth_threshold(water_depth_thresh_cm) && 
                    shared_params_set_temp_thresholds(temp_high, temp_low))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set thresholds: WaterDepth=%.2fcm, TEMP_H=%d°C, TEMP_L=%d°C", 
                               DEBUG_TAG, water_depth_thresh_cm, temp_high, temp_low);
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

float ble_4g_protocol_pressure_to_depth(float pressure_delta_hpa)
{
    // 压力到水深转换: 1cm水深约等于0.98hPa压力变化
    if (pressure_delta_hpa <= 0.0f) return 0.0f;
    return pressure_delta_hpa / WATER_DEPTH_HPA_PER_CM;
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
 * 
 * @note Currently unused, preserved for future use.
 *****************************************************************************************
 */
#if 0  // Temporarily disabled to suppress compiler warning
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
#endif

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
        p_param_settings->water_depth_threshold_cm = g_shared_params.water_depth_threshold_cm;
        p_param_settings->TEMPH_threshold = g_shared_params.temp_high_threshold;
        p_param_settings->TEMPL_threshold = g_shared_params.temp_low_threshold;
        p_param_settings->water_threshold = g_shared_params.water_threshold;  // 兼容旧版
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
    sys_delay_ms(500);  // 避免JSON粘连
    
    // 发送参数信息报告 (code 104)
    APP_LOG_INFO("%s Sending param info report (code 104) - static info", DEBUG_TAG);
    ble_4g_protocol_send_param_info_report();
    sys_delay_ms(500);  // 避免JSON粘连
    
    // 发送设置查询 (code 120)
    APP_LOG_INFO("%s Sending settings query (code 120)", DEBUG_TAG);
    ble_4g_protocol_send_settings_query();
    sys_delay_ms(500);  // 避免JSON粘连
}

/*
 * POWER MANAGEMENT FUNCTIONS
 *****************************************************************************************
 */

void ble_4g_protocol_sensor_power_control(bool enable)
{
    // 只控制 S_EN(GPIO25)，P_M_EN是外设电源域总开关，由main.c统一管理
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
    delay_with_watchdog_feed(5000);  // 等待5秒确保传感器上电稳定，并定期喂狗
    
    // ✅ 2.5 初始化WF5803F I2C驱动（必须在读取前初始化！）
    if (!wf5803f_init()) {
        APP_LOG_ERROR("%s Failed to initialize WF5803F sensor", DEBUG_TAG);
        ble_4g_protocol_sensor_power_control(false);
        return false;
    }
    
    // ✅ 2.6 初始化并立即读取水位传感器 MER-MCP1081-22-150（UART0, Modbus-RTU）
    // 必须在初始化后立即读取，不能等太久
    water_level_data_t wl_data = {0};
    water_level_cap_data_t wl_cap_data = {0};
    bool wl_read_success = false;
    
    if (water_level_sensor_init()) {
        sys_delay_ms(200);  // 等待传感器通信稳定
        APP_LOG_INFO("%s Reading water level sensor (MER-MCP1081-22-150)...", DEBUG_TAG);
        
        if (water_level_sensor_read_basic(&wl_data) && wl_data.is_valid) {
            APP_LOG_INFO("%s Water level: Grade=%d, Temp=%.1fC", DEBUG_TAG, 
                         wl_data.level_grade, wl_data.temperature_c);
            
            // 读取C0-C6电容值
            if (water_level_sensor_read_capacitance(&wl_cap_data) && wl_cap_data.is_valid) {
                APP_LOG_INFO("%s Cap: C0=%.2f C1=%.2f C2=%.2f C3=%.2f C4=%.2f C5=%.2f C6=%.2f pF", DEBUG_TAG,
                             wl_cap_data.c_pf[0], wl_cap_data.c_pf[1], wl_cap_data.c_pf[2],
                             wl_cap_data.c_pf[3], wl_cap_data.c_pf[4], wl_cap_data.c_pf[5], wl_cap_data.c_pf[6]);
            }
            wl_read_success = true;
        } else {
            APP_LOG_WARNING("%s Failed to read water level sensor", DEBUG_TAG);
        }
        
        // 读取完成后立即反初始化UART0（避免与其他UART0使用冲突）
        water_level_sensor_deinit();
    } else {
        APP_LOG_WARNING("%s Failed to initialize water level sensor", DEBUG_TAG);
    }
    
    // ✅ 3. 主动通过I2C读取WF5803F传感器数据（问答式）
    // 不再等待自动发送，直接主动读取
    // 使用无电源管理版本（因为这里已经上电了，避免重复上电浪费10秒）
    APP_LOG_INFO("%s Actively reading WF5803F sensor via I2C...", DEBUG_TAG);
    sensor_data_t raw_data = {0};
    bool data_valid = sensor_data_read_no_power_mgmt(&raw_data);  // ✅ 避免重复上电！
    
    // 4. 处理读取结果
    bool result = false;
    if (data_valid)
    {
        APP_LOG_INFO("%s Fresh sensor data read successfully", DEBUG_TAG);
        
        // 转换为4G协议格式
        p_sensor_data->pressure_hpa = raw_data.pressure_hpa;
        p_sensor_data->altitude_m = raw_data.altitude_m;
        p_sensor_data->temperature_c = raw_data.temperature_c;
        p_sensor_data->battery_voltage = 0.0f;  // 电池电压将在后续填充
        p_sensor_data->battery_percent = 0;     // 电池百分比将在后续填充
        p_sensor_data->is_valid = true;
        
        // ✅ 修复：使用统一的水深计算函数（与蓝牙保持一致，使用滤波后的压力值）
        p_sensor_data->water_depth_cm = sensor_data_get_water_depth();
        APP_LOG_INFO("%s Water depth (filtered): %.1f cm", DEBUG_TAG, p_sensor_data->water_depth_cm);
        
        // 更新传感器状态为正常
        shared_params_set_sensor_status(0);
        result = true;
    }
    else
    {
        APP_LOG_WARNING("%s Failed to read sensor data", DEBUG_TAG);
        
        // 设置无效数据
        p_sensor_data->pressure_hpa = 0.0f;
        p_sensor_data->altitude_m = 0.0f;
        p_sensor_data->temperature_c = 0.0f;
        p_sensor_data->battery_voltage = 0.0f;
        p_sensor_data->battery_percent = 0;
        p_sensor_data->is_valid = false;
        
        // 更新传感器状态为异常
        shared_params_set_sensor_status(1);
        result = false;
    }
    
    // 5. 获取采集时间戳并更新到传感器数据中
    if (p_sensor_data != NULL) {
        char timestamp[RTC_TIME_STRING_LEN];
        if (get_collection_timestamp_for_4g(timestamp)) {
            strncpy(p_sensor_data->collect_time, timestamp, sizeof(p_sensor_data->collect_time) - 1);
            p_sensor_data->collect_time[sizeof(p_sensor_data->collect_time) - 1] = '\0';
            APP_LOG_INFO("%s Sensor data timestamp: %s", DEBUG_TAG, p_sensor_data->collect_time);
        } else {
            APP_LOG_WARNING("%s Failed to get RTC timestamp, using default", DEBUG_TAG);
            strcpy(p_sensor_data->collect_time, "20000101000000");
        }
        
        // ✅ 修复：读取电池电压数据（解决定时采集时电池数据为0的问题）
        APP_LOG_INFO("%s Reading battery voltage...", DEBUG_TAG);
        battery_voltage_data_t battery_data = {0};
        if (battery_voltage_reader_get_voltage(&battery_data) && battery_data.is_valid) {
            p_sensor_data->battery_voltage = battery_data.battery_voltage;
            p_sensor_data->battery_percent = battery_data.battery_percent;
            APP_LOG_INFO("%s Battery data: %.3fV, %d%%", DEBUG_TAG, 
                         battery_data.battery_voltage, battery_data.battery_percent);
        } else {
            APP_LOG_WARNING("%s Failed to read battery voltage, using default", DEBUG_TAG);
            p_sensor_data->battery_voltage = 3.3f;   // 默认值
            p_sensor_data->battery_percent = 100;     // 默认值
        }
        
        // ✅ 使用前面已读取的水位传感器数据
        if (wl_read_success) {
            p_sensor_data->water_level_grade = wl_data.level_grade;
            p_sensor_data->water_level_temp_c = wl_data.temperature_c;
            p_sensor_data->water_level_height_cm = WLS_GRADE_TO_CM(wl_data.level_grade);
            
            // 复制电容值
            for (int i = 0; i < 7; i++) {
                p_sensor_data->water_level_cap[i] = wl_cap_data.c_pf[i];
            }
        } else {
            p_sensor_data->water_level_grade = 0xFF;  // 无效值
            p_sensor_data->water_level_temp_c = 0.0f;
            p_sensor_data->water_level_height_cm = 0.0f;
            for (int i = 0; i < 7; i++) {
                p_sensor_data->water_level_cap[i] = 0.0f;
            }
        }
    }
    
    // 6. 反初始化并断电传感器
    wf5803f_deinit();
    // 注：water_level_sensor已在读取后立即反初始化
    ble_4g_protocol_sensor_power_control(false);
    
    if (result) {
        APP_LOG_INFO("%s Fresh sensor data read successfully with timestamp", DEBUG_TAG);
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
    sys_delay_ms(300);  // 避免JSON粘连

    APP_LOG_INFO("%s Uploading: sending status info (code 103)", DEBUG_TAG);
    ble_4g_protocol_send_status_info_report();
    sys_delay_ms(300);  // 避免JSON粘连

    // 2. 发送静态信息
    APP_LOG_INFO("%s Uploading: sending device info (code 102)", DEBUG_TAG);
    ble_4g_protocol_send_device_info_report();
    sys_delay_ms(300);  // 避免JSON粘连

    APP_LOG_INFO("%s Uploading: sending param info (code 104)", DEBUG_TAG);
    ble_4g_protocol_send_param_info_report();
    sys_delay_ms(300);  // 避免JSON粘连

    // 3. 发送设置查询
    APP_LOG_INFO("%s Uploading: sending settings query (code 120)", DEBUG_TAG);
    ble_4g_protocol_send_settings_query();
    sys_delay_ms(300);  // 避免JSON粘连

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

void ble_4g_protocol_upload_with_power_mgmt(void)
{
    APP_LOG_INFO("%s Starting upload with 4G/DTU power management", DEBUG_TAG);

    // 1. 打开UART1并上电4G/DTU模块（参考备份版本）
    gpio_p_m_en_set(true);  // 开启外设电源域
    fourg_uart_open();  // 动态打开UART1
    gpio_4g_power_en_set(true);
    delay_with_watchdog_feed(10000);  // 等待4G模块启动，并定期喂狗

    // 2. 更新并缓存DTU关键信息（IMEI, CSQ）
    ble_4g_protocol_update_dtu_info_cache();

    // 3. 批量发送采集数据（先发动态，再发静态与查询）
    if (s_collected_data_count > 0)
    {
        // 从最旧的数据开始上报
        uint8_t total = s_collected_data_count;
        uint8_t start_index = (s_data_collection_index + MAX_COLLECTED_DATA_COUNT - s_collected_data_count) % MAX_COLLECTED_DATA_COUNT;
        APP_LOG_INFO("%s Uploading %d collected data points", DEBUG_TAG, total);
        for (uint8_t i = 0; i < total; i++)
        {
            uint8_t current_index = (start_index + i) % MAX_COLLECTED_DATA_COUNT;
            // 发送 105 监测数据
            ble_4g_protocol_send_data_report(&s_collected_data_array[current_index]);
            sys_delay_ms(300);  // 每条数据发送后等待，确保传输完成
            // 每次105后都跟一个103状态信息
            ble_4g_protocol_send_status_info_report();
            sys_delay_ms(300);  // 状态信息发送后也等待
            
            // ✅ 每5条数据喂狗一次，防止批量上传时看门狗超时
            if ((i + 1) % 5 == 0) {
                watchdog_feed();
                APP_LOG_DEBUG("%s Watchdog fed after %d data points", DEBUG_TAG, i + 1);
            }
        }
        // 发送完批量数据后清空缓冲
        ble_4g_protocol_clear_collected_data();
    }
    else
    {
        // 没有累积数据，发送当前数据
     //   APP_LOG_INFO("%s No collected data, sending current snapshot", DEBUG_TAG);
        ble_4g_protocol_send_data_report(&s_current_sensor_data_4g);
      sys_delay_ms(300);  // 等待数据发送完成
        ble_4g_protocol_send_status_info_report();
       sys_delay_ms(300);  // 等待状态信息发送完成
    }

    // 4. 发送静态信息与参数信息、设置查询
    ble_4g_protocol_send_static_info();

    // 5. 等待平台可能下发的设置指令
    delay_with_watchdog_feed(10000);  // 等待平台下发指令，并定期喂狗

    // 6. 断电4G/DTU模块并关闭UART1省电
    gpio_4g_power_en_set(false);
    fourg_uart_close();  // 关闭UART1省电
    APP_LOG_INFO("%s 4G/DTU module and UART1 powered off", DEBUG_TAG);
}

/**
 *****************************************************************************************
 * @brief Check for flood condition and handle mode switching.
 *****************************************************************************************
 */
bool ble_4g_protocol_check_and_handle_flood(void)
{
    // 使用WF5803F驱动的水浸检测功能
    // 从共享参数获取水深阈值(cm)，转换为压力阈值(hPa)
    float water_depth_cm = shared_params_get_water_depth_threshold();
    float pressure_threshold_hpa = wf5803f_water_depth_to_pressure(water_depth_cm);
    bool flood_detected = wf5803f_detect_flood(pressure_threshold_hpa);
    
    if (flood_detected && !s_flood_mode_active) {
        // 水浸发生，进入报警模式
        APP_LOG_WARNING("%s ⚠️ FLOOD DETECTED! Entering flood alarm mode...", DEBUG_TAG);
        ble_4g_protocol_enter_flood_mode();
        
        // 更新水浸状态
        shared_params_set_device_water(1);
        
        return true;
    }
    else if (!flood_detected && s_flood_mode_active) {
        // 水浸消除，恢复正常模式
        APP_LOG_INFO("%s [OK] Flood cleared. Exiting flood alarm mode...", DEBUG_TAG);
        ble_4g_protocol_exit_flood_mode();
        
        // 更新水浸状态
        shared_params_set_device_water(0);
        
        return false;
    }
    
    return flood_detected;
}

/**
 *****************************************************************************************
 * @brief Enter flood alarm mode (3-minute intervals).
 *****************************************************************************************
 */
static void ble_4g_protocol_enter_flood_mode(void)
{
    if (s_flood_mode_active) {
        APP_LOG_WARNING("%s Already in flood mode", DEBUG_TAG);
        return;
    }
    
    APP_LOG_WARNING("%s ====== ENTERING FLOOD ALARM MODE ======", DEBUG_TAG);
    
    // 1. 保存当前正常间隔
    s_normal_collect_interval = g_shared_params.device_collect_time;
    s_normal_upload_interval = g_shared_params.device_updata_time;
    
    APP_LOG_INFO("%s Saved normal intervals: collect=%d min, upload=%d min",
                 DEBUG_TAG, s_normal_collect_interval, s_normal_upload_interval);
    
    // 2. 切换到水浸模式间隔（3分钟）
    g_shared_params.device_collect_time = FLOOD_MODE_COLLECT_INTERVAL;
    g_shared_params.device_updata_time = FLOOD_MODE_UPLOAD_INTERVAL;
    
    APP_LOG_WARNING("%s Flood mode intervals: collect=%d min, upload=%d min",
                    DEBUG_TAG, FLOOD_MODE_COLLECT_INTERVAL, FLOOD_MODE_UPLOAD_INTERVAL);
    
    // 3. 保存参数到Flash（确保蓝牙和4G查询时获取正确值）
    extern bool shared_params_save_to_flash(void);
    if (shared_params_save_to_flash()) {
        APP_LOG_INFO("%s Flood mode intervals saved to Flash", DEBUG_TAG);
    } else {
        APP_LOG_ERROR("%s Failed to save flood mode intervals to Flash", DEBUG_TAG);
    }
    
    // 4. 重启定时器以应用新间隔
    ble_4g_protocol_restart_collect_timer();
    ble_4g_protocol_restart_report_timer();
    
    // 4. 标记为水浸模式
    s_flood_mode_active = true;
    
    APP_LOG_WARNING("%s ====== FLOOD MODE ACTIVATED ======", DEBUG_TAG);
}

/**
 *****************************************************************************************
 * @brief Exit flood alarm mode (restore normal intervals).
 *****************************************************************************************
 */
static void ble_4g_protocol_exit_flood_mode(void)
{
    if (!s_flood_mode_active) {
        APP_LOG_INFO("%s Not in flood mode, nothing to exit", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s ====== EXITING FLOOD ALARM MODE ======", DEBUG_TAG);
    
    // 1. 恢复正常间隔
    g_shared_params.device_collect_time = s_normal_collect_interval;
    g_shared_params.device_updata_time = s_normal_upload_interval;
    
    APP_LOG_INFO("%s Restored normal intervals: collect=%d min, upload=%d min",
                 DEBUG_TAG, s_normal_collect_interval, s_normal_upload_interval);
    
    // 2. 保存参数到Flash（关键：确保蓝牙和4G查询时获取正确值）
    extern bool shared_params_save_to_flash(void);
    if (shared_params_save_to_flash()) {
        APP_LOG_INFO("%s Normal intervals saved to Flash", DEBUG_TAG);
    } else {
        APP_LOG_ERROR("%s Failed to save normal intervals to Flash", DEBUG_TAG);
    }
    
    // 3. 重启定时器以应用恢复的间隔
    ble_4g_protocol_restart_collect_timer();
    ble_4g_protocol_restart_report_timer();
    
    // 3. 清除水浸模式标志
    s_flood_mode_active = false;
    
    APP_LOG_INFO("%s ====== NORMAL MODE RESTORED ======", DEBUG_TAG);
}

/**
 *****************************************************************************************
 * @brief Check if system is currently in flood mode.
 *****************************************************************************************
 */
bool ble_4g_protocol_is_flood_mode(void)
{
    return s_flood_mode_active;
}












