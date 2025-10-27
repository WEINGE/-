/**
 *****************************************************************************************
 *
 * @file ble_protocol.c
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
#include "ble_protocol.h"
#include "ble_4g_protocol.h"
#include "shared_params.h"  // 添加共享参数头文件
#include "user_app.h"
#include "sensor_data_parser.h"
#include "cJSON.h"
#include "app_log.h"
#include "app_error.h"
#include "app_uart.h"
#include "board_SK.h"
#include "transport_scheduler.h"
#include "gr55xx_delay.h"
#include "gr55xx_sys.h"
#include "user_periph_setup.h"  // 包含uart1_tx_data_send声明
#include "bm8563_rtc.h"         // RTC时间管理模块，用于时间同步功能

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

/*
 * FORWARD DECLARATIONS
 *****************************************************************************************
 */

static void parse_at_command_response(const char* response, uint16_t length);
static char* ble_protocol_create_query_response(uint8_t query_type);


void ble_protocol_send_json_response(const char *p_json_str);

/*
 * DEFINES
 *****************************************************************************************
 */
// 便捷宏：异步发送AT命令到4G模块，适用于时钟不稳定环境
#define SEND_AT_COMMAND_ASYNC(cmd) do { \
    uart1_tx_data_send((uint8_t*)(cmd), strlen(cmd)); \
} while(0)
#define DEBUG_TAG                   "[4G_PROTOCOL]"
#define JSON_BUFFER_SIZE            1024
#define DEVICE_ID_SIZE              32

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static ble_sensor_data_t s_current_sensor_data = {0};
static device_info_t s_device_info = {0};
static status_info_t s_status_info = {0};
static bool s_protocol_initialized = false;
static char s_device_id[DEVICE_ID_SIZE] = {0};

// 4G响应缓冲区
static char g_4g_response_buffer[512];


// AT指令响应收集器实例（类型定义在 ble_protocol.h 中）
at_response_collector_t g_at_collector = {0};

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */



/**
 *****************************************************************************************
 * @brief 处理4G模块响应数据
 *****************************************************************************************
 */
static void handle_4g_response(const char* response, uint16_t length)
{
    // 超级指令和普通AT指令的响应格式完全相同，统一按AT响应处理
    parse_at_command_response(response, length);
}

/*
 *****************************************************************************************
 * @brief 解析设备信息超级指令响应 - 暂未使用
 *****************************************************************************************
 */
/*
static void parse_super_device_info_response(const char* response, uint16_t length)
{
    APP_LOG_INFO("%s Parsing super device info response", DEBUG_TAG);
    
    // 示例超级指令响应格式: SUPER_RESP_DEVICE_INFO:IMEI=123456789012345,ICCID=89860123456789012345,LAT=39.9042,LON=116.4074
    
    // 提取IMEI
    const char* imei_start = strstr(response, "IMEI=");
    if (imei_start)
    {
        imei_start += 5; // 跳过"IMEI="
        const char* imei_end = strchr(imei_start, ',');
        if (imei_end)
        {
            int imei_len = imei_end - imei_start;
            if (imei_len < sizeof(s_device_info.device_id))
            {
                strncpy(s_device_info.device_id, imei_start, imei_len);
                s_device_info.device_id[imei_len] = '\0';
                APP_LOG_INFO("%s Got IMEI: %s", DEBUG_TAG, s_device_info.device_id);
            }
        }
    }
    
    // 提取ICCID
    const char* iccid_start = strstr(response, "ICCID=");
    if (iccid_start)
    {
        iccid_start += 6; // 跳过"ICCID="
        const char* iccid_end = strchr(iccid_start, ',');
        if (iccid_end)
        {
            int iccid_len = iccid_end - iccid_start;
            // TODO: 存储ICCID到适当的变量中
            APP_LOG_INFO("%s Got ICCID: %.*s", DEBUG_TAG, iccid_len, iccid_start);
        }
    }
    
    // 提取GPS坐标
    const char* lat_start = strstr(response, "LAT=");
    const char* lon_start = strstr(response, "LON=");
    if (lat_start && lon_start)
    {
        lat_start += 4; // 跳过"LAT="
        lon_start += 4; // 跳过"LON="
        
        float lat = atof(lat_start);
        float lon = atof(lon_start);
        shared_params_set_location(lat, lon);
        APP_LOG_INFO("%s Got GPS: lat=%.6f, lon=%.6f", DEBUG_TAG, lat, lon);
    }
    
    // 发送设备信息查询响应
    char *json_string = ble_protocol_create_query_response(PROTOCOL_QUERY_TYPE_DEVICE_INFO);
    if (json_string)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);
    }
}
*/

/*
 *****************************************************************************************
 * @brief 解析状态信息超级指令响应 - 暂未使用
 *****************************************************************************************
 */
/*
static void parse_super_status_info_response(const char* response, uint16_t length)
{
    APP_LOG_INFO("%s Parsing super status info response", DEBUG_TAG);
    
    // 示例超级指令响应格式: SUPER_RESP_STATUS_INFO:SIGNAL=25,NET_STATUS=1,GPS_STATUS=1,WATER=0,MOVE=0
    
    // 提取信号强度
    const char* signal_start = strstr(response, "SIGNAL=");
    if (signal_start)
    {
        signal_start += 7; // 跳过"SIGNAL="
        s_status_info.communication_status = atoi(signal_start);
        APP_LOG_INFO("%s Got signal strength: %d", DEBUG_TAG, s_status_info.communication_status);
    }
    
    // 提取网络状态
    const char* net_start = strstr(response, "NET_STATUS=");
    if (net_start)
    {
        net_start += 11; // 跳过"NET_STATUS="
        int net_status = atoi(net_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFE) | (net_status & 0x01);
        APP_LOG_INFO("%s Got network status: %d", DEBUG_TAG, net_status);
    }
    
    // 提取GPS状态
    const char* gps_start = strstr(response, "GPS_STATUS=");
    if (gps_start)
    {
        gps_start += 11; // 跳过"GPS_STATUS="
        int gps_status = atoi(gps_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFB) | ((gps_status & 0x01) << 2);
        APP_LOG_INFO("%s Got GPS status: %d", DEBUG_TAG, gps_status);
    }
    
    // 提取水浸状态
    const char* water_start = strstr(response, "WATER=");
    if (water_start)
    {
        water_start += 6; // 跳过"WATER="
        int water_status = atoi(water_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFE) | (water_status & 0x01);
        APP_LOG_INFO("%s Got water status: %d", DEBUG_TAG, water_status);
    }
    
    // 提取防盗状态
    const char* move_start = strstr(response, "MOVE=");
    if (move_start)
    {
        move_start += 5; // 跳过"MOVE="
        int move_status = atoi(move_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFD) | ((move_status & 0x01) << 1);
        APP_LOG_INFO("%s Got move status: %d", DEBUG_TAG, move_status);
    }
    
    // 发送状态信息查询响应
    char *json_string = ble_protocol_create_query_response(PROTOCOL_QUERY_TYPE_STATUS_INFO);
    if (json_string)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);
    }
}
*/

/**
 *****************************************************************************************
 * @brief 解析AT指令响应
 *****************************************************************************************
 */
static void parse_at_command_response(const char* response, uint16_t length)
{
    APP_LOG_INFO("%s Parsing AT command response", DEBUG_TAG);
    APP_LOG_INFO("%s AT response: %.*s", DEBUG_TAG, length, response);
    
    // 跳过空行和OK响应
    if (length == 0 || strncmp(response, "OK", 2) == 0 || 
        strncmp(response, "ERROR", 5) == 0 || response[0] == '\0')
    {
        APP_LOG_DEBUG("%s Skipping empty/status response: %.*s", DEBUG_TAG, length, response);
        return;
    }
    
    // 处理超级指令的回显（如：AT+IMEI?）
    if (strncmp(response, "AT+", 3) == 0)
    {
        APP_LOG_DEBUG("%s Received command echo: %.*s", DEBUG_TAG, length, response);
        return; // 跳过命令回显
    }
    
    // 解析AT指令响应，格式为 +TYPE:VALUE
    
    if (strncmp(response, "+CSQ:", 5) == 0)
    {
        // 信号质量: +CSQ:27,0 (格式: rssi,ber)
        int rssi, ber;
        if (sscanf(response + 5, "%d,%d", &rssi, &ber) == 2)
        {
            // 验证rssi范围 (0-31, 99表示未知)
            if ((rssi >= 0 && rssi <= 31) || rssi == 99)
            {
                g_at_collector.signal_quality = rssi;
                APP_LOG_INFO("%s Collected signal quality: RSSI=%d, BER=%d", DEBUG_TAG, rssi, ber);
            }
            else
            {
                APP_LOG_WARNING("%s Invalid RSSI value: %d", DEBUG_TAG, rssi);
                g_at_collector.signal_quality = 0; // 默认值
            }
        }
        else if (sscanf(response + 5, "%d", &rssi) == 1)
        {
            // 兼容只有一个数字的情况
            if ((rssi >= 0 && rssi <= 31) || rssi == 99)
            {
                g_at_collector.signal_quality = rssi;
                APP_LOG_INFO("%s Collected signal quality (single value): %d", DEBUG_TAG, rssi);
            }
            else
            {
                APP_LOG_WARNING("%s Invalid signal quality value: %d", DEBUG_TAG, rssi);
                g_at_collector.signal_quality = 0;
            }
        }
    }
    else if (strncmp(response, "+VER:", 5) == 0)
    {
        // 固件版本: +VER:V1.0.0
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), 
                "\"firmware_version\":\"%s\"", response + 5);
        // g_4g_response_len = strlen(g_4g_response_buffer); // 暂未使用
        APP_LOG_INFO("%s Parsed firmware version: %s", DEBUG_TAG, response + 5);
    }
    else if (strncmp(response, "+BUILD:", 7) == 0)
    {
        // 编译时间: +BUILD:Nov  6 2023 19:52:47
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), 
                "\"build_time\":\"%s\"", response + 7);
        // g_4g_response_len = strlen(g_4g_response_buffer); // 暂未使用
        APP_LOG_INFO("%s Parsed build time: %s", DEBUG_TAG, response + 7);
    }
    else if (strncmp(response, "+SN:", 4) == 0)
    {
        // SN码: +SN:2022020287653698
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), 
                "\"serial_number\":\"%s\"", response + 4);
        // g_4g_response_len = strlen(g_4g_response_buffer); // 暂未使用
        APP_LOG_INFO("%s Parsed serial number: %s", DEBUG_TAG, response + 4);
    }
    else if (strncmp(response, "+IMEI:", 6) == 0)
    {
        // IMEI: +IMEI:86433******2457
        strncpy(g_at_collector.imei, response + 6, sizeof(g_at_collector.imei) - 1);
        g_at_collector.imei[sizeof(g_at_collector.imei) - 1] = '\0';
        APP_LOG_INFO("%s Collected IMEI: %s", DEBUG_TAG, g_at_collector.imei);
    }
    else if (strncmp(response, "+ICCID:", 7) == 0)
    {
        // ICCID: +ICCID:89860***********1314 或 +ICCID:SIM not inserted
        strncpy(g_at_collector.iccid, response + 7, sizeof(g_at_collector.iccid) - 1);
        g_at_collector.iccid[sizeof(g_at_collector.iccid) - 1] = '\0';
        APP_LOG_INFO("%s Collected ICCID: %s", DEBUG_TAG, g_at_collector.iccid);
    }

    else if (strncmp(response, "+CCLK:", 6) == 0)
    {
        // 固定格式: +CCLK:YYYY/MM/DD,HH:MM:SS （无引号、无时区）


        const char* time_data = response + 6; // 跳过“+CCLK:”

        // 直接使用 bm8563_set_time_from_network 函数解析并设置时间
        if (!bm8563_set_time_from_network(time_data))
        {
            APP_LOG_ERROR("%s Failed to synchronize RTC time from DTU: %s", DEBUG_TAG, time_data);
        }
    }
    else if (strncmp(response, "+GPS:", 5) == 0)
    {
        // GPS位置: +GPS:0,0 或 +GPS:39.9042,116.4074
        if (sscanf(response + 5, "%15[^,],%15s", g_at_collector.latitude, g_at_collector.longitude) == 2)
        {
            // 检查是否是有效坐标
            float lat = atof(g_at_collector.latitude);
            float lon = atof(g_at_collector.longitude);
            
            if (lat == 0.0f && lon == 0.0f)
            {
                g_at_collector.gps_status = 1;  // GPS异常
                APP_LOG_INFO("%s GPS not positioned: %s,%s", DEBUG_TAG, g_at_collector.latitude, g_at_collector.longitude);
            }
            else
            {
                g_at_collector.gps_status = 0;  // GPS正常
                APP_LOG_INFO("%s Collected GPS: LAT=%s, LON=%s", DEBUG_TAG, g_at_collector.latitude, g_at_collector.longitude);
            }
        }
    }
    else if (strncmp(response, "+CREG:", 6) == 0)
    {
        // 网络注册状态: +CREG:1 (1=已注册, 0=未注册)
        int reg_status;
        if (sscanf(response + 6, "%d", &reg_status) == 1)
        {
            g_at_collector.network_reg_status = reg_status;
            APP_LOG_INFO("%s Collected network registration status: %d (%s)", 
                        DEBUG_TAG, reg_status, 
                        (reg_status == 1) ? "Registered" : "Not registered");
        }
        else
        {
            APP_LOG_WARNING("%s Failed to parse CREG response: %s", DEBUG_TAG, response);
            g_at_collector.network_reg_status = 0; // 默认为未注册
        }
    }

    else
    {
        // 如果没有匹配的解析器，存储原始响应
        if (length < sizeof(g_4g_response_buffer))
        {
            memcpy(g_4g_response_buffer, response, length);
            g_4g_response_buffer[length] = '\0';
            // g_4g_response_len = length; // 暂未使用
            APP_LOG_INFO("%s Stored raw response", DEBUG_TAG);
        }
    }
}



/**
 *****************************************************************************************
 * @brief Get device ID (MAC address).
 *****************************************************************************************
 */
static void ble_protocol_get_device_id(void)
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
static void ble_protocol_init_device_info(void)
{
    strcpy(s_device_info.device_id, s_device_id);
    strcpy(s_device_info.device_name, "GR5515_Gas_Detector");
    strcpy(s_device_info.firmware_version, "1.0.0");
    strcpy(s_device_info.hardware_version, "1.0");
    strcpy(s_device_info.manufacturer, "Goodix");
}

/**
 *****************************************************************************************
 * @brief Initialize status information.
 *****************************************************************************************
 */
static void ble_protocol_init_status_info(void)
{
    s_status_info.device_status = 1;        // 设备正常
    s_status_info.sensor_status = 1;        // 传感器正常
    s_status_info.communication_status = 1; // 通信正常
    s_status_info.power_status = 1;         // 电源正常
}

/**
 *****************************************************************************************
 * @brief Initialize parameter settings.
 *****************************************************************************************
 */
static void ble_protocol_init_param_settings(void)
{
    // 使用共享参数模块统一管理参数
    shared_params_init();
    APP_LOG_INFO("%s Parameter settings initialized via shared_params", DEBUG_TAG);
}

/**
 *****************************************************************************************
 * @brief Create JSON data report.
 *****************************************************************************************
 */
static char* ble_protocol_create_json_report(const ble_sensor_data_t *p_data)
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
    
    // 构建header - 符合BLE协议格式
    cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_DATA_REPORT);
    cJSON_AddItemToObject(json, "header", header);
    
    // 构建body - 符合BLE协议格式
    // sensor_methane: 字符串格式 "vol,lel"
    char methane_str[32];
    snprintf(methane_str, sizeof(methane_str), "%.2f,%.1f", 
             p_data->methane_vol, p_data->methane_lel);
    cJSON_AddStringToObject(body, "sensor_methane", methane_str);
    
    // sensor_TEMP: 整数类型
    cJSON_AddNumberToObject(body, "sensor_TEMP", (int)p_data->temperature);
    
    // sensor_battery: 字符串格式 "voltage,percent"
    char battery_str[32];
    snprintf(battery_str, sizeof(battery_str), "%.2f,%d", 
             p_data->battery_voltage, p_data->battery_percent);
    cJSON_AddStringToObject(body, "sensor_battery", battery_str);
    
    // collect_time: 数据收集时间（4G协议要求，蓝牙协议中不包含但为了兼容性添加）
    // 格式：YYYYMMDDHHMM，例如："202411141642"
    char time_str[16];
    // TODO: 获取实际时间戳，这里使用示例格式
    snprintf(time_str, sizeof(time_str), "202411141642");
    cJSON_AddStringToObject(body, "collect_time", time_str);
    
    cJSON_AddItemToObject(json, "body", body);
    
    // 添加result字段 - 符合BLE协议格式
    cJSON_AddNumberToObject(json, "result", PROTOCOL_RESULT_AUTO_REPORT);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON query response.
 *****************************************************************************************
 */
static char* ble_protocol_create_query_response(uint8_t query_type)
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
    
    // 根据查询类型设置不同的code
    int response_code = 102; // 默认设备信息上报
    int lte_signal; // 声明在switch之前避免编译警告
    ble_4g_status_info_t ble_4g_status = {0}; // 声明在switch之前避免编译警告
    switch (query_type)
    {
        case PROTOCOL_QUERY_TYPE_DEVICE_INFO:
            response_code = 102; // 设备信息上报
            // 按照蓝牙协议文档3.2的字段名称
            // 使用AT收集器中的IMEI，如果没有则使用默认值
            if (strlen(g_at_collector.imei) > 0) {
                cJSON_AddStringToObject(body, "IMEI", g_at_collector.imei);
                cJSON_AddStringToObject(body, "device_ID", g_at_collector.imei);
            } else {
                cJSON_AddStringToObject(body, "IMEI", "0");
                cJSON_AddStringToObject(body, "device_ID", s_device_info.device_id);  // 降级使用MAC地址
            }
            // 使用AT收集器中的ICCID，如果没有则使用默认值"0"
            if (strlen(g_at_collector.iccid) > 0) {
                cJSON_AddStringToObject(body, "SIM_ID", g_at_collector.iccid);
            } else {
                cJSON_AddStringToObject(body, "SIM_ID", "0");
            }
            cJSON_AddStringToObject(body, "device_ver", s_device_info.firmware_version);
            // 组合经纬度字符串
            char location_str[64];
            snprintf(location_str, sizeof(location_str), "%.6f,%.6f", 
                    g_shared_params.location_lon, g_shared_params.location_lat);
            cJSON_AddStringToObject(body, "device_location", location_str);
            break;
            
        case PROTOCOL_QUERY_TYPE_STATUS_INFO:
            response_code = 103; // 状态信息上报
            // 按照蓝牙协议文档3.3的字段名称
            cJSON_AddNumberToObject(body, "device_water", g_shared_params.device_water); // 水浸状态
            cJSON_AddNumberToObject(body, "sensor_status", g_shared_params.sensor_status);
            cJSON_AddNumberToObject(body, "device_move", g_shared_params.device_move); // 防盗状态
            // 使用与4G协议相同的信号值获取逻辑，确保数据一致性
            // 优先从4G协议模块获取已更新的信号值
            ble_4g_protocol_get_status_info(&ble_4g_status);
            lte_signal = ble_4g_status.device_LTE_signal;
            // 如果4G模块的信号值为0，尝试使用AT收集器的值作为备用
            if (lte_signal == 0 && g_at_collector.signal_quality > 0 && g_at_collector.signal_quality != 99) {
                lte_signal = g_at_collector.signal_quality;
                APP_LOG_INFO("%s Using AT collector signal as fallback: %d", DEBUG_TAG, lte_signal);
            }
            APP_LOG_INFO("%s Status query - 4G signal: %d, AT signal: %d, final: %d", 
                        DEBUG_TAG, ble_4g_status.device_LTE_signal, g_at_collector.signal_quality, lte_signal);
            cJSON_AddNumberToObject(body, "device_LTE_signal", lte_signal);
            cJSON_AddNumberToObject(body, "device_GPS_status", g_shared_params.device_GPS_status); // GPS状态
            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_INFO:
            response_code = 104; // 当前设置参数上报
            // 按照蓝牙协议文档3.4的字段名称
            cJSON_AddNumberToObject(body, "device_collect_time", g_shared_params.device_collect_time);
            cJSON_AddNumberToObject(body, "device_updata_time", g_shared_params.device_updata_time);
            // 甲烷阈值改为float类型（协议V1.4更新）
            cJSON_AddNumberToObject(body, "methane_threshold", g_shared_params.methane_threshold);
            cJSON_AddNumberToObject(body, "TEMPH_threshold", g_shared_params.temp_high_threshold);
            cJSON_AddNumberToObject(body, "TEMPL_threshold", g_shared_params.temp_low_threshold);
            cJSON_AddNumberToObject(body, "water_threshold", g_shared_params.water_threshold);
            break;
            
        case PROTOCOL_QUERY_TYPE_CURRENT_DATA:
            response_code = 105; // 监测数据上报
            update_sensor_data_from_parser();
            // 按照蓝牙协议文档3.5的字段名称
            // 组合甲烷数据字符串 "vol,lel"
            char methane_str[32];
            snprintf(methane_str, sizeof(methane_str), "%.2f,%.1f", 
                    s_current_sensor_data.methane_vol, s_current_sensor_data.methane_lel);
            cJSON_AddStringToObject(body, "sensor_methane", methane_str);
            cJSON_AddNumberToObject(body, "sensor_TEMP", (int)s_current_sensor_data.temperature);
            // 组合电池信息字符串 "电压,百分比" - 使用update_sensor_data_from_parser()中已更新的真实电池数据
            char battery_str[32];
            snprintf(battery_str, sizeof(battery_str), "%.2f,%d", 
                    s_current_sensor_data.battery_voltage, s_current_sensor_data.battery_percent);
            cJSON_AddStringToObject(body, "sensor_battery", battery_str);
            break;
            
        default:
            response_code = 102;
            cJSON_AddStringToObject(body, "error", "unknown_query_type");
            break;
    }
    
    // 构建蓝牙协议标准格式：{"header":{"code":xxx},"body":{...},"result":1}
    cJSON_AddNumberToObject(header, "code", response_code);
    cJSON_AddItemToObject(json, "header", header);
    cJSON_AddItemToObject(json, "body", body);
    cJSON_AddNumberToObject(json, "result", PROTOCOL_RESULT_QUERY_RESPONSE); // 1:查询指令回文
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Create JSON parameter set response.
 *****************************************************************************************
 */
static char* ble_protocol_create_param_set_response(uint16_t cmd_code, uint8_t result)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON object", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        if (body) cJSON_Delete(body);
        return NULL;
    }
    
    // 构建标准格式：{"header":{"code":xxx},"body":{...},"result":x}
    cJSON_AddNumberToObject(header, "code", cmd_code);
    cJSON_AddItemToObject(json, "header", header);
    
    // 如果设置成功，添加相应的body内容；如果失败，只返回result
    if (result == 0) // 设置成功
    {
        // 根据不同的命令代码添加相应的body内容
        switch (cmd_code)
        {
            case 106: // 检测周期设置
                cJSON_AddNumberToObject(body, "collect_time_set", g_shared_params.device_collect_time);
                break;
            case 107: // 上报周期设置
                cJSON_AddNumberToObject(body, "updata_time_set", g_shared_params.device_updata_time);
                break;
            case 108: // 甲烷及温度报警阈值设置
                // 甲烷阈值改为float类型（协议V1.4更新）
                cJSON_AddNumberToObject(body, "methane_threshold_set", g_shared_params.methane_threshold);
                cJSON_AddNumberToObject(body, "TEMPH_threshold_set", g_shared_params.temp_high_threshold);
                cJSON_AddNumberToObject(body, "TEMPL_threshold_set", g_shared_params.temp_low_threshold);
                break;
            case 109: // 安装坐标设置
                {
                    char coordinate_str[64];
                    snprintf(coordinate_str, sizeof(coordinate_str), "%.6f,%.6f", 
                            g_shared_params.location_lon, g_shared_params.location_lat);
                    cJSON_AddStringToObject(body, "coordinate", coordinate_str);
                }
                break;
            case 110: // 水浸报警阈值设置
                cJSON_AddNumberToObject(body, "water_threshold_set", g_shared_params.water_threshold);
                break;
            case 111: // 服务器地址设置
                cJSON_AddStringToObject(body, "server_address", g_shared_params.server_address);
                break;
        }
        cJSON_AddItemToObject(json, "body", body);
    }
    else
    {
        cJSON_Delete(body); // 失败时不需要body
    }
    
    cJSON_AddNumberToObject(json, "result", result);
    
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/**
 *****************************************************************************************
 * @brief Parse JSON protocol command and handle accordingly.
 *****************************************************************************************
 */
static void ble_protocol_parse_json_command(const char* json_str)
{
    cJSON *json = cJSON_Parse(json_str);
    if (json == NULL)
    {
        APP_LOG_ERROR("%s Failed to parse JSON: %s", DEBUG_TAG, json_str);
        return;
    }
    
    // 解析header
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (header == NULL)
    {
        APP_LOG_ERROR("%s Missing header in JSON", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (code_item == NULL || !cJSON_IsNumber(code_item))
    {
        APP_LOG_ERROR("%s Missing or invalid code in header", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    uint16_t cmd_code = (uint16_t)code_item->valueint;
    APP_LOG_INFO("%s Received command code: %d", DEBUG_TAG, cmd_code);
    
    // 解析body
    cJSON *body = cJSON_GetObjectItem(json, "body");
    if (body == NULL)
    {
        APP_LOG_ERROR("%s Missing body in JSON", DEBUG_TAG);
        cJSON_Delete(json);
        return;
    }
    
    switch (cmd_code)
    {
        case PROTOCOL_CMD_QUERY:
        {
            cJSON *type_item = cJSON_GetObjectItem(body, "type");
            if (type_item == NULL || !cJSON_IsNumber(type_item))
            {
                APP_LOG_ERROR("%s Missing or invalid type in query body", DEBUG_TAG);
                break;
            }
            
            uint8_t query_type = (uint8_t)type_item->valueint;
            APP_LOG_INFO("%s Processing query type: %d", DEBUG_TAG, query_type);
            ble_protocol_handle_query(query_type);
            break;
        }
        
        case PROTOCOL_CMD_COLLECT_TIME_SET:
        {
            // 按照蓝牙协议文档3.6，字段名为 collect_time_set
            cJSON *interval_item = cJSON_GetObjectItem(body, "collect_time_set");
            if (interval_item == NULL || !cJSON_IsNumber(interval_item))
            {
                APP_LOG_ERROR("%s Missing or invalid collect_time_set in body", DEBUG_TAG);
                // 按照协议文档3.6格式发送失败回文
                cJSON *response = cJSON_CreateObject();
                cJSON *header = cJSON_CreateObject();
                
                cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_COLLECT_TIME_SET);
                cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                
                cJSON_AddItemToObject(response, "header", header);
                
                char *json_string = cJSON_Print(response);
                if (json_string) {
                    ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                    free(json_string);
                }
                cJSON_Delete(response);
                break;
            }
            
            uint16_t interval = (uint16_t)interval_item->valueint;
            uint8_t data[2] = {(uint8_t)(interval >> 8), (uint8_t)(interval & 0xFF)};
            ble_protocol_handle_param_set(cmd_code, data, 2);
            
            // 按照协议文档3.6格式发送成功回文
            cJSON *response = cJSON_CreateObject();
            cJSON *header = cJSON_CreateObject();
            cJSON *body = cJSON_CreateObject();
            
            cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_COLLECT_TIME_SET);
            cJSON_AddNumberToObject(body, "collect_time_set", interval);
            cJSON_AddNumberToObject(response, "result", 0); // 0:设置成功
            
            cJSON_AddItemToObject(response, "header", header);
            cJSON_AddItemToObject(response, "body", body);
            
            char *json_string = cJSON_Print(response);
            if (json_string) {
                ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                APP_LOG_INFO("%s Collect time set response sent", DEBUG_TAG);
                free(json_string);
            }
            cJSON_Delete(response);
            break;
        }
        
        case PROTOCOL_CMD_UPDATE_TIME_SET:
        {
            // 按照蓝牙协议文档3.7，字段名为 updata_time_set
            cJSON *interval_item = cJSON_GetObjectItem(body, "updata_time_set");
            if (interval_item == NULL || !cJSON_IsNumber(interval_item))
            {
                APP_LOG_ERROR("%s Missing or invalid updata_time_set in body", DEBUG_TAG);
                // 按照协议文档3.7格式发送失败回文
                cJSON *response = cJSON_CreateObject();
                cJSON *header = cJSON_CreateObject();
                
                cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_UPDATE_TIME_SET);
                cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                
                cJSON_AddItemToObject(response, "header", header);
                
                char *json_string = cJSON_Print(response);
                if (json_string) {
                    ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                    free(json_string);
                }
                cJSON_Delete(response);
                break;
            }
            
            uint16_t interval = (uint16_t)interval_item->valueint;
            uint8_t data[2] = {(uint8_t)(interval >> 8), (uint8_t)(interval & 0xFF)};
            ble_protocol_handle_param_set(cmd_code, data, 2);
            
            // 按照协议文档3.7格式发送成功回文
            cJSON *response = cJSON_CreateObject();
            cJSON *header = cJSON_CreateObject();
            cJSON *body = cJSON_CreateObject();
            
            cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_UPDATE_TIME_SET);
            cJSON_AddNumberToObject(body, "updata_time_set", interval);
            cJSON_AddNumberToObject(response, "result", 0); // 0:设置成功
            
            cJSON_AddItemToObject(response, "header", header);
            cJSON_AddItemToObject(response, "body", body);
            
            char *json_string = cJSON_Print(response);
            if (json_string) {
                ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                APP_LOG_INFO("%s Update time set response sent", DEBUG_TAG);
                free(json_string);
            }
            cJSON_Delete(response);
            break;
        }
        
        case PROTOCOL_CMD_THRESHOLD_SET:
        {
            // 按照蓝牙协议文档3.8，字段名为 methane_threshold_set, TEMPH_threshold_set, TEMPL_threshold_set
            cJSON *methane_item = cJSON_GetObjectItem(body, "methane_threshold_set");
            cJSON *temp_h_item = cJSON_GetObjectItem(body, "TEMPH_threshold_set");
            cJSON *temp_l_item = cJSON_GetObjectItem(body, "TEMPL_threshold_set");
            
            if (methane_item == NULL || !cJSON_IsNumber(methane_item) ||
                temp_h_item == NULL || !cJSON_IsNumber(temp_h_item) ||
                temp_l_item == NULL || !cJSON_IsNumber(temp_l_item))
            {
                APP_LOG_ERROR("%s Missing or invalid thresholds in threshold set", DEBUG_TAG);
                break;
            }
            
            float methane_threshold = (float)methane_item->valuedouble;
            int16_t temp_h_threshold = (int16_t)temp_h_item->valueint;
            int16_t temp_l_threshold = (int16_t)temp_l_item->valueint;
            
            uint8_t data[8];
            memcpy(&data[0], &methane_threshold, 4);
            memcpy(&data[4], &temp_h_threshold, 2);
            memcpy(&data[6], &temp_l_threshold, 2);
            ble_protocol_handle_param_set(cmd_code, data, 8);
            break;
        }
        
        case PROTOCOL_CMD_LOCATION_SET:
        {
            // 按照蓝牙协议文档3.9，字段名为 location_set 和 coordinate
            cJSON *location_set_item = cJSON_GetObjectItem(body, "location_set");
            cJSON *coordinate_item = cJSON_GetObjectItem(body, "coordinate");
            
            if (location_set_item == NULL || !cJSON_IsNumber(location_set_item) ||
                coordinate_item == NULL || !cJSON_IsString(coordinate_item))
            {
                APP_LOG_ERROR("%s Missing or invalid location parameters in location set", DEBUG_TAG);
                break;
            }
            
            int location_set = location_set_item->valueint;
            const char* coordinate_str = coordinate_item->valuestring;
            
            // 解析经纬度字符串 "longitude,latitude"
            float longitude, latitude;
            if (sscanf(coordinate_str, "%f,%f", &longitude, &latitude) != 2)
            {
                APP_LOG_ERROR("%s Invalid coordinate format: %s", DEBUG_TAG, coordinate_str);
                break;
            }
            
            uint8_t data[12];
            memcpy(&data[0], &location_set, 4);
            memcpy(&data[4], &longitude, 4);
            memcpy(&data[8], &latitude, 4);
            ble_protocol_handle_param_set(cmd_code, data, 12);
            break;
        }
        
        case PROTOCOL_CMD_WATER_THRESHOLD_SET:
        {
            cJSON *threshold_item = cJSON_GetObjectItem(body, "threshold");
            if (threshold_item == NULL || !cJSON_IsNumber(threshold_item))
            {
                APP_LOG_ERROR("%s Missing or invalid threshold in water threshold set", DEBUG_TAG);
                break;
            }
            
            float threshold = (float)threshold_item->valuedouble;
            uint8_t data[4];
            memcpy(&data[0], &threshold, 4);
            ble_protocol_handle_param_set(cmd_code, data, 4);
            break;
        }
        
        case PROTOCOL_CMD_SERVER_ADDRESS_SET:
        {
            cJSON *address_item = cJSON_GetObjectItem(body, "address");
            if (address_item == NULL || !cJSON_IsString(address_item))
            {
                APP_LOG_ERROR("%s Missing or invalid address in server address set", DEBUG_TAG);
                break;
            }
            
            const char *address = address_item->valuestring;
            ble_protocol_handle_param_set(cmd_code, (uint8_t*)address, strlen(address));
            break;
        }
        
        default:
            APP_LOG_ERROR("%s Unknown command code: %d", DEBUG_TAG, cmd_code);
            break;
    }
    
    cJSON_Delete(json);
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

void ble_protocol_init(void)
{
    if (s_protocol_initialized)
    {
        APP_LOG_WARNING("%s Protocol already initialized", DEBUG_TAG);
        return;
    }
    
    // 初始化 AT 响应收集器
    memset(&g_at_collector, 0, sizeof(g_at_collector));
    
    // 获取设备ID
    ble_protocol_get_device_id();
    
    // 初始化各种信息结构
    ble_protocol_init_device_info();
    ble_protocol_init_status_info();
    ble_protocol_init_param_settings();
    
    // 初始化传感器数据
    memset(&s_current_sensor_data, 0, sizeof(s_current_sensor_data));
    
    s_protocol_initialized = true;
}

void ble_protocol_data_process(const uint8_t *p_data, uint16_t length)
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
    
    APP_LOG_INFO("%s Processing JSON data: %d bytes", DEBUG_TAG, length);
    
    // 确保字符串以null结尾
    char json_str[JSON_BUFFER_SIZE];
    if (length >= JSON_BUFFER_SIZE)
    {
        APP_LOG_ERROR("%s JSON data too large: %d bytes", DEBUG_TAG, length);
        return;
    }
    
    memcpy(json_str, p_data, length);
    json_str[length] = '\0';
    
    APP_LOG_INFO("%s Received JSON: %s", DEBUG_TAG, json_str);
    
    // 解析并处理JSON命令
    ble_protocol_parse_json_command(json_str);
}



/**
 *****************************************************************************************
 * @brief 超级指令无法处理时的AT指令模式回退（已禁用，仅保留日志）
 *****************************************************************************************
 */


void ble_protocol_handle_query(uint8_t query_type)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s Handling query type: %d by reading from cache", DEBUG_TAG, query_type);
    
    // 直接从缓存创建响应，不再实时查询4G模块
    char *json_string = ble_protocol_create_query_response(query_type);
    if (json_string)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);
        APP_LOG_INFO("%s Sent cached response for query type %d", DEBUG_TAG, query_type);
    }
    else
    {
        APP_LOG_ERROR("%s Failed to create response for query type %d", DEBUG_TAG, query_type);
    }
}

void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data)
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
    
    char *json_string = ble_protocol_create_json_report(p_sensor_data);
    if (json_string)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);
    }
}

void ble_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    uint8_t result = PROTOCOL_RESULT_SET_FAILED;
    
    switch (cmd_code)
    {
        case PROTOCOL_CMD_COLLECT_TIME_SET:
            if (length >= 2)
            {
                uint16_t new_interval = (p_data[0] << 8) | p_data[1];
                // 参数范围验证 (1-1440分钟)
                if (new_interval >= 1 && new_interval <= 1440)
                {
                    // 使用共享参数API设置采集周期
                    if (shared_params_set_collect_time(new_interval))
                    {
                        result = PROTOCOL_RESULT_SET_SUCCESS;
                        APP_LOG_INFO("%s Set collect interval: %d minutes", DEBUG_TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set collect interval", DEBUG_TAG);
                    }
                    
                    // 通知4G模块重启采集定时器
                    extern void ble_4g_protocol_restart_collect_timer(void);
                    ble_4g_protocol_restart_collect_timer();
                    
                    // 同步到4G协议模块并重启定时器
                    ble_4g_protocol_handle_param_set(PROTOCOL_4G_CMD_COLLECT_TIME_SET, p_data, length);
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid collect interval: %d (range: 1-1440)", DEBUG_TAG, new_interval);
                    // 按照协议文档3.6格式发送失败回文
                    cJSON *response = cJSON_CreateObject();
                    cJSON *header = cJSON_CreateObject();
                    
                    cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_COLLECT_TIME_SET);
                    cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                    
                    cJSON_AddItemToObject(response, "header", header);
                    
                    char *json_string = cJSON_Print(response);
                    if (json_string) {
                        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                        APP_LOG_INFO("%s Collect time set failed response sent", DEBUG_TAG);
                        free(json_string);
                    }
                    cJSON_Delete(response);
                }
            }
            break;
            
        case PROTOCOL_CMD_UPDATE_TIME_SET:
            if (length >= 2)
            {
                uint16_t new_interval = (p_data[0] << 8) | p_data[1];
                // 参数范围验证 (1-1440分钟)
                if (new_interval >= 1 && new_interval <= 1440)
                {
                    // 使用共享参数API设置上报周期
                    if (shared_params_set_update_time(new_interval))
                    {
                        result = PROTOCOL_RESULT_SET_SUCCESS;
                        APP_LOG_INFO("%s Set report interval: %d minutes", DEBUG_TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set report interval", DEBUG_TAG);
                    }
                    
                    // 通知4G模块重启上报定时器
                    extern void ble_4g_protocol_restart_report_timer(void);
                    ble_4g_protocol_restart_report_timer();
                    
                    // 同步到4G协议模块并重启定时器
                    ble_4g_protocol_handle_param_set(PROTOCOL_4G_CMD_UPDATE_TIME_SET, p_data, length);
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid report interval: %d (range: 1-1440)", DEBUG_TAG, new_interval);
                    // 按照协议文档3.7格式发送失败回文
                    cJSON *response = cJSON_CreateObject();
                    cJSON *header = cJSON_CreateObject();
                    
                    cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_UPDATE_TIME_SET);
                    cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                    
                    cJSON_AddItemToObject(response, "header", header);
                    
                    char *json_string = cJSON_Print(response);
                    if (json_string) {
                        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                        APP_LOG_INFO("%s Update time set failed response sent", DEBUG_TAG);
                        free(json_string);
                    }
                    cJSON_Delete(response);
                }
            }
            break;
            
        case PROTOCOL_CMD_THRESHOLD_SET:
            if (length >= 8)
            {
                // 解析甲烷和温度阈值
                float methane_thresh;
                int16_t temp_high, temp_low;
                memcpy(&methane_thresh, &p_data[0], 4);
                memcpy(&temp_high, &p_data[4], 2);
                memcpy(&temp_low, &p_data[6], 2);
                
                APP_LOG_DEBUG("%s Received thresholds: CH4=%.2f, TEMP_H=%d, TEMP_L=%d", 
                             DEBUG_TAG, methane_thresh, temp_high, temp_low);
                
                // 使用共享参数API设置阈值
                if (shared_params_set_methane_threshold(methane_thresh) && 
                    shared_params_set_temp_thresholds(temp_high, temp_low))
                {
                    result = PROTOCOL_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set thresholds: CH4=%.2f%%vol, TEMP_H=%d°C, TEMP_L=%d°C", 
                               DEBUG_TAG, methane_thresh, temp_high, temp_low);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set thresholds", DEBUG_TAG);
                }
                

            }
            break;
            
        case PROTOCOL_CMD_LOCATION_SET:
            if (length >= 8)
            {
                // 解析经纬度 (4字节浮点数)
                float lat, lon;
                memcpy(&lat, &p_data[0], 4);
                memcpy(&lon, &p_data[4], 4);
                
                // 使用共享参数API设置位置
                if (shared_params_set_install_location(lat, lon))
                {
                    result = PROTOCOL_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set install location: lat=%.6f, lon=%.6f", DEBUG_TAG, lat, lon);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set install location", DEBUG_TAG);
                }
            }
            break;
            
        case PROTOCOL_CMD_WATER_THRESHOLD_SET:
            if (length >= 4)
            {
                // 解析水浸阈值 (4字节浮点数)
                float water_thresh;
                memcpy(&water_thresh, &p_data[0], 4);
                
                // 使用共享参数API设置水浸阈值
                if (shared_params_set_water_threshold((uint16_t)water_thresh))
                {
                    result = PROTOCOL_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set water threshold: %.2f", DEBUG_TAG, water_thresh);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set water threshold", DEBUG_TAG);
                }
            }
            break;
            
        case PROTOCOL_CMD_SERVER_ADDRESS_SET:
            if (length > 0 && length < sizeof(g_shared_params.server_address))
            {
                strncpy(g_shared_params.server_address, (char*)p_data, length);
                g_shared_params.server_address[length] = '\0';
                result = PROTOCOL_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set server address: %s", DEBUG_TAG, g_shared_params.server_address);
                shared_params_save_to_flash();
            }
            break;
            
        default:
            APP_LOG_ERROR("%s Unknown parameter set command: %d", DEBUG_TAG, cmd_code);
            break;
    }
    
    // 发送设置结果响应
    char *json_string = ble_protocol_create_param_set_response(cmd_code, result);
    if (json_string)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);
    }
}

float ble_protocol_vol_to_lel(float vol_percent)
{
    // 甲烷LEL转换: 5%vol = 100%LEL
    return (vol_percent / METHANE_MAX_VOL_PERCENT) * METHANE_MAX_LEL_PERCENT;
}

bool ble_protocol_get_sensor_data(ble_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return false;
    }
    
    update_sensor_data_from_parser();
    memcpy(p_sensor_data, &s_current_sensor_data, sizeof(ble_sensor_data_t));
    
    return s_current_sensor_data.is_valid;
}

bool ble_protocol_get_current_data(ble_sensor_data_t *p_sensor_data)
{
    return ble_protocol_get_sensor_data(p_sensor_data);
}

void ble_protocol_send_json_response(const char *p_json_str)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", DEBUG_TAG);
        return;
    }
    
    if (p_json_str == NULL)
    {
        APP_LOG_ERROR("%s Invalid JSON string", DEBUG_TAG);
        return;
    }
    
    APP_LOG_INFO("%s Sending JSON response via BLE only", DEBUG_TAG);
    
    // 只发送到BLE，不发送到4G模块
    uart_to_ble_buff_data_push((uint8_t*)p_json_str, strlen(p_json_str));
    
    APP_LOG_DEBUG("%s BLE response sent: %s", DEBUG_TAG, p_json_str);
}

void ble_debug_printf(const char *format, ...)
{
    char buffer[256];
    va_list args;
    
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);
    
    // 通过UART发送调试信息
    APP_LOG_DEBUG("%s %s", DEBUG_TAG, buffer);
    
    // 发送到4G模块 (UART1) 用于调试
    SEND_AT_COMMAND_ASYNC(buffer);
    
    // 发送换行符
    const char* crlf = "\r\n";
    SEND_AT_COMMAND_ASYNC(crlf);
}

void ble_protocol_get_device_info(device_info_t *p_device_info)
{
    if (p_device_info != NULL)
    {
        memcpy(p_device_info, &s_device_info, sizeof(device_info_t));
    }
}

void ble_protocol_get_status_info(status_info_t *p_status_info)
{
    if (p_status_info != NULL)
    {
        memcpy(p_status_info, &s_status_info, sizeof(status_info_t));
    }
}

void ble_protocol_get_param_settings(param_settings_t *p_param_settings)
{
    if (p_param_settings != NULL)
    {
        // 从共享参数复制到旧格式结构体（兼容性）
        p_param_settings->device_collect_time = g_shared_params.device_collect_time;
        p_param_settings->device_updata_time = g_shared_params.device_updata_time;
        p_param_settings->methane_threshold = g_shared_params.methane_threshold;
        p_param_settings->temp_threshold = (g_shared_params.temp_high_threshold + g_shared_params.temp_low_threshold) / 2.0f;
        p_param_settings->water_threshold = g_shared_params.water_threshold;
        p_param_settings->location_lat = g_shared_params.location_lat;
        p_param_settings->location_lon = g_shared_params.location_lon;
        strncpy(p_param_settings->server_address, g_shared_params.server_address, sizeof(p_param_settings->server_address) - 1);
    }
}

/**
 *****************************************************************************************
 * @brief Update sensor data from external source.
 *
 * @param[in] p_sensor_data: Pointer to sensor data to update.
 *****************************************************************************************
 */
void ble_protocol_update_sensor_data(const ble_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data != NULL)
    {
        memcpy(&s_current_sensor_data, p_sensor_data, sizeof(ble_sensor_data_t));
    }
}



/**
 *****************************************************************************************
 * @brief 处理UART1接收到的4G模块数据
 * @param[in] p_data: 接收到的数据指针
 * @param[in] length: 数据长度
 *****************************************************************************************
 */
void ble_protocol_handle_4g_data(const uint8_t *p_data, uint16_t length)
{
    if (p_data == NULL || length == 0)
    {
        return;
    }
    
    // 确保字符串以null结尾
    char response[512];
    if (length >= sizeof(response))
    {
        APP_LOG_WARNING("%s 4G response too large: %d bytes", DEBUG_TAG, length);
        length = sizeof(response) - 1;
    }
    
    memcpy(response, p_data, length);
    response[length] = '\0';
    
    APP_LOG_DEBUG("%s Processing 4G response: [%d] %s", DEBUG_TAG, length, response);
    
    // 处理4G模块响应
    handle_4g_response(response, length);
    
    // 检查是否可以发送收集的响应
    // 注意：不要在每次接收到数据后立即检查，而是在合适的时机检查
    if (g_at_collector.is_collecting)
    {
        // 检查是否收集到了足够的信息
        bool has_required_data = false;
        
        switch (g_at_collector.pending_query_type)
        {
            case PROTOCOL_QUERY_TYPE_DEVICE_INFO:
                // 设备信息查询需要IMEI、ICCID、GPS
                has_required_data = (strlen(g_at_collector.imei) > 0 || 
                                   strlen(g_at_collector.iccid) > 0 ||
                                   strlen(g_at_collector.latitude) > 0);
                break;
                
            case PROTOCOL_QUERY_TYPE_STATUS_INFO:
                // 状态信息查询需要信号质量和GPS
                has_required_data = (g_at_collector.signal_quality >= 0 ||
                                   strlen(g_at_collector.latitude) > 0);
                break;
                
            default:
                has_required_data = false;
                break;
        }
        
        if (has_required_data)
        {
            APP_LOG_DEBUG("%s Sufficient data collected, checking for response send", DEBUG_TAG);
        }
    }
}

/**
 *****************************************************************************************
 * @brief Get IMEI from AT response collector.
 *****************************************************************************************
 */
bool ble_protocol_get_imei(char *p_imei_buffer, uint16_t buffer_size)
{
    if (p_imei_buffer == NULL || buffer_size == 0)
    {
        return false;
    }
    
    // 检查是否有 IMEI 数据
    if (strlen(g_at_collector.imei) > 0)
    {
        strncpy(p_imei_buffer, g_at_collector.imei, buffer_size - 1);
        p_imei_buffer[buffer_size - 1] = '\0';
        return true;
    }
    
    // 没有 IMEI 数据
    p_imei_buffer[0] = '\0';
    return false;
}

/**
 *****************************************************************************************
 * @brief Send success response to BLE client.
 *
 * @param[in] message: Success message to send.
 *****************************************************************************************
 */
void ble_protocol_send_success_response(const char* message)
{
    if (!message) {
        message = "Operation completed successfully";
    }
    
    // 创建成功响应JSON
    cJSON *response = cJSON_CreateObject();
    if (!response) {
        APP_LOG_ERROR("%s Failed to create success response JSON", DEBUG_TAG);
        return;
    }
    
    cJSON_AddStringToObject(response, "result", "success");
    cJSON_AddStringToObject(response, "message", message);
    
    char *json_string = cJSON_Print(response);
    if (json_string) {
        // 通过BLE发送响应
        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
        APP_LOG_INFO("%s Success response sent: %s", DEBUG_TAG, message);
        free(json_string);
    }
    
    cJSON_Delete(response);
}

/**
 *****************************************************************************************
 * @brief Send error response to BLE client.
 *
 * @param[in] message: Error message to send.
 *****************************************************************************************
 */
void ble_protocol_send_error_response(const char* message)
{
    if (!message) {
        message = "Operation failed";
    }
    
    // 创建错误响应JSON
    cJSON *response = cJSON_CreateObject();
    if (!response) {
        APP_LOG_ERROR("%s Failed to create error response JSON", DEBUG_TAG);
        return;
    }
    
    cJSON_AddStringToObject(response, "result", "error");
    cJSON_AddStringToObject(response, "message", message);
    
    char *json_string = cJSON_Print(response);
    if (json_string) {
        // 通过BLE发送响应
        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
        APP_LOG_ERROR("%s Error response sent: %s", DEBUG_TAG, message);
        free(json_string);
    }
    
    cJSON_Delete(response);
}
