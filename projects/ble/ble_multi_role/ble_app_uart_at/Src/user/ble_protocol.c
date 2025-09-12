/**
 *****************************************************************************************
 *
 * @file ble_protocol.c
 *
 * @brief BLE Protocol Handler Implementation
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
#include "gus.h"
#include "app_log.h"
#include "transport_scheduler.h"
#include "sensor_data_parser.h"
#include "cJSON.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static ble_sensor_data_t s_current_sensor_data = {0};
static bool s_protocol_initialized = false;

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Parse JSON data from received buffer using cJSON.
 *
 * @param[in] p_data: Pointer to received data.
 * @param[in] length: Length of received data.
 *
 * @return true if parsing successful, false otherwise.
 *****************************************************************************************
 */
static bool parse_json_command(const uint8_t *p_data, uint16_t length)
{
    // 确保字符串以null结尾
    char *json_str = malloc(length + 1);
    if (json_str == NULL)
    {
        APP_LOG_ERROR("Failed to allocate memory for JSON parsing");
        return false;
    }
    
    memcpy(json_str, p_data, length);
    json_str[length] = '\0';
    
    // 解析JSON
    cJSON *json = cJSON_Parse(json_str);
    free(json_str);
    
    if (json == NULL)
    {
        const char *error_ptr = cJSON_GetErrorPtr();
        if (error_ptr != NULL)
        {
            APP_LOG_ERROR("JSON parse error: %s", error_ptr);
        }
        return false;
    }
    
    // 获取header中的code
    cJSON *header = cJSON_GetObjectItem(json, "header");
    if (header == NULL)
    {
        APP_LOG_ERROR("Missing header in JSON");
        cJSON_Delete(json);
        return false;
    }
    
    cJSON *code_item = cJSON_GetObjectItem(header, "code");
    if (!cJSON_IsNumber(code_item))
    {
        APP_LOG_ERROR("Missing or invalid code in header");
        cJSON_Delete(json);
        return false;
    }
    
    int code = (int)cJSON_GetNumberValue(code_item);
    bool result = false;
    
    switch (code)
    {
        case PROTOCOL_CMD_QUERY:
        {
            cJSON *body = cJSON_GetObjectItem(json, "body");
            if (body != NULL)
            {
                cJSON *type_item = cJSON_GetObjectItem(body, "type");
                if (cJSON_IsNumber(type_item))
                {
                    int type = (int)cJSON_GetNumberValue(type_item);
                    ble_protocol_handle_query((uint8_t)type);
                    result = true;
                }
                else
                {
                    APP_LOG_ERROR("Missing or invalid type in body");
                }
            }
            else
            {
                APP_LOG_ERROR("Missing body for query command");
            }
            break;
        }
        
        case PROTOCOL_CMD_DATA_REPORT:
            APP_LOG_INFO("Received data report request");
            ble_protocol_send_data_report(&s_current_sensor_data);
            result = true;
            break;
            
        default:
            APP_LOG_WARNING("Unknown protocol command code: %d", code);
            break;
    }
    
    cJSON_Delete(json);
    return result;
}

/**
 *****************************************************************************************
 * @brief Build JSON response using cJSON.
 *
 * @param[in] code: Command code.
 * @param[in] result: Result value.
 * @param[in] body_json: cJSON body object (can be NULL).
 *
 * @return Allocated JSON string (caller must free), or NULL on error.
 *****************************************************************************************
 */
static char* build_json_response(uint16_t code, uint8_t result, cJSON *body_json)
{
    cJSON *json = cJSON_CreateObject();
    if (json == NULL)
    {
        return NULL;
    }
    
    // 创建header对象
    cJSON *header = cJSON_CreateObject();
    if (header == NULL)
    {
        cJSON_Delete(json);
        return NULL;
    }
    
    cJSON *code_item = cJSON_CreateNumber(code);
    if (code_item == NULL)
    {
        cJSON_Delete(header);
        cJSON_Delete(json);
        return NULL;
    }
    
    cJSON_AddItemToObject(header, "code", code_item);
    cJSON_AddItemToObject(json, "header", header);
    
    // 添加body对象（如果存在）
    if (body_json != NULL)
    {
        cJSON_AddItemToObject(json, "body", body_json);
    }
    
    // 添加result
    cJSON *result_item = cJSON_CreateNumber(result);
    if (result_item == NULL)
    {
        cJSON_Delete(json);
        return NULL;
    }
    
    cJSON_AddItemToObject(json, "result", result_item);
    
    // 生成JSON字符串
    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);
    
    return json_string;
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
void ble_protocol_init(void)
{
    // 初始化传感器数据
    s_current_sensor_data.methane_vol = 0.0f;
    s_current_sensor_data.methane_lel = 0.0f;
    s_current_sensor_data.temperature = 25.0f;  // 默认温度
    s_current_sensor_data.battery_voltage = 3.7f;  // 预留
    s_current_sensor_data.battery_percent = 80;     // 预留
    s_current_sensor_data.is_valid = true;
    
    s_protocol_initialized = true;
    
    APP_LOG_INFO("BLE Protocol initialized");
}

void ble_protocol_data_process(const uint8_t *p_data, uint16_t length)
{
    if (!s_protocol_initialized)
    {
        APP_LOG_WARNING("Protocol not initialized");
        return;
    }
    
    if (p_data == NULL || length == 0)
    {
        return;
    }
    
    // 检查是否为JSON格式数据
    if (p_data[0] == '{')
    {
        parse_json_command(p_data, length);
    }
    else
    {
        APP_LOG_INFO("Received non-JSON data, length: %d", length);
    }
}

void ble_protocol_handle_query(uint8_t query_type)
{
    APP_LOG_INFO("Handling query type: %d", query_type);
    
    cJSON *body = NULL;
    char *json_string = NULL;
    
    switch (query_type)
    {
        case PROTOCOL_QUERY_TYPE_DEVICE_INFO:
            body = cJSON_CreateObject();
            if (body != NULL)
            {
                cJSON_AddStringToObject(body, "device_name", "Goodix_UART_AT");
                cJSON_AddStringToObject(body, "firmware_version", "1.0.0");
                cJSON_AddStringToObject(body, "hardware_version", "1.0");
            }
            json_string = build_json_response(PROTOCOL_CMD_QUERY, 1, body);
            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_INFO:
            body = cJSON_CreateObject();
            if (body != NULL)
            {
                cJSON_AddStringToObject(body, "status", "normal");
                cJSON_AddStringToObject(body, "connection_state", "connected");
                cJSON_AddStringToObject(body, "sensor_state", "active");
            }
            json_string = build_json_response(PROTOCOL_CMD_QUERY, 1, body);
            break;
            
        case PROTOCOL_QUERY_TYPE_STATUS_INFO:
            body = cJSON_CreateObject();
            if (body != NULL)
            {
                char methane_str[32];
                char battery_str[32];
                
                snprintf(methane_str, sizeof(methane_str), "%.2f%%vol,%.1f%%LEL",
                        s_current_sensor_data.methane_vol, s_current_sensor_data.methane_lel);
                snprintf(battery_str, sizeof(battery_str), "%.1fV,%d%%",
                        s_current_sensor_data.battery_voltage, s_current_sensor_data.battery_percent);
                
                cJSON_AddStringToObject(body, "sensor_methane", methane_str);
                cJSON_AddNumberToObject(body, "sensor_TEMP", (int)s_current_sensor_data.temperature);
                cJSON_AddStringToObject(body, "sensor_battery", battery_str);
            }
            json_string = build_json_response(PROTOCOL_CMD_QUERY, 1, body);
            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_SET:
            body = cJSON_CreateObject();
            if (body != NULL)
            {
                cJSON_AddNumberToObject(body, "sampling_interval", 1000);
                cJSON_AddNumberToObject(body, "alarm_threshold", 20);
                cJSON_AddBoolToObject(body, "auto_report", cJSON_True);
            }
            json_string = build_json_response(PROTOCOL_CMD_QUERY, 1, body);
            break;
            
        default:
            json_string = build_json_response(PROTOCOL_CMD_QUERY, 0, NULL);
            APP_LOG_WARNING("Unknown query type: %d", query_type);
            break;
    }
    
    if (json_string != NULL)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);  // cJSON_Print分配的内存需要释放
    }
    else
    {
        APP_LOG_ERROR("Failed to build JSON response for query type: %d", query_type);
    }
}

void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return;
    }
    
    cJSON *body = cJSON_CreateObject();
    if (body == NULL)
    {
        APP_LOG_ERROR("Failed to create JSON body for data report");
        return;
    }
    
    // 构建传感器数据字符串
    char methane_str[32];
    char battery_str[32];
    
    snprintf(methane_str, sizeof(methane_str), "%.2f%%vol,%.1f%%LEL",
            p_sensor_data->methane_vol, p_sensor_data->methane_lel);
    snprintf(battery_str, sizeof(battery_str), "%.1fV,%d%%",
            p_sensor_data->battery_voltage, p_sensor_data->battery_percent);
    
    // 添加数据到JSON body
    cJSON_AddStringToObject(body, "sensor_methane", methane_str);
    cJSON_AddNumberToObject(body, "sensor_TEMP", (int)p_sensor_data->temperature);
    cJSON_AddStringToObject(body, "sensor_battery", battery_str);
    
    // 构建完整的JSON响应
    char *json_string = build_json_response(PROTOCOL_CMD_DATA_REPORT, 0, body);
    
    if (json_string != NULL)
    {
        ble_protocol_send_json_response(json_string);
        free(json_string);  // 释放cJSON_Print分配的内存
        APP_LOG_INFO("Data report sent");
    }
    else
    {
        APP_LOG_ERROR("Failed to build JSON response for data report");
    }
}

float ble_protocol_vol_to_lel(float vol_percent)
{
    // 5%vol 对应 100%LEL
    return (vol_percent / METHANE_MAX_VOL_PERCENT) * METHANE_MAX_LEL_PERCENT;
}

bool ble_protocol_get_sensor_data(ble_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return false;
    }
    
    // 从传感器数据解析模块获取真实数据
    sensor_data_t real_sensor_data;
    if (sensor_data_get_latest(&real_sensor_data))
    {
        // 将传感器数据转换为BLE协议格式
        s_current_sensor_data.methane_vol = real_sensor_data.concentration;
        s_current_sensor_data.methane_lel = ble_protocol_vol_to_lel(real_sensor_data.concentration);
        s_current_sensor_data.temperature = real_sensor_data.temperature;
        s_current_sensor_data.battery_voltage = 3.6f;  // 可以从其他模块获取
        s_current_sensor_data.battery_percent = 85;    // 可以从其他模块获取
        s_current_sensor_data.is_valid = true;
        
        *p_sensor_data = s_current_sensor_data;
        return true;
    }
    else
    {
        // 如果没有真实数据，使用默认值或返回失败
        APP_LOG_WARNING("No valid sensor data available");
        return false;
    }
}

void ble_protocol_send_json_response(const char *p_json_str)
{
    if (p_json_str == NULL)
    {
        return;
    }
    
    uint16_t length = strlen(p_json_str);
    
    // 通过GUS服务发送数据
    sdk_err_t error_code = gus_tx_data_send(0, (uint8_t *)p_json_str, length);
    
    if (error_code != SDK_SUCCESS)
    {
        APP_LOG_WARNING("Failed to send JSON response, error: 0x%02X", error_code);
    }
    else
    {
        APP_LOG_INFO("JSON response sent, length: %d", length);
    }
}
