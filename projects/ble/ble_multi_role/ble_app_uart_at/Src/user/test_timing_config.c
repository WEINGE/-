/**
 *****************************************************************************************
 *
 * @file test_timing_config.c
 *
 * @brief 蓝牙时间参数配置功能测试程序
 *
 *****************************************************************************************
 */

#include <stdio.h>
#include <string.h>
#include "ble_protocol.h"
#include "ble_4g_protocol.h"
#include "cJSON.h"

/*
 * DEFINES
 *****************************************************************************************
 */
#define TEST_DEVICE_ID "12:34:56:78:9A:BC"

/*
 * LOCAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
static void test_collect_time_setting(void);
static void test_report_time_setting(void);
static void test_parameter_validation(void);
static void test_json_format(void);

/**
 *****************************************************************************************
 * @brief 测试采集时间设置功能
 *****************************************************************************************
 */
static void test_collect_time_setting(void)
{
    printf("\n=== 测试采集时间设置功能 ===\n");
    
    // 测试用例1: 设置采集时间为2分钟
    const char* test_json_1 = 
        "{"
        "\"header\":{"
            "\"code\":106,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"collect_time_set\":2"
        "}"
        "}";
    
    printf("Test Case 1: Set collect time to 2 minutes\n");
    printf("发送JSON: %s\n", test_json_1);
    
    // 模拟BLE协议处理
    ble_protocol_data_process((const uint8_t*)test_json_1, strlen(test_json_1));
    
    // 测试用例2: 设置采集时间为10分钟
    const char* test_json_2 = 
        "{"
        "\"header\":{"
            "\"code\":106,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"collect_time_set\":10"
        "}"
        "}";
    
    printf("\nTest Case 2: Set collect time to 10 minutes\n");
    printf("发送JSON: %s\n", test_json_2);
    
    ble_protocol_data_process((const uint8_t*)test_json_2, strlen(test_json_2));
}

/**
 *****************************************************************************************
 * @brief 测试上报时间设置功能
 *****************************************************************************************
 */
static void test_report_time_setting(void)
{
    printf("\n=== 测试上报时间设置功能 ===\n");
    
    // 测试用例1: 设置上报时间为5分钟
    const char* test_json_1 = 
        "{"
        "\"header\":{"
            "\"code\":107,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"updata_time_set\":5"
        "}"
        "}";
    
    printf("Test Case 1: Set report time to 5 minutes\n");
    printf("发送JSON: %s\n", test_json_1);
    
    ble_protocol_data_process((const uint8_t*)test_json_1, strlen(test_json_1));
    
    // 测试用例2: 设置上报时间为30分钟
    const char* test_json_2 = 
        "{"
        "\"header\":{"
            "\"code\":107,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"updata_time_set\":30"
        "}"
        "}";
    
    printf("\nTest Case 2: Set report time to 30 minutes\n");
    printf("发送JSON: %s\n", test_json_2);
    
    ble_protocol_data_process((const uint8_t*)test_json_2, strlen(test_json_2));
}

/**
 *****************************************************************************************
 * @brief 测试参数验证功能
 *****************************************************************************************
 */
static void test_parameter_validation(void)
{
    printf("\n=== 测试参数验证功能 ===\n");
    
    // 测试用例1: 无效的采集时间（超出范围）
    const char* invalid_json_1 = 
        "{"
        "\"header\":{"
            "\"code\":106,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"collect_time_set\":1500"  // 超出1440分钟限制
        "}"
        "}";
    
    printf("Test Case 1: Invalid collect time (1500 minutes, out of range)\n");
    printf("发送JSON: %s\n", invalid_json_1);
    printf("预期结果: 应返回错误响应\n");
    
    ble_protocol_data_process((const uint8_t*)invalid_json_1, strlen(invalid_json_1));
    
    // 测试用例2: 无效的上报时间（小于最小值）
    const char* invalid_json_2 = 
        "{"
        "\"header\":{"
            "\"code\":107,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            "\"updata_time_set\":0"  // 小于1分钟限制
        "}"
        "}";
    
    printf("\nTest Case 2: Invalid report time (0 minutes, below minimum)\n");
    printf("发送JSON: %s\n", invalid_json_2);
    printf("预期结果: 应返回错误响应\n");
    
    ble_protocol_data_process((const uint8_t*)invalid_json_2, strlen(invalid_json_2));
    
    // 测试用例3: 缺少参数字段
    const char* invalid_json_3 = 
        "{"
        "\"header\":{"
            "\"code\":106,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "},"
        "\"body\":{"
            // 缺少collect_time_set字段
        "}"
        "}";
    
    printf("\n测试用例3: 缺少参数字段\n");
    printf("发送JSON: %s\n", invalid_json_3);
    printf("预期结果: 应返回错误响应\n");
    
    ble_protocol_data_process((const uint8_t*)invalid_json_3, strlen(invalid_json_3));
}

/**
 *****************************************************************************************
 * @brief 测试JSON格式处理
 *****************************************************************************************
 */
static void test_json_format(void)
{
    printf("\n=== 测试JSON格式处理 ===\n");
    
    // 测试用例1: 查询当前参数设置
    const char* query_json = 
        "{"
        "\"header\":{"
            "\"code\":104,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        "}"
        "}";
    
    printf("测试用例1: 查询当前参数设置\n");
    printf("发送JSON: %s\n", query_json);
    printf("预期结果: 应返回包含device_collect_time和device_updata_time的JSON\n");
    
    ble_protocol_data_process((const uint8_t*)query_json, strlen(query_json));
    
    // 测试用例2: 无效的JSON格式
    const char* invalid_json = 
        "{"
        "\"header\":{"
            "\"code\":106,"
            "\"device_ID\":\"" TEST_DEVICE_ID "\""
        // 缺少闭合括号，JSON格式错误
        ;
    
    printf("\n测试用例2: 无效的JSON格式\n");
    printf("发送JSON: %s\n", invalid_json);
    printf("预期结果: 应忽略或返回JSON解析错误\n");
    
    ble_protocol_data_process((const uint8_t*)invalid_json, strlen(invalid_json));
}

/**
 *****************************************************************************************
 * @brief 主测试函数
 *****************************************************************************************
 */
void test_timing_config_main(void)
{
    printf("Starting Bluetooth timing parameter configuration test...\n");
    
    // 初始化协议模块（在实际环境中应该已经初始化）
    // ble_protocol_init();
    // ble_4g_protocol_init();
    
    // 执行各项测试
    test_collect_time_setting();
    test_report_time_setting();
    test_parameter_validation();
    test_json_format();
    
    printf("\n=== 测试完成 ===\n");
    printf("请检查日志输出以验证功能是否正常工作\n");
    printf("预期行为:\n");
    printf("1. 有效参数设置应返回成功响应并重启对应定时器\n");
    printf("2. 无效参数应返回错误响应且不修改当前设置\n");
    printf("3. 参数查询应返回当前的时间配置\n");
    printf("4. JSON格式错误应被正确处理\n");
}

/**
 *****************************************************************************************
 * @brief 使用示例函数
 *****************************************************************************************
 */
void timing_config_usage_example(void)
{
    printf("\n=== 蓝牙时间参数配置使用示例 ===\n");
    
    printf("1. Set collect time to 2 minutes:\n");
    printf("   Send: {\"header\":{\"code\":106,\"device_ID\":\"12:34:56:78:9A:BC\"},\"body\":{\"collect_time_set\":2}}\n");
    printf("   Response: {\"header\":{\"code\":106},\"body\":{\"collect_time_set\":2},\"result\":0}\n\n");
    
    printf("2. Set report time to 10 minutes:\n");
    printf("   Send: {\"header\":{\"code\":107,\"device_ID\":\"12:34:56:78:9A:BC\"},\"body\":{\"updata_time_set\":10}}\n");
    printf("   Response: {\"header\":{\"code\":107},\"body\":{\"updata_time_set\":10},\"result\":0}\n\n");
    
    printf("3. Query current parameters:\n");
    printf("   Send: {\"header\":{\"code\":104,\"device_ID\":\"12:34:56:78:9A:BC\"}}\n");
    printf("   Response: {\"header\":{\"code\":104,\"device_ID\":\"12:34:56:78:9A:BC\"},\"body\":{\"device_collect_time\":2,\"device_updata_time\":10,...}}\n\n");
    
    printf("4. Parameter ranges:\n");
    printf("   Collect time: 1-1440 minutes (1 minute to 24 hours)\n");
    printf("   Report time: 1-1440 minutes (1 minute to 24 hours)\n\n");
    
    printf("5. Error handling:\n");
    printf("   Out of range: {\"header\":{\"code\":106},\"result\":1}\n");
    printf("   Missing parameter: {\"header\":{\"code\":106},\"result\":1}\n");
}
