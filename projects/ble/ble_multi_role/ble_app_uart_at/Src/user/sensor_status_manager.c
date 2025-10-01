/**
 *****************************************************************************************
 *
 * @file sensor_status_manager.c
 *
 * @brief 传感器状态管理器实现 - 简化传感器状态为正常/异常两种状态
 *
 * @details 实现功能：
 *          - 根据ES100文档状态码表判断传感器状态
 *          - 状态码00=正常，其他所有状态码=异常
 *          - 提供状态查询和管理接口
 *
 *****************************************************************************************
 */

#include "sensor_status_manager.h"
#include <string.h>

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static sensor_status_info_t s_sensor_status_info = {
    .current_status = SENSOR_SIMPLE_STATUS_NORMAL,
    .raw_status_code = 0,
    .last_update_time = 0,
    .status_valid = false
};

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 * 根据ES100文档状态码表判断是否为正常状态
 * 只有状态码00表示正常，其他所有状态码都表示异常
 */
static bool is_status_code_normal(uint8_t status_code)
{
    return (status_code == 0x00);  // 只有00表示正常
}

/**
 * 获取状态码的描述信息
 */
static const char* get_status_description(uint8_t status_code)
{
    switch (status_code)
    {
        case 0x00: return "正常";
        case 0x56: return "软件异常"; 
        case 0x57: return "温度异常";
        case 0x58: return "光源异常";
        case 0x59: return "硬件异常";
        default:   return "未知异常";
    }
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

void sensor_status_manager_init(void)
{
    memset(&s_sensor_status_info, 0, sizeof(s_sensor_status_info));
    
    // 初始化为异常状态，直到接收到有效的传感器数据
    s_sensor_status_info.current_status = SENSOR_SIMPLE_STATUS_ABNORMAL;
    s_sensor_status_info.raw_status_code = 0x56;  // 软件异常
    s_sensor_status_info.status_valid = false;
    s_sensor_status_info.last_update_time = 0;
}

void sensor_status_update(uint8_t raw_status_code)
{
    s_sensor_status_info.raw_status_code = raw_status_code;
    
    // 根据状态码判断简化状态
    if (is_status_code_normal(raw_status_code))
    {
        s_sensor_status_info.current_status = SENSOR_SIMPLE_STATUS_NORMAL;
    }
    else
    {
        s_sensor_status_info.current_status = SENSOR_SIMPLE_STATUS_ABNORMAL;
    }
    
    s_sensor_status_info.status_valid = true;
    // TODO: 更新时间戳 (需要系统时间接口)
    s_sensor_status_info.last_update_time++;
}

sensor_simple_status_t sensor_status_get_simple(void)
{
    if (!s_sensor_status_info.status_valid)
    {
        return SENSOR_SIMPLE_STATUS_ABNORMAL;  // 状态无效时返回异常
    }
    
    return s_sensor_status_info.current_status;
}

bool sensor_status_get_info(sensor_status_info_t *p_status_info)
{
    if (p_status_info == NULL)
    {
        return false;
    }
    
    memcpy(p_status_info, &s_sensor_status_info, sizeof(sensor_status_info_t));
    return s_sensor_status_info.status_valid;
}

bool sensor_status_is_normal(void)
{
    return (s_sensor_status_info.status_valid && 
            s_sensor_status_info.current_status == SENSOR_SIMPLE_STATUS_NORMAL);
}

bool sensor_status_is_code_normal(uint8_t status_code)
{
    return is_status_code_normal(status_code);
}

const char* sensor_status_get_description(uint8_t status_code)
{
    return get_status_description(status_code);
}

/**
 * 从传感器数据更新状态 (与sensor_data_parser模块集成)
 */
void sensor_status_update_from_sensor_data(void)
{
    sensor_data_t sensor_data;
    
    // 获取最新的传感器数据
    if (sensor_data_get_latest(&sensor_data) && sensor_data.data_valid)
    {
        // 更新传感器状态
        sensor_status_update(sensor_data.status_code);
    }
    else
    {
        // 传感器数据无效，设置为异常状态
        sensor_status_update(0x56);  // 软件异常
    }
} 
