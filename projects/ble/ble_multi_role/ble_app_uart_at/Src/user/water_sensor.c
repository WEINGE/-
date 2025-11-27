/**
 *****************************************************************************************
 *
 * @file water_sensor.c
 *
 * @brief 水浸传感器驱动实现文件
 *        实现水浸传感器的初始化、状态读取和电源控制功能
 *
 * @details 硬件配置：
 *          - W_EN (GPIO24): 水浸传感器电源控制，推挽输出，默认高电平（开启）
 *          - WATER (AON_GPIO_7): 水浸状态检测，输入模式，高电平=未浸水，低电平=浸水
 *
 * @attention
 *  Copyright (c) 2025 GOODIX
 *  All rights reserved.
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "water_sensor.h"
#include "app_log.h"
#include "app_io.h"
#include "grx_sys.h"
#include <string.h>

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static bool s_water_sensor_initialized = false;     /**< 初始化标志 */
static water_sensor_data_t s_sensor_data;           /**< 传感器状态数据 */

/*
 * LOCAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
static void water_sensor_gpio_init(void);
static void water_sensor_update_data(void);

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief 初始化水浸传感器GPIO引脚
 *****************************************************************************************
 */
static void water_sensor_gpio_init(void)
{
    app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;

    // W_EN (GPIO24) - 电源控制，推挽输出
    io_init.mode = APP_IO_MODE_OUTPUT;
    io_init.pull = APP_IO_NOPULL;
    io_init.mux  = APP_IO_MUX_7;
    io_init.pin  = WATER_SENSOR_W_EN_PIN;
    app_io_init(WATER_SENSOR_W_EN_PIN_TYPE, &io_init);
    app_io_write_pin(WATER_SENSOR_W_EN_PIN_TYPE, WATER_SENSOR_W_EN_PIN, APP_IO_PIN_RESET);

    // WATER (AON_GPIO_7) - 状态检测，输入下拉
    io_init.mode = APP_IO_MODE_INPUT;
    io_init.pull = APP_IO_PULLDOWN;
    io_init.pin  = WATER_SENSOR_WATER_PIN;
    app_io_init(WATER_SENSOR_WATER_PIN_TYPE, &io_init);
}

/**
 *****************************************************************************************
 * @brief 更新水浸传感器数据
 *****************************************************************************************
 */
static void water_sensor_update_data(void)
{
    // 读取WATER引脚状态
    app_io_pin_state_t pin_state = app_io_read_pin(WATER_SENSOR_WATER_PIN_TYPE, 
                                                    WATER_SENSOR_WATER_PIN);
    
    // 高电平=未浸水(0)，低电平=浸水(1)
    s_sensor_data.water_status = (pin_state == APP_IO_PIN_RESET) ? 
                                  WATER_SENSOR_STATUS_WET : WATER_SENSOR_STATUS_DRY;
    
    // 读取电源状态
    app_io_pin_state_t power_state = app_io_read_pin(WATER_SENSOR_W_EN_PIN_TYPE, 
                                                      WATER_SENSOR_W_EN_PIN);
    s_sensor_data.power_enabled = (power_state == APP_IO_PIN_SET);
    
    // 更新时间戳（使用简单计数器）
    static uint32_t update_counter = 0;
    s_sensor_data.last_update_time = update_counter++;
    
    // 标记数据有效
    s_sensor_data.is_valid = true;
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

bool water_sensor_init(void)
{
    if (s_water_sensor_initialized) {
        return true;
    }

    memset(&s_sensor_data, 0, sizeof(water_sensor_data_t));
    water_sensor_gpio_init();
    s_water_sensor_initialized = true;

    APP_LOG_INFO("[WATER] Init OK (power off)");
    return true;
}

bool water_sensor_read_status(water_sensor_data_t *p_sensor_data)
{
    if (!s_water_sensor_initialized || !p_sensor_data) {
        return false;
    }
    water_sensor_update_data();
    memcpy(p_sensor_data, &s_sensor_data, sizeof(water_sensor_data_t));
    return true;
}

uint8_t water_sensor_get_status(void)
{
    if (!s_water_sensor_initialized) {
        return WATER_SENSOR_STATUS_DRY;
    }
    water_sensor_update_data();
    return s_sensor_data.water_status;
}

bool water_sensor_set_power(bool enable)
{
    if (!s_water_sensor_initialized) {
        return false;
    }
    
    app_io_write_pin(WATER_SENSOR_W_EN_PIN_TYPE, WATER_SENSOR_W_EN_PIN, 
                     enable ? APP_IO_PIN_SET : APP_IO_PIN_RESET);
    s_sensor_data.power_enabled = enable;
    
    if (enable) {
        sys_delay_ms(10);
        water_sensor_update_data();
    }
    return true;
}

bool water_sensor_get_power_status(void)
{
    if (!s_water_sensor_initialized) {
        return false;
    }
    return (app_io_read_pin(WATER_SENSOR_W_EN_PIN_TYPE, WATER_SENSOR_W_EN_PIN) == APP_IO_PIN_SET);
}

bool water_sensor_is_working(void)
{
    if (!s_water_sensor_initialized || !water_sensor_get_power_status()) {
        return false;
    }
    water_sensor_update_data();
    return s_sensor_data.is_valid;
}

void water_sensor_deinit(void)
{
    if (!s_water_sensor_initialized) {
        return;
    }
    water_sensor_set_power(false);
    memset(&s_sensor_data, 0, sizeof(water_sensor_data_t));
    s_water_sensor_initialized = false;
}

void water_sensor_print_status(const water_sensor_data_t *p_sensor_data)
{
    if (!p_sensor_data || !p_sensor_data->is_valid) {
        return;
    }
    APP_LOG_INFO("[WATER] status=%s power=%s", 
                 p_sensor_data->water_status ? "WET" : "DRY",
                 p_sensor_data->power_enabled ? "ON" : "OFF");
}

uint8_t water_sensor_read_with_power_mgmt(void)
{
    if (!s_water_sensor_initialized) {
        return WATER_SENSOR_STATUS_WET;  // 未初始化返回报警状态
    }

    // 上电 -> 等待稳定 -> 读取 -> 断电
    water_sensor_set_power(true);
    sys_delay_ms(100);
    water_sensor_update_data();
    uint8_t status = s_sensor_data.water_status;
    water_sensor_set_power(false);

    return status;
}

