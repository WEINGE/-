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

    // 配置 W_EN (GPIO24) - 电源控制引脚
    // 推挽输出模式，支持动态上电/断电控制
    io_init.mode = APP_IO_MODE_OUTPUT;
    io_init.pull = APP_IO_NOPULL;
    io_init.mux  = APP_IO_MUX_7;  // GPIO功能
    io_init.pin  = WATER_SENSOR_W_EN_PIN;
    app_io_init(WATER_SENSOR_W_EN_PIN_TYPE, &io_init);
    
    // 初始状态：断电（节能模式）
    app_io_write_pin(WATER_SENSOR_W_EN_PIN_TYPE, WATER_SENSOR_W_EN_PIN, APP_IO_PIN_RESET);
    
    APP_LOG_INFO("[WATER_SENSOR] W_EN (GPIO24) initialized: OUTPUT, initial state OFF (Power Saving)");

    // 配置 WATER (AON_GPIO_7) - 水浸状态检测引脚
    // 输入模式，带下拉电阻（默认低电平，传感器未连接时为低电平）
    io_init.mode = APP_IO_MODE_INPUT;
    io_init.pull = APP_IO_PULLDOWN;  // 下拉电阻，传感器未连接时为低电平
    io_init.mux  = APP_IO_MUX_7;     // GPIO功能
    io_init.pin  = WATER_SENSOR_WATER_PIN;
    app_io_init(WATER_SENSOR_WATER_PIN_TYPE, &io_init);
    
    APP_LOG_INFO("[WATER_SENSOR] WATER (AON_GPIO_7) initialized: INPUT with PULLDOWN");
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
    if (s_water_sensor_initialized)
    {
        APP_LOG_WARNING("[WATER_SENSOR] Already initialized");
        return true;
    }

    APP_LOG_INFO("[WATER_SENSOR] Initializing water sensor module...");

    // 清空传感器数据
    memset(&s_sensor_data, 0, sizeof(water_sensor_data_t));

    // 初始化GPIO引脚
    water_sensor_gpio_init();

    // 电源已在GPIO初始化时设置为断电（节能模式）
    // 需要读取状态时，调用者需要先调用 water_sensor_set_power(true)

    // 标记已初始化
    s_water_sensor_initialized = true;

    APP_LOG_INFO("[WATER_SENSOR] Initialization complete (Power OFF for energy saving)");
    APP_LOG_INFO("[WATER_SENSOR] Call water_sensor_set_power(true) before reading status");

    return true;
}

bool water_sensor_read_status(water_sensor_data_t *p_sensor_data)
{
    if (!s_water_sensor_initialized)
    {
        APP_LOG_ERROR("[WATER_SENSOR] Not initialized");
        return false;
    }

    if (p_sensor_data == NULL)
    {
        APP_LOG_ERROR("[WATER_SENSOR] Invalid parameter: p_sensor_data is NULL");
        return false;
    }

    // 更新传感器数据
    water_sensor_update_data();

    // 复制数据到输出参数
    memcpy(p_sensor_data, &s_sensor_data, sizeof(water_sensor_data_t));

    return true;
}

uint8_t water_sensor_get_status(void)
{
    if (!s_water_sensor_initialized)
    {
        APP_LOG_WARNING("[WATER_SENSOR] Not initialized, returning default DRY status");
        return WATER_SENSOR_STATUS_DRY;
    }

    // 更新并返回水浸状态
    water_sensor_update_data();
    
    return s_sensor_data.water_status;
}

bool water_sensor_set_power(bool enable)
{
    if (!s_water_sensor_initialized)
    {
        APP_LOG_ERROR("[WATER_SENSOR] Not initialized");
        return false;
    }

    // 设置W_EN引脚电平
    app_io_pin_state_t pin_state = enable ? APP_IO_PIN_SET : APP_IO_PIN_RESET;
    app_io_write_pin(WATER_SENSOR_W_EN_PIN_TYPE, WATER_SENSOR_W_EN_PIN, pin_state);

    // 更新电源状态
    s_sensor_data.power_enabled = enable;

    APP_LOG_INFO("[WATER_SENSOR] Power %s", enable ? "ON" : "OFF");

    // 如果开启电源，等待传感器稳定
    if (enable)
    {
        sys_delay_ms(10);
        water_sensor_update_data();
    }

    return true;
}

bool water_sensor_get_power_status(void)
{
    if (!s_water_sensor_initialized)
    {
        return false;
    }

    // 直接读取W_EN引脚状态
    app_io_pin_state_t pin_state = app_io_read_pin(WATER_SENSOR_W_EN_PIN_TYPE, 
                                                    WATER_SENSOR_W_EN_PIN);
    
    return (pin_state == APP_IO_PIN_SET);
}

bool water_sensor_is_working(void)
{
    if (!s_water_sensor_initialized)
    {
        return false;
    }

    // 检查电源是否开启
    if (!water_sensor_get_power_status())
    {
        return false;
    }

    // 尝试读取状态，验证传感器是否响应
    water_sensor_update_data();

    return s_sensor_data.is_valid;
}

void water_sensor_deinit(void)
{
    if (!s_water_sensor_initialized)
    {
        return;
    }

    APP_LOG_INFO("[WATER_SENSOR] Deinitializing water sensor module...");

    // 关闭传感器电源
    water_sensor_set_power(false);

    // 清空数据
    memset(&s_sensor_data, 0, sizeof(water_sensor_data_t));

    // 标记未初始化
    s_water_sensor_initialized = false;

    APP_LOG_INFO("[WATER_SENSOR] Deinitialization complete");
}

void water_sensor_print_status(const water_sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL)
    {
        APP_LOG_ERROR("[WATER_SENSOR] Invalid parameter: p_sensor_data is NULL");
        return;
    }

    if (!p_sensor_data->is_valid)
    {
        APP_LOG_WARNING("[WATER_SENSOR] Status data is invalid");
        return;
    }

    APP_LOG_INFO("========== Water Sensor Status ==========");
    APP_LOG_INFO("  Water Status    : %s (%d)", 
                 p_sensor_data->water_status == WATER_SENSOR_STATUS_DRY ? "DRY (Not Flooded)" : "WET (Flooded)",
                 p_sensor_data->water_status);
    APP_LOG_INFO("  Power Enabled   : %s", 
                 p_sensor_data->power_enabled ? "ON" : "OFF");
    APP_LOG_INFO("  Data Valid      : %s", 
                 p_sensor_data->is_valid ? "YES" : "NO");
    APP_LOG_INFO("  Last Update Time: %u ms", 
                 p_sensor_data->last_update_time);
    APP_LOG_INFO("=========================================");
}

uint8_t water_sensor_read_with_power_mgmt(void)
{
    if (!s_water_sensor_initialized)
    {
        APP_LOG_ERROR("[WATER_SENSOR] Not initialized, returning default WET status");
        return WATER_SENSOR_STATUS_WET;  // 未初始化时返回报警状态
    }

    APP_LOG_INFO("[WATER_SENSOR] Reading with power management...");

    // 1. 上电传感器
    water_sensor_set_power(true);
    APP_LOG_DEBUG("[WATER_SENSOR] Power ON");

    // 2. 等待传感器稳定（水浸传感器响应很快，50ms足够）
    sys_delay_ms(100);

    // 3. 读取状态
    water_sensor_update_data();
    uint8_t status = s_sensor_data.water_status;

    APP_LOG_INFO("[WATER_SENSOR] Status read: %s (%d)", 
                 status == WATER_SENSOR_STATUS_DRY ? "DRY" : "WET", 
                 status);

    // 4. 断电传感器（节能）
    water_sensor_set_power(false);
    APP_LOG_DEBUG("[WATER_SENSOR] Power OFF");

    return status;
}

