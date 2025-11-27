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

// 标记服务器配置已修改（由4G协议模块实现）
extern void ble_4g_protocol_mark_server_config_changed(void);

/*
 * DEFINES
 *****************************************************************************************
 */
// 便捷宏：异步发送AT命令到4G模块，适用于时钟不稳定环境
#define SEND_AT_COMMAND_ASYNC(cmd) do { \
    uart1_tx_data_send((uint8_t*)(cmd), strlen(cmd)); \
} while(0)
#define TAG                         "BLE_PROTO"
#define JSON_BUFFER_SIZE            1024
#define DEVICE_ID_SIZE              32
#define PROTOCOL_CMD_SERVER_ADDRESS_QUERY   123

// 将数值按两位小数四舍五入，避免2.0999999这类浮点显示问题
static double round_to_2_decimal(double value)
{
    long tmp = (long)(value * 100.0 + 0.5);
    return (double)tmp / 100.0;
}

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
    // 检查是否为JSON格式数据（平台下发的指令）
    // JSON数据以 '{' 开头
    if (response != NULL && length > 0 && response[0] == '{')
    {
        APP_LOG_INFO("%s Detected JSON command from platform, forwarding to 4G protocol handler", TAG);
        // 调用4G协议处理函数处理平台下发的JSON指令
        ble_4g_protocol_data_process((const uint8_t*)response, length);
        return;
    }
    
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
    APP_LOG_INFO("%s Parsing super device info response", TAG);
    
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
                APP_LOG_INFO("%s Got IMEI: %s", TAG, s_device_info.device_id);
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
            APP_LOG_INFO("%s Got ICCID: %.*s", TAG, iccid_len, iccid_start);
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
        APP_LOG_INFO("%s Got GPS: lat=%.6f, lon=%.6f", TAG, lat, lon);
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
    APP_LOG_INFO("%s Parsing super status info response", TAG);
    
    // 示例超级指令响应格式: SUPER_RESP_STATUS_INFO:SIGNAL=25,NET_STATUS=1,GPS_STATUS=1,WATER=0,MOVE=0
    
    // 提取信号强度
    const char* signal_start = strstr(response, "SIGNAL=");
    if (signal_start)
    {
        signal_start += 7; // 跳过"SIGNAL="
        s_status_info.communication_status = atoi(signal_start);
        APP_LOG_INFO("%s Got signal strength: %d", TAG, s_status_info.communication_status);
    }
    
    // 提取网络状态
    const char* net_start = strstr(response, "NET_STATUS=");
    if (net_start)
    {
        net_start += 11; // 跳过"NET_STATUS="
        int net_status = atoi(net_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFE) | (net_status & 0x01);
        APP_LOG_INFO("%s Got network status: %d", TAG, net_status);
    }
    
    // 提取GPS状态
    const char* gps_start = strstr(response, "GPS_STATUS=");
    if (gps_start)
    {
        gps_start += 11; // 跳过"GPS_STATUS="
        int gps_status = atoi(gps_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFB) | ((gps_status & 0x01) << 2);
        APP_LOG_INFO("%s Got GPS status: %d", TAG, gps_status);
    }
    
    // 提取水浸状态
    const char* water_start = strstr(response, "WATER=");
    if (water_start)
    {
        water_start += 6; // 跳过"WATER="
        int water_status = atoi(water_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFE) | (water_status & 0x01);
        APP_LOG_INFO("%s Got water status: %d", TAG, water_status);
    }
    
    // 提取防盗状态
    const char* move_start = strstr(response, "MOVE=");
    if (move_start)
    {
        move_start += 5; // 跳过"MOVE="
        int move_status = atoi(move_start);
        s_status_info.device_status = (s_status_info.device_status & 0xFD) | ((move_status & 0x01) << 1);
        APP_LOG_INFO("%s Got move status: %d", TAG, move_status);
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
    // 跳过空行、OK、ERROR和命令回显
    if (length == 0 || strncmp(response, "OK", 2) == 0 || 
        strncmp(response, "ERROR", 5) == 0 || strncmp(response, "AT+", 3) == 0)
        return;
    
    if (strncmp(response, "+CSQ:", 5) == 0) {
        int rssi, ber;
        if (sscanf(response + 5, "%d,%d", &rssi, &ber) >= 1) {
            g_at_collector.signal_quality = ((rssi >= 0 && rssi <= 31) || rssi == 99) ? rssi : 0;
        }
    }
    else if (strncmp(response, "+VER:", 5) == 0) {
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), "\"firmware_version\":\"%s\"", response + 5);
    }
    else if (strncmp(response, "+BUILD:", 7) == 0) {
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), "\"build_time\":\"%s\"", response + 7);
    }
    else if (strncmp(response, "+SN:", 4) == 0) {
        snprintf(g_4g_response_buffer, sizeof(g_4g_response_buffer), "\"serial_number\":\"%s\"", response + 4);
    }
    else if (strncmp(response, "+IMEI:", 6) == 0) {
        strncpy(g_at_collector.imei, response + 6, sizeof(g_at_collector.imei) - 1);
        g_at_collector.imei[sizeof(g_at_collector.imei) - 1] = '\0';
        extern void update_ble_name_with_imei(void);
        update_ble_name_with_imei();
    }
    else if (strncmp(response, "+ICCID:", 7) == 0) {
        strncpy(g_at_collector.iccid, response + 7, sizeof(g_at_collector.iccid) - 1);
        g_at_collector.iccid[sizeof(g_at_collector.iccid) - 1] = '\0';
    }
    else if (strncmp(response, "+CCLK:", 6) == 0) {
        bm8563_set_time_from_network(response + 6);
    }
    else if (strncmp(response, "+GPS:", 5) == 0) {
        if (sscanf(response + 5, "%15[^,],%15s", g_at_collector.latitude, g_at_collector.longitude) == 2) {
            float lat = atof(g_at_collector.latitude), lon = atof(g_at_collector.longitude);
            g_at_collector.gps_status = (lat == 0.0f && lon == 0.0f) ? 1 : 0;
            shared_params_set_device_gps_status(g_at_collector.gps_status);
            if (g_at_collector.gps_status == 0) shared_params_set_location(lat, lon);
        }
    }
    else if (strncmp(response, "+CREG:", 6) == 0) {
        int reg_status = 0;
        if (sscanf(response + 6, "%d", &reg_status) == 1)
            g_at_collector.network_reg_status = reg_status;
    }
    else if (length < sizeof(g_4g_response_buffer)) {
        memcpy(g_4g_response_buffer, response, length);
        g_4g_response_buffer[length] = '\0';
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
    
    APP_LOG_INFO("%s Device ID: %s", TAG, s_device_id);
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
    APP_LOG_INFO("%s Parameter settings initialized via shared_params", TAG);
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
        APP_LOG_ERROR("%s Failed to create JSON objects", TAG);
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
            
            // 添加设备安装位置信息
            char install_location_str[64];
            snprintf(install_location_str, sizeof(install_location_str), "%.6f,%.6f", 
                     g_shared_params.install_lon, g_shared_params.install_lat);
            cJSON_AddStringToObject(body, "device_installation_location", install_location_str);
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
                APP_LOG_INFO("%s Using AT collector signal as fallback: %d", TAG, lte_signal);
            }
            APP_LOG_INFO("%s Status query - 4G signal: %d, AT signal: %d, final: %d", 
                        TAG, ble_4g_status.device_LTE_signal, g_at_collector.signal_quality, lte_signal);
            cJSON_AddNumberToObject(body, "device_LTE_signal", lte_signal);
            cJSON_AddNumberToObject(body, "device_GPS_status", g_shared_params.device_GPS_status); // GPS状态
            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_INFO:
            response_code = 104; // 当前设置参数上报
            // 按照蓝牙协议文档3.4的字段名称
            cJSON_AddNumberToObject(body, "device_collect_time", g_shared_params.device_collect_time);
            cJSON_AddNumberToObject(body, "device_updata_time", g_shared_params.device_updata_time);
            // 甲烷阈值改为float类型（协议V1.4更新）
            // 按两位小数四舍五入后写入JSON，避免2.0999999046等显示
            cJSON_AddNumberToObject(body, "methane_threshold", round_to_2_decimal(g_shared_params.methane_threshold));
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
        APP_LOG_ERROR("%s Failed to create JSON object", TAG);
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
                // 甲烷阈值按两位小数四舍五入后写入JSON，避免2.0999999046等显示
                cJSON_AddNumberToObject(body, "methane_threshold_set", round_to_2_decimal(g_shared_params.methane_threshold));
                cJSON_AddNumberToObject(body, "TEMPH_threshold_set", g_shared_params.temp_high_threshold);
                cJSON_AddNumberToObject(body, "TEMPL_threshold_set", g_shared_params.temp_low_threshold);
                break;
            case 109: // 安装坐标设置
                {
                    char coordinate_str[64];
                    // [修复] 从 install_lon 和 install_lat 读取已设置的安装坐标
                    snprintf(coordinate_str, sizeof(coordinate_str), "%.6f,%.6f", 
                             g_shared_params.install_lon, g_shared_params.install_lat);
                    cJSON_AddStringToObject(body, "coordinate", coordinate_str);
                }
                break;
            case 110: // 水浸报警阈值设置
                cJSON_AddNumberToObject(body, "water_threshold_set", g_shared_params.water_threshold);
                break;
            case 111: // 服务器地址设置
                cJSON_AddStringToObject(body, "server_address", g_shared_params.server_address);
                cJSON_AddStringToObject(body, "pub_topic", g_shared_params.pub_topic);
                cJSON_AddStringToObject(body, "sub_topic", g_shared_params.sub_topic);
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
        APP_LOG_ERROR("%s Failed to parse JSON: %s", TAG, json_str);
        return;
    }
    
    // 解析header
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (header == NULL)
    {
        APP_LOG_ERROR("%s Missing header in JSON", TAG);
        cJSON_Delete(json);
        return;
    }
    
    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (code_item == NULL || !cJSON_IsNumber(code_item))
    {
        APP_LOG_ERROR("%s Missing or invalid code in header", TAG);
        cJSON_Delete(json);
        return;
    }
    
    uint16_t cmd_code = (uint16_t)code_item->valueint;
    APP_LOG_INFO("%s Received command code: %d", TAG, cmd_code);
    
    // 解析body
    cJSON *body = cJSON_GetObjectItem(json, "body");
    if (body == NULL)
    {
        APP_LOG_ERROR("%s Missing body in JSON", TAG);
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
                APP_LOG_ERROR("%s Missing or invalid type in query body", TAG);
                break;
            }
            
            uint8_t query_type = (uint8_t)type_item->valueint;
            APP_LOG_INFO("%s Processing query type: %d", TAG, query_type);
            ble_protocol_handle_query(query_type);
            break;
        }
        
        case PROTOCOL_CMD_COLLECT_TIME_SET:
        {
            // 按照蓝牙协议文档3.6，字段名为 collect_time_set
            cJSON *interval_item = cJSON_GetObjectItem(body, "collect_time_set");
            if (interval_item == NULL || !cJSON_IsNumber(interval_item))
            {
                APP_LOG_ERROR("%s Missing or invalid collect_time_set in body", TAG);
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
                APP_LOG_INFO("%s Collect time set response sent", TAG);
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
                APP_LOG_ERROR("%s Missing or invalid updata_time_set in body", TAG);
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
                APP_LOG_INFO("%s Update time set response sent", TAG);
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
                APP_LOG_ERROR("%s Missing or invalid thresholds in threshold set", TAG);
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
                APP_LOG_ERROR("%s Missing or invalid location parameters in location set", TAG);
                break;
            }
            
            int location_set = location_set_item->valueint;
            const char* coordinate_str = coordinate_item->valuestring;
            
            APP_LOG_INFO("%s Location set mode: %d (0=auto GPS, 1=manual)", TAG, location_set);
            
            // 如果是自动获取模式，需要从GPS获取坐标
            if (location_set == 0)
            {
                APP_LOG_INFO("%s Auto GPS mode selected, will use GPS coordinates", TAG);
                // TODO: 实现从GPS自动获取坐标的逻辑
                // 当前暂不支持，返回错误
                APP_LOG_ERROR("%s Auto GPS mode not implemented yet", TAG);
                
                // 发送失败回文
                cJSON *response = cJSON_CreateObject();
                cJSON *header = cJSON_CreateObject();
                cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_LOCATION_SET);
                cJSON_AddItemToObject(response, "header", header);
                cJSON_AddNumberToObject(response, "result", 1); // 设置失败
                
                char *json_string = cJSON_Print(response);
                if (json_string) {
                    ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                    free(json_string);
                }
                cJSON_Delete(response);
                break;
            }
            
            // location_set == 1: 使用报文中的坐标
            // 解析经纬度字符串 "longitude,latitude"（注意：格式为经度在前，纬度在后）
            float longitude, latitude;
            int parsed = sscanf(coordinate_str, "%f,%f", &longitude, &latitude);
            if (parsed != 2)
            {
                APP_LOG_ERROR("%s Invalid coordinate format: %s (expected: longitude,latitude)", TAG, coordinate_str);
                break;
            }
            
            // 验证坐标范围：经度 [-180, 180]，纬度 [-90, 90]
            if (longitude < -180.0f || longitude > 180.0f || latitude < -90.0f || latitude > 90.0f)
            {
                APP_LOG_ERROR("%s Coordinate out of range: lon=%.6f, lat=%.6f", TAG, longitude, latitude);
                break;
            }
            
            APP_LOG_INFO("%s Parsed coordinates: longitude=%.6f, latitude=%.6f", TAG, longitude, latitude);
            
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
                APP_LOG_ERROR("%s Missing or invalid threshold in water threshold set", TAG);
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
            // 按照蓝牙协议文档3.11，字段为 server_type/server_address/server_port/username/password
            cJSON *type_item  = cJSON_GetObjectItem(body, "server_type");
            cJSON *addr_item  = cJSON_GetObjectItem(body, "server_address");
            cJSON *port_item  = cJSON_GetObjectItem(body, "server_port");
            cJSON *user_item  = cJSON_GetObjectItem(body, "username");
            cJSON *pass_item  = cJSON_GetObjectItem(body, "password");
            cJSON *pub_item   = cJSON_GetObjectItem(body, "pub_topic");
            cJSON *sub_item   = cJSON_GetObjectItem(body, "sub_topic");

            if (type_item == NULL || !cJSON_IsNumber(type_item)   ||
                addr_item == NULL || !cJSON_IsString(addr_item)   ||
                port_item == NULL || !cJSON_IsNumber(port_item)   ||
                user_item == NULL || !cJSON_IsString(user_item)   ||
                pass_item == NULL || !cJSON_IsString(pass_item))
            {
                APP_LOG_ERROR("%s Missing or invalid fields in server address set", TAG);

                // 按照协议：仅返回 header.code 和 result=1
                cJSON *resp   = cJSON_CreateObject();
                cJSON *header = cJSON_CreateObject();
                if (resp == NULL || header == NULL)
                {
                    if (resp)   cJSON_Delete(resp);
                    if (header) cJSON_Delete(header);
                    break;
                }

                cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_SERVER_ADDRESS_SET);
                cJSON_AddItemToObject(resp, "header", header);
                cJSON_AddNumberToObject(resp, "result", 1);

                char *json_string = cJSON_Print(resp);
                if (json_string)
                {
                    // 通过BLE回传失败结果
                    ble_protocol_send_json_response(json_string);
                    free(json_string);
                }
                cJSON_Delete(resp);
                break;
            }

            int server_type  = type_item->valueint;
            int server_port  = port_item->valueint;
            const char *server_address = addr_item->valuestring;
            const char *username       = user_item->valuestring;
            const char *password       = pass_item->valuestring;
            const char *pub_topic      = (pub_item && cJSON_IsString(pub_item)) ? pub_item->valuestring : NULL;
            const char *sub_topic      = (sub_item && cJSON_IsString(sub_item)) ? sub_item->valuestring : NULL;

            // 更新共享参数中的服务器配置
            memset(g_shared_params.server_address, 0, sizeof(g_shared_params.server_address));
            strncpy(g_shared_params.server_address, server_address,
                    sizeof(g_shared_params.server_address) - 1);

            g_shared_params.server_type = (uint8_t)server_type;
            g_shared_params.server_port = (uint16_t)server_port;

            memset(g_shared_params.username, 0, sizeof(g_shared_params.username));
            strncpy(g_shared_params.username, username,
                    sizeof(g_shared_params.username) - 1);
            memset(g_shared_params.password, 0, sizeof(g_shared_params.password));
            strncpy(g_shared_params.password, password,
                    sizeof(g_shared_params.password) - 1);

            if (pub_topic)
            {
                memset(g_shared_params.pub_topic, 0, sizeof(g_shared_params.pub_topic));
                strncpy(g_shared_params.pub_topic, pub_topic,
                        sizeof(g_shared_params.pub_topic) - 1);
            }

            if (sub_topic)
            {
                memset(g_shared_params.sub_topic, 0, sizeof(g_shared_params.sub_topic));
                strncpy(g_shared_params.sub_topic, sub_topic,
                        sizeof(g_shared_params.sub_topic) - 1);
            }

            // 保存到Flash，确保掉电不丢失
            shared_params_save_to_flash();

            // 通知4G协议：服务器配置已修改，下次上电时需要向DTU下发新配置
            ble_4g_protocol_mark_server_config_changed();

            // 构建成功回文
            cJSON *resp      = cJSON_CreateObject();
            cJSON *header    = cJSON_CreateObject();
            cJSON *body_resp = cJSON_CreateObject();
            if (resp == NULL || header == NULL || body_resp == NULL)
            {
                if (resp)      cJSON_Delete(resp);
                if (header)    cJSON_Delete(header);
                if (body_resp) cJSON_Delete(body_resp);
                APP_LOG_ERROR("%s Failed to create JSON response for server address set", TAG);
                break;
            }

            cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_SERVER_ADDRESS_SET);
            cJSON_AddItemToObject(resp, "header", header);

            char addr_port[96];
            snprintf(addr_port, sizeof(addr_port), "%s:%d",
                     g_shared_params.server_address,
                     (int)g_shared_params.server_port);
            cJSON_AddStringToObject(body_resp, "server_address", addr_port);
            cJSON_AddItemToObject(resp, "body", body_resp);
            cJSON_AddNumberToObject(resp, "result", 0);

            char *json_string = cJSON_Print(resp);
            if (json_string)
            {
                // 通过BLE回传成功结果
                ble_protocol_send_json_response(json_string);
                free(json_string);
            }
            cJSON_Delete(resp);
            break;
        }

        case PROTOCOL_CMD_SERVER_ADDRESS_QUERY:
        {
            cJSON *resp      = cJSON_CreateObject();
            cJSON *header    = cJSON_CreateObject();
            cJSON *body_resp = cJSON_CreateObject();

            if (resp == NULL || header == NULL || body_resp == NULL)
            {
                if (resp)      cJSON_Delete(resp);
                if (header)    cJSON_Delete(header);
                if (body_resp) cJSON_Delete(body_resp);
                APP_LOG_ERROR("%s Failed to create JSON response for server address query", TAG);
                break;
            }

            cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_SERVER_ADDRESS_QUERY);
            cJSON_AddItemToObject(resp, "header", header);

            cJSON_AddNumberToObject(body_resp, "server_type", g_shared_params.server_type);
            cJSON_AddStringToObject(body_resp, "server_address", g_shared_params.server_address);
            cJSON_AddNumberToObject(body_resp, "server_port", g_shared_params.server_port);
            cJSON_AddStringToObject(body_resp, "username", g_shared_params.username);
            cJSON_AddStringToObject(body_resp, "password", g_shared_params.password);
            cJSON_AddStringToObject(body_resp, "pub_topic", g_shared_params.pub_topic);
            cJSON_AddStringToObject(body_resp, "sub_topic", g_shared_params.sub_topic);

            cJSON_AddItemToObject(resp, "body", body_resp);
            cJSON_AddNumberToObject(resp, "result", 0);

            char *json_string = cJSON_Print(resp);
            if (json_string)
            {
                ble_protocol_send_json_response(json_string);
                free(json_string);
            }

            cJSON_Delete(resp);
            break;
        }
        
        default:
            APP_LOG_ERROR("%s Unknown command code: %d", TAG, cmd_code);
            break;
    }
    
    cJSON_Delete(json);
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/** @brief 初始化BLE协议模块 */
void ble_protocol_init(void)
{
    if (s_protocol_initialized) return;
    
    memset(&g_at_collector, 0, sizeof(g_at_collector));
    ble_protocol_get_device_id();
    ble_protocol_init_device_info();
    ble_protocol_init_status_info();
    ble_protocol_init_param_settings();
    memset(&s_current_sensor_data, 0, sizeof(s_current_sensor_data));
    s_protocol_initialized = true;
}

/** @brief 处理BLE接收的JSON数据 */
void ble_protocol_data_process(const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized || !p_data || length == 0 || length >= JSON_BUFFER_SIZE) return;
    
    char json_str[JSON_BUFFER_SIZE];
    memcpy(json_str, p_data, length);
    json_str[length] = '\0';
    ble_protocol_parse_json_command(json_str);
}

/** @brief 处理查询请求 */
void ble_protocol_handle_query(uint8_t query_type)
{
    if (!s_protocol_initialized) return;
    char *json = ble_protocol_create_query_response(query_type);
    if (json) { ble_protocol_send_json_response(json); free(json); }
}

/** @brief 发送传感器数据报告 */
void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data)
{
    if (!s_protocol_initialized || !p_sensor_data) return;
    char *json = ble_protocol_create_json_report(p_sensor_data);
    if (json) { ble_protocol_send_json_response(json); free(json); }
}

void ble_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_ERROR("%s Protocol not initialized", TAG);
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
                        APP_LOG_INFO("%s Set collect interval: %d minutes", TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set collect interval", TAG);
                    }
                    
                    // 通知4G模块重启采集定时器
                    extern void ble_4g_protocol_restart_collect_timer(void);
                    ble_4g_protocol_restart_collect_timer();
                    
                    // 同步到4G协议模块并重启定时器
                    ble_4g_protocol_handle_param_set(PROTOCOL_4G_CMD_COLLECT_TIME_SET, p_data, length);
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid collect interval: %d (range: 1-1440)", TAG, new_interval);
                    // 按照协议文档3.6格式发送失败回文
                    cJSON *response = cJSON_CreateObject();
                    cJSON *header = cJSON_CreateObject();
                    
                    cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_COLLECT_TIME_SET);
                    cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                    
                    cJSON_AddItemToObject(response, "header", header);
                    
                    char *json_string = cJSON_Print(response);
                    if (json_string) {
                        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                        APP_LOG_INFO("%s Collect time set failed response sent", TAG);
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
                        APP_LOG_INFO("%s Set report interval: %d minutes", TAG, new_interval);
                    }
                    else
                    {
                        result = PROTOCOL_RESULT_SET_FAILED;
                        APP_LOG_ERROR("%s Failed to set report interval", TAG);
                    }
                    
                    // 通知4G模块重启上报定时器
                    extern void ble_4g_protocol_restart_report_timer(void);
                    ble_4g_protocol_restart_report_timer();
                    
                    // 同步到4G协议模块并重启定时器
                    ble_4g_protocol_handle_param_set(PROTOCOL_4G_CMD_UPDATE_TIME_SET, p_data, length);
                }
                else
                {
                    APP_LOG_ERROR("%s Invalid report interval: %d (range: 1-1440)", TAG, new_interval);
                    // 按照协议文档3.7格式发送失败回文
                    cJSON *response = cJSON_CreateObject();
                    cJSON *header = cJSON_CreateObject();
                    
                    cJSON_AddNumberToObject(header, "code", PROTOCOL_CMD_UPDATE_TIME_SET);
                    cJSON_AddNumberToObject(response, "result", 1); // 1:设置失败
                    
                    cJSON_AddItemToObject(response, "header", header);
                    
                    char *json_string = cJSON_Print(response);
                    if (json_string) {
                        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
                        APP_LOG_INFO("%s Update time set failed response sent", TAG);
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
                             TAG, methane_thresh, temp_high, temp_low);
                
                // 使用共享参数API设置阈值
                if (shared_params_set_methane_threshold(methane_thresh) && 
                    shared_params_set_temp_thresholds(temp_high, temp_low))
                {
                    result = PROTOCOL_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set thresholds: CH4=%.2f%%vol, TEMP_H=%d°C, TEMP_L=%d°C", 
                               TAG, methane_thresh, temp_high, temp_low);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set thresholds", TAG);
                }
                

            }
            break;
            
        case PROTOCOL_CMD_LOCATION_SET:
            if (length >= 12)
            {
                // 解析 location_set 模式和经纬度 (4字节整数 + 2个4字节浮点数)
                int location_set_mode;
                float lon, lat;
                memcpy(&location_set_mode, &p_data[0], 4);
                memcpy(&lon, &p_data[4], 4);
                memcpy(&lat, &p_data[8], 4);
                
                APP_LOG_INFO("%s Location set mode: %d, lon=%.6f, lat=%.6f", 
                           TAG, location_set_mode, lon, lat);
                
                // 使用共享参数API设置位置
                if (shared_params_set_install_location(lat, lon))
                {
                    // 保存到Flash确保断电不丢失
                    shared_params_save_to_flash();
                    
                    result = PROTOCOL_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Set install location success and saved to flash", TAG);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set install location", TAG);
                }
            }
            else
            {
                APP_LOG_ERROR("%s Invalid data length for location set: %d (expected >= 12)", 
                            TAG, length);
                result = PROTOCOL_RESULT_SET_FAILED;
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
                    APP_LOG_INFO("%s Set water threshold: %.2f", TAG, water_thresh);
                }
                else
                {
                    result = PROTOCOL_RESULT_SET_FAILED;
                    APP_LOG_ERROR("%s Failed to set water threshold", TAG);
                }
            }
            break;
            
        case PROTOCOL_CMD_SERVER_ADDRESS_SET:
            if (length > 0 && length < sizeof(g_shared_params.server_address))
            {
                strncpy(g_shared_params.server_address, (char*)p_data, length);
                g_shared_params.server_address[length] = '\0';
                result = PROTOCOL_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Set server address: %s", TAG, g_shared_params.server_address);
                shared_params_save_to_flash();
            }
            break;
            
        default:
            APP_LOG_ERROR("%s Unknown parameter set command: %d", TAG, cmd_code);
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

/** @brief %vol转%LEL (5%vol=100%LEL) */
float ble_protocol_vol_to_lel(float vol_percent)
{
    return (vol_percent / METHANE_MAX_VOL_PERCENT) * METHANE_MAX_LEL_PERCENT;
}

/** @brief 获取传感器数据 */
bool ble_protocol_get_sensor_data(ble_sensor_data_t *p_sensor_data)
{
    if (!p_sensor_data) return false;
    update_sensor_data_from_parser();
    memcpy(p_sensor_data, &s_current_sensor_data, sizeof(ble_sensor_data_t));
    return s_current_sensor_data.is_valid;
}

/** @brief 获取当前数据(别名) */
bool ble_protocol_get_current_data(ble_sensor_data_t *p_sensor_data)
{
    return ble_protocol_get_sensor_data(p_sensor_data);
}

/** @brief 发送JSON响应到BLE */
void ble_protocol_send_json_response(const char *p_json_str)
{
    if (!s_protocol_initialized || !p_json_str) return;
    uart_to_ble_buff_data_push((uint8_t*)p_json_str, strlen(p_json_str));
}

/** @brief 调试打印(发送到4G模块) */
void ble_debug_printf(const char *format, ...)
{
    char buffer[256];
    va_list args;
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);
    SEND_AT_COMMAND_ASYNC(buffer);
    SEND_AT_COMMAND_ASYNC("\r\n");
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
        APP_LOG_WARNING("%s 4G response too large: %d bytes", TAG, length);
        length = sizeof(response) - 1;
    }
    
    memcpy(response, p_data, length);
    response[length] = '\0';
    
    APP_LOG_DEBUG("%s Processing 4G response: [%d] %s", TAG, length, response);
    
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
            APP_LOG_DEBUG("%s Sufficient data collected, checking for response send", TAG);
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
        APP_LOG_ERROR("%s Failed to create success response JSON", TAG);
        return;
    }
    
    cJSON_AddStringToObject(response, "result", "success");
    cJSON_AddStringToObject(response, "message", message);
    
    char *json_string = cJSON_Print(response);
    if (json_string) {
        // 通过BLE发送响应
        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
        APP_LOG_INFO("%s Success response sent: %s", TAG, message);
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
        APP_LOG_ERROR("%s Failed to create error response JSON", TAG);
        return;
    }
    
    cJSON_AddStringToObject(response, "result", "error");
    cJSON_AddStringToObject(response, "message", message);
    
    char *json_string = cJSON_Print(response);
    if (json_string) {
        // 通过BLE发送响应
        ble_to_uart_buff_data_push((uint8_t*)json_string, strlen(json_string));
        APP_LOG_ERROR("%s Error response sent: %s", TAG, message);
        free(json_string);
    }
    
    cJSON_Delete(response);
}
