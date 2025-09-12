/**
 *****************************************************************************************
 *
 * @file ble_protocol_test.c
 *
 * @brief BLE Protocol Test Implementation
 *
 *****************************************************************************************
 */

#include "ble_protocol.h"
#include "app_log.h"
#include "cJSON.h"
#include <string.h>
#include <stdlib.h>

/*
 * TEST FUNCTIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Test BLE protocol query commands.
 *****************************************************************************************
 */
void ble_protocol_test_queries(void)
{
    APP_LOG_INFO("=== BLE Protocol Query Test ===");
    
    // 测试查询类型1：设备信息
    APP_LOG_INFO("Testing query type 1 (Device Info)...");
    ble_protocol_handle_query(1);
    
    // 测试查询类型2：状态信息  
    APP_LOG_INFO("Testing query type 2 (Status Info)...");
    ble_protocol_handle_query(2);
    
    // 测试查询类型3：当前监测数据
    APP_LOG_INFO("Testing query type 3 (Current Data)...");
    ble_protocol_handle_query(3);
    
    // 测试查询类型4：当前设置参数
    APP_LOG_INFO("Testing query type 4 (Parameters)...");
    ble_protocol_handle_query(4);
}

/**
 *****************************************************************************************
 * @brief Test BLE protocol data report.
 *****************************************************************************************
 */
void ble_protocol_test_data_report(void)
{
    APP_LOG_INFO("=== BLE Protocol Data Report Test ===");
    
    ble_sensor_data_t sensor_data;
    
    // 尝试获取真实传感器数据
    if (ble_protocol_get_sensor_data(&sensor_data))
    {
        APP_LOG_INFO("Using real sensor data:");
        APP_LOG_INFO("Methane: %.2f%%vol / %.1f%%LEL", sensor_data.methane_vol, sensor_data.methane_lel);
        APP_LOG_INFO("Temperature: %.1f°C", sensor_data.temperature);
        APP_LOG_INFO("Battery: %.1fV (%d%%)", sensor_data.battery_voltage, sensor_data.battery_percent);
        
        ble_protocol_send_data_report(&sensor_data);
    }
    else
    {
        // 如果没有真实数据，使用测试数据
        APP_LOG_WARNING("No real sensor data available, using test data");
        ble_sensor_data_t test_data = {
            .methane_vol = 1.25f,
            .methane_lel = 25.0f,
            .temperature = 23.5f,
            .battery_voltage = 3.6f,
            .battery_percent = 75,
            .is_valid = true
        };
        
        APP_LOG_INFO("Methane: %.2f%%vol / %.1f%%LEL", test_data.methane_vol, test_data.methane_lel);
        APP_LOG_INFO("Temperature: %.1f°C", test_data.temperature);
        
        ble_protocol_send_data_report(&test_data);
    }
}

/**
 *****************************************************************************************
 * @brief Test cJSON library functionality.
 *****************************************************************************************
 */
void ble_protocol_test_cjson_functionality(void)
{
    APP_LOG_INFO("=== cJSON Library Functionality Test ===");
    
    // 测试cJSON创建和解析
    cJSON *test_json = cJSON_CreateObject();
    if (test_json == NULL)
    {
        APP_LOG_ERROR("Failed to create cJSON object");
        return;
    }
    
    // 添加测试数据
    cJSON_AddNumberToObject(test_json, "test_number", 123.45);
    cJSON_AddStringToObject(test_json, "test_string", "Hello cJSON");
    cJSON_AddBoolToObject(test_json, "test_bool", cJSON_True);
    
    // 生成JSON字符串
    char *json_string = cJSON_Print(test_json);
    if (json_string != NULL)
    {
        APP_LOG_INFO("Generated JSON: %s", json_string);
        
        // 解析JSON字符串
        cJSON *parsed_json = cJSON_Parse(json_string);
        if (parsed_json != NULL)
        {
            cJSON *number_item = cJSON_GetObjectItem(parsed_json, "test_number");
            cJSON *string_item = cJSON_GetObjectItem(parsed_json, "test_string");
            cJSON *bool_item = cJSON_GetObjectItem(parsed_json, "test_bool");
            
            if (cJSON_IsNumber(number_item))
            {
                APP_LOG_INFO("Parsed number: %.2f", cJSON_GetNumberValue(number_item));
            }
            
            if (cJSON_IsString(string_item))
            {
                APP_LOG_INFO("Parsed string: %s", cJSON_GetStringValue(string_item));
            }
            
            if (cJSON_IsBool(bool_item))
            {
                APP_LOG_INFO("Parsed bool: %s", cJSON_IsTrue(bool_item) ? "true" : "false");
            }
            
            cJSON_Delete(parsed_json);
            APP_LOG_INFO("cJSON functionality test PASSED");
        }
        else
        {
            APP_LOG_ERROR("Failed to parse JSON string");
        }
        
        free(json_string);
    }
    else
    {
        APP_LOG_ERROR("Failed to generate JSON string");
    }
    
    cJSON_Delete(test_json);
}

/**
 *****************************************************************************************
 * @brief Test JSON command parsing with cJSON.
 *****************************************************************************************
 */
void ble_protocol_test_json_parsing(void)
{
    APP_LOG_INFO("=== BLE Protocol JSON Parsing Test (cJSON) ===");
    
    // 测试查询命令JSON - 使用cJSON生成标准格式
    cJSON *query_json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    cJSON *body = cJSON_CreateObject();
    
    cJSON_AddNumberToObject(header, "code", 101);
    cJSON_AddNumberToObject(body, "type", 4);
    
    cJSON_AddItemToObject(query_json, "header", header);
    cJSON_AddItemToObject(query_json, "body", body);
    
    char *query_string = cJSON_Print(query_json);
    if (query_string != NULL)
    {
        APP_LOG_INFO("Testing JSON query command: %s", query_string);
        ble_protocol_data_process((const uint8_t *)query_string, strlen(query_string));
        free(query_string);
    }
    cJSON_Delete(query_json);
    
    // 测试数据上报请求JSON
    cJSON *report_json = cJSON_CreateObject();
    cJSON *report_header = cJSON_CreateObject();
    
    cJSON_AddNumberToObject(report_header, "code", 105);
    cJSON_AddItemToObject(report_json, "header", report_header);
    
    char *report_string = cJSON_Print(report_json);
    if (report_string != NULL)
    {
        APP_LOG_INFO("Testing JSON data report request: %s", report_string);
        ble_protocol_data_process((const uint8_t *)report_string, strlen(report_string));
        free(report_string);
    }
    cJSON_Delete(report_json);
    
    // 测试错误格式JSON
    const char *invalid_json = "{\"header\":{\"code\":\"invalid\"}}";
    APP_LOG_INFO("Testing invalid JSON: %s", invalid_json);
    ble_protocol_data_process((const uint8_t *)invalid_json, strlen(invalid_json));
}

/**
 *****************************************************************************************
 * @brief Test methane conversion function.
 *****************************************************************************************
 */
void ble_protocol_test_conversion(void)
{
    APP_LOG_INFO("=== BLE Protocol Conversion Test ===");
    
    float test_values[] = {0.0f, 1.0f, 2.5f, 5.0f};
    int test_count = sizeof(test_values) / sizeof(test_values[0]);
    
    for (int i = 0; i < test_count; i++)
    {
        float vol = test_values[i];
        float lel = ble_protocol_vol_to_lel(vol);
        APP_LOG_INFO("%.1f%%vol = %.1f%%LEL", vol, lel);
    }
}

/**
 *****************************************************************************************
 * @brief Run all BLE protocol tests.
 *****************************************************************************************
 */
void ble_protocol_run_all_tests(void)
{
    APP_LOG_INFO("Starting BLE Protocol Tests (cJSON Version)...");
    
    ble_protocol_test_cjson_functionality();
    ble_protocol_test_conversion();
    ble_protocol_test_queries();
    ble_protocol_test_data_report();
    ble_protocol_test_json_parsing();
    
    APP_LOG_INFO("BLE Protocol Tests Completed.");
}
