/**
 *****************************************************************************************
 *
 * @file sensor_data_parser.c
 *
 * @brief Sensor data parser implementation.
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "sensor_data_parser.h"
#include "app_log.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static sensor_data_t s_latest_sensor_data = {0};

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/** 字符串拷贝到临时缓冲区 */
static void str_copy_safe(char *dst, const char *src, uint16_t src_len, uint16_t dst_size)
{
    uint16_t len = (src_len < dst_size - 1) ? src_len : dst_size - 1;
    memcpy(dst, src, len);
    dst[len] = '\0';
}

/** 计算XOR校验码 (前25字符) */
static uint8_t calculate_checksum(const uint8_t *p_data, uint16_t length)
{
    uint8_t checksum = 0;
    uint16_t len = (length > 25) ? 25 : length;
    for (uint16_t i = 0; i < len; i++) {
        checksum ^= p_data[i];
    }
    return checksum;
}

/** 解析浮点数 */
static float parse_float(const char *str, uint16_t len)
{
    char buf[16];
    str_copy_safe(buf, str, len, sizeof(buf));
    return (float)atof(buf);
}

/** 解析整数 */
static uint32_t parse_int(const char *str, uint16_t len)
{
    char buf[16];
    str_copy_safe(buf, str, len, sizeof(buf));
    return (uint32_t)atol(buf);
}

/** 解析十六进制 */
static uint8_t parse_hex(const char *str, uint16_t len)
{
    char buf[8];
    str_copy_safe(buf, str, len, sizeof(buf));
    return (uint8_t)strtol(buf, NULL, 16);
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
sensor_parse_result_t sensor_data_parse(const uint8_t *p_data, uint16_t length, sensor_data_t *p_sensor_data)
{
    if (p_data == NULL || p_sensor_data == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    
    // 检查数据长度 (最小长度: "+000.00 +26.5 0000000 00 31\r\n" = 29字节)
    if (length < 29)
    {
        return SENSOR_PARSE_ERROR_LENGTH;
    }
    
    // 检查结尾是否为CRLF
    if (p_data[length - 2] != 0x0D || p_data[length - 1] != 0x0A)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    
    // 创建工作缓冲区
    char work_buffer[SENSOR_DATA_MAX_LEN] = {0};
    memcpy(work_buffer, p_data, length - 2); // 去掉CRLF
    work_buffer[length - 2] = '\0';
    
    // 解析各个字段
    char *token;
    char *saveptr;
    uint8_t field_count = 0;
    
    // 解析浓度字段 (+000.00)
    token = strtok_r(work_buffer, " ", &saveptr);
    if (token == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    p_sensor_data->concentration = parse_float(token, strlen(token));
    field_count++;
    
    // 解析温度字段 (+26.5)
    token = strtok_r(NULL, " ", &saveptr);
    if (token == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    p_sensor_data->temperature = parse_float(token, strlen(token));
    field_count++;
    
    // 解析预留字段 (0000000)
    token = strtok_r(NULL, " ", &saveptr);
    if (token == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    p_sensor_data->reserved_field = parse_int(token, strlen(token));
    field_count++;
    
    // 解析状态码 (00) - 十六进制格式
    token = strtok_r(NULL, " ", &saveptr);
    if (token == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    p_sensor_data->status_code = parse_hex(token, strlen(token));
    field_count++;
    
    // 解析校验码 (31) - 十六进制格式
    token = strtok_r(NULL, " ", &saveptr);
    if (token == NULL)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    p_sensor_data->checksum = parse_hex(token, strlen(token));
    field_count++;
    
    // 检查字段数量
    if (field_count != SENSOR_DATA_FIELDS_COUNT)
    {
        return SENSOR_PARSE_ERROR_INVALID_FORMAT;
    }
    
    // 计算并验证校验码
    // 校验前25个字符（不包括校验码本身和CRLF）
    uint8_t calc_checksum = calculate_checksum(p_data, 25);
    if (calc_checksum != p_sensor_data->checksum)
    {
        return SENSOR_PARSE_ERROR_CHECKSUM;
    }
    
    // 标记数据有效
    p_sensor_data->data_valid = true;
    
    // 保存到全局变量
    memcpy(&s_latest_sensor_data, p_sensor_data, sizeof(sensor_data_t));
    
    return SENSOR_PARSE_SUCCESS;
}

bool sensor_data_get_latest(sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        return false;
    }
    
    if (s_latest_sensor_data.data_valid)
    {
        memcpy(p_sensor_data, &s_latest_sensor_data, sizeof(sensor_data_t));
        return true;
    }
    
    return false;
}

void sensor_data_clear_flag(void)
{
    s_latest_sensor_data.data_valid = false;
}

bool sensor_data_is_available(void)
{
    return s_latest_sensor_data.data_valid;
}

/**
 *****************************************************************************************
 * @brief Test checksum calculation with known examples.
 * 
 * 用于验证校验码计算是否正确的测试函数
 *****************************************************************************************
 */
void sensor_data_test_checksum(void)
{
    // 测试示例1: "+017.32 +24.5 0000000 59 38<CR><LF>"
    const char test1[] = "+017.32 +24.5 0000000 59 ";
    uint8_t checksum1 = calculate_checksum((const uint8_t*)test1, 25);
    
    // 测试示例2: "+003.27 -07.3 0000000 00 34<CR><LF>"  
    const char test2[] = "+003.27 -07.3 0000000 00 ";
    uint8_t checksum2 = calculate_checksum((const uint8_t*)test2, 25);
    
    // 输出测试结果
    APP_LOG_INFO("Checksum Test Results:");
    APP_LOG_INFO("Test1: Expected=0x38(56), Calculated=0x%02X(%d)", checksum1, checksum1);
    APP_LOG_INFO("Test2: Expected=0x34(52), Calculated=0x%02X(%d)", checksum2, checksum2);
}
