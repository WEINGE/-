/**
 *****************************************************************************************
 *
 * @file ble_protocol.c
 *
 * @brief 传感器数据JSON传输协议实现
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

#include "sensor_data_parser.h"
#include "cJSON.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

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




// 数据处理函数
void ble_protocol_data_process(const uint8_t* data, uint16_t length)
{
    if (!s_protocol_initialized) {

        return;
    }
    
    if (data == NULL || length == 0) {

        return;
    }
    
    // 处理接收到的数据

    
    // 这里可以添加具体的数据处理逻辑
    // 例如解析命令、更新状态等
}

// 获取传感器数据
bool ble_protocol_get_sensor_data(ble_sensor_data_t* p_sensor_data)
{
    if (!s_protocol_initialized) {

        return false;
    }
    
    if (p_sensor_data == NULL) {

        return false;
    }
    
    // 复制当前传感器数据
    memcpy(p_sensor_data, &s_current_sensor_data, sizeof(ble_sensor_data_t));
    return true;
}

// 处理查询命令
void ble_protocol_handle_query(uint8_t query_type)
{
    if (!s_protocol_initialized) {

        return;
    }
    

    
    // 根据查询类型处理
    switch (query_type) {
        case PROTOCOL_QUERY_TYPE_DEVICE_INFO:
            // 处理设备信息查询

            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_INFO:
            // 处理参数信息查询

            break;
            
        case PROTOCOL_QUERY_TYPE_STATUS_INFO:
            // 处理状态信息查询

            break;
            
        case PROTOCOL_QUERY_TYPE_PARAM_SET:
            // 处理参数设置查询

            break;
            
        default:

            break;
    }
}

// 发送数据报告
void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data)
{
    if (!s_protocol_initialized) {

        return;
    }
    
    if (p_sensor_data == NULL) {

        return;
    }
    

    
    // 这里可以添加实际的数据发送逻辑
    // 例如通过BLE发送数据包
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
void ble_protocol_init(void)
{
    // 初始化传感器数据结构
    memset(&s_current_sensor_data, 0, sizeof(ble_sensor_data_t));
    s_current_sensor_data.temperature = 25.0f;      // 默认温度
    s_current_sensor_data.battery_voltage = 3.7f;   // 默认电池电压
    s_current_sensor_data.battery_percent = 80;     // 默认电池电量
    s_current_sensor_data.is_valid = false;         // 初始状态为无效
    
    s_protocol_initialized = true;
    

}

void ble_protocol_update_sensor_data(void)
{
    if (!s_protocol_initialized)
    {
        return;
    }
    
    // 从传感器数据解析模块获取最新数据
    sensor_data_t real_sensor_data;
    if (sensor_data_get_latest(&real_sensor_data))
    {
        // 更新传感器数据
        s_current_sensor_data.methane_vol = real_sensor_data.concentration;
        s_current_sensor_data.methane_lel = ble_protocol_vol_to_lel(real_sensor_data.concentration);
        s_current_sensor_data.temperature = real_sensor_data.temperature;
        s_current_sensor_data.is_valid = true;
        

    }
    else
    {
        s_current_sensor_data.is_valid = false;
    }
}



float ble_protocol_vol_to_lel(float vol_percent)
{
    // 甲烷气体：5%vol 对应 100%LEL
    const float METHANE_MAX_VOL = 5.0f;
    const float METHANE_MAX_LEL = 100.0f;
    
    return (vol_percent / METHANE_MAX_VOL) * METHANE_MAX_LEL;
}

bool ble_protocol_get_current_data(ble_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL || !s_protocol_initialized)
    {
        return false;
    }
    
    // 更新最新的传感器数据
    ble_protocol_update_sensor_data();
    
    // 返回当前数据
    *p_sensor_data = s_current_sensor_data;
    return s_current_sensor_data.is_valid;
}

void ble_protocol_set_battery_info(float voltage, uint8_t percent)
{
    if (s_protocol_initialized)
    {
        s_current_sensor_data.battery_voltage = voltage;
        s_current_sensor_data.battery_percent = percent;

    }
}

