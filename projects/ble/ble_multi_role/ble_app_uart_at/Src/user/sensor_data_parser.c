/**
 *****************************************************************************************
 *
 * @file sensor_data_parser.c
 *
 * @brief Sensor data parser implementation - WF5803F Pressure Sensor
 *        Replacing original UART methane sensor with I2C barometer sensor
 *        for water level detection
 *
 * @note  Ported from test2.0 water level detection project
 *        Adapted for test1.0.1 with low-power support
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "sensor_data_parser.h"
#include "wf5803f_driver.h"
#include "user_periph_setup.h"  // gpio_s_en_set for sensor power control
#include "app_log.h"
#include "gr55xx_delay.h"
#include <string.h>

/*
 * DEFINES
 *****************************************************************************************
 */
// 传感器上电等待时间（ms）
#define SENSOR_POWER_ON_DELAY_MS    100
// 传感器初始化等待时间（ms）
#define SENSOR_INIT_DELAY_MS        50

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static sensor_data_t s_latest_sensor_data = {0};
static bool s_sensor_initialized = false;

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

bool sensor_data_init(void)
{
    APP_LOG_INFO("Initializing WF5803F pressure sensor...");
    
    // 上电传感器（使用 S_EN 引脚 GPIO25）
    gpio_s_en_set(true);
    sys_delay_ms(SENSOR_POWER_ON_DELAY_MS);
    
    if (!wf5803f_init()) {
        APP_LOG_ERROR("Failed to initialize WF5803F sensor");
        gpio_s_en_set(false);  // 初始化失败则断电
        return false;
    }
    
    // 初始化数据结构
    memset(&s_latest_sensor_data, 0, sizeof(sensor_data_t));
    s_latest_sensor_data.data_valid = false;
    
    s_sensor_initialized = true;
    APP_LOG_INFO("WF5803F sensor initialized successfully");
    
    // 设置基准压力（使用当前读数）
    wf5803f_set_baseline_pressure(0.0f);
    
    return true;
}

void sensor_data_deinit(void)
{
    if (!s_sensor_initialized) {
        return;
    }
    
    // 反初始化传感器驱动
    wf5803f_deinit();
    
    // 断电传感器以节省功耗
    gpio_s_en_set(false);
    
    s_sensor_initialized = false;
    APP_LOG_DEBUG("Sensor deinitialized for low-power mode");
}

/**
 * @brief Read sensor data without power management (assumes sensor is already powered).
 * 
 * 这个函数假设调用者已经上电传感器，直接读取数据。
 * 用于定时采集等场景（外部已经管理电源）。
 */
bool sensor_data_read_no_power_mgmt(sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL) {
        APP_LOG_ERROR("Invalid sensor data pointer");
        return false;
    }
    
    // 直接读取WF5803F传感器数据（假设已经上电）
    wf5803f_data_t wf_data;
    bool read_success = wf5803f_read_data(&wf_data);
    
    if (!read_success) {
        APP_LOG_WARNING("Failed to read WF5803F sensor data");
        return false;
    }
    
    // 转换为统一格式
    p_sensor_data->pressure_hpa = wf_data.pressure_hpa;
    p_sensor_data->temperature_c = wf_data.temperature_c;
    p_sensor_data->altitude_m = wf_data.altitude_m;
    p_sensor_data->data_valid = wf_data.data_valid;
    
    // 更新全局缓存
    memcpy(&s_latest_sensor_data, p_sensor_data, sizeof(sensor_data_t));
    
    APP_LOG_DEBUG("Sensor data (no pwr mgmt): P=%.2f hPa, T=%.1f C, Alt=%.1f m",
                 p_sensor_data->pressure_hpa,
                 p_sensor_data->temperature_c,
                 p_sensor_data->altitude_m);
    
    return true;
}

/**
 * @brief Read sensor data with full power management (for BLE queries).
 * 
 * 这个函数包含完整的电源管理（上电→读取→断电），用于BLE查询等场景。
 */
bool sensor_data_read(sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL) {
        APP_LOG_ERROR("Invalid sensor data pointer");
        return false;
    }
    
    // 1. 上电传感器
    APP_LOG_DEBUG("Powering on sensor for reading...");
    gpio_s_en_set(true);
    
    // 2. 等待传感器稳定
    sys_delay_ms(SENSOR_POWER_ON_DELAY_MS);
    
    // 3. 重新初始化WF5803F驱动（传感器断电后需要重新初始化）
    if (!wf5803f_init()) {
        APP_LOG_ERROR("Failed to initialize WF5803F sensor after power-on");
        gpio_s_en_set(false);
        return false;
    }
    
    // 4. 读取WF5803F传感器数据
    bool read_success = sensor_data_read_no_power_mgmt(p_sensor_data);
    
    // 5. 断电传感器（恢复省电状态）
    wf5803f_deinit();
    gpio_s_en_set(false);
    
    if (read_success) {
        APP_LOG_INFO("Sensor read complete: P=%.2f hPa, T=%.1f C",
                     p_sensor_data->pressure_hpa,
                     p_sensor_data->temperature_c);
    }
    
    return read_success;
}

bool sensor_data_get_latest(sensor_data_t *p_sensor_data)
{
    if (p_sensor_data == NULL) {
        return false;
    }
    
    if (s_latest_sensor_data.data_valid) {
        memcpy(p_sensor_data, &s_latest_sensor_data, sizeof(sensor_data_t));
        return true;
    }
    
    return false;
}

/**
 *****************************************************************************************
 * @brief Get latest sensor data with optional force refresh (extended version).
 *
 * @param[out] p_sensor_data: Pointer to sensor data structure.
 * @param[in] force_read: If true, actively read fresh data from sensor before returning.
 *                        If false, return cached data.
 *
 * @return true if data is valid, false otherwise.
 *
 * @note This function is useful for on-demand reading scenarios (BLE/4G queries).
 *****************************************************************************************
 */
bool sensor_data_get_latest_ex(sensor_data_t *p_sensor_data, bool force_read)
{
    if (p_sensor_data == NULL) {
        return false;
    }
    
    // 如果强制读取，先主动更新缓存
    if (force_read) {
        APP_LOG_DEBUG("Force reading fresh sensor data via I2C...");
        if (!sensor_data_read(&s_latest_sensor_data)) {
            APP_LOG_WARNING("Failed to force read sensor data, using cached data");
            // 即使失败，也尝试返回缓存数据
        } else {
            APP_LOG_DEBUG("Fresh sensor data read successfully");
        }
    }
    
    // 返回缓存数据（可能是刚更新的或之前的）
    if (s_latest_sensor_data.data_valid) {
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
 * @brief Test checksum calculation with known examples (preserved for compatibility).
 *        Note: This function is no longer used with WF5803F sensor but kept for
 *        backward compatibility.
 *****************************************************************************************
 */
void sensor_data_test_checksum(void)
{
    APP_LOG_INFO("Checksum test not applicable for WF5803F pressure sensor");
    APP_LOG_INFO("WF5803F uses I2C communication with built-in error checking");
    
    // 测试传感器读取功能
    APP_LOG_INFO("Testing WF5803F sensor read...");
    sensor_data_t test_data;
    if (sensor_data_read(&test_data)) {
        APP_LOG_INFO("Sensor test OK: P=%.2f hPa, T=%.1f C, Alt=%.1f m",
                     test_data.pressure_hpa,
                     test_data.temperature_c,
                     test_data.altitude_m);
    } else {
        APP_LOG_WARNING("Sensor test failed");
    }
}

/**
 *****************************************************************************************
 * @brief Detect flood/water level condition.
 *****************************************************************************************
 */
bool sensor_data_detect_flood(float threshold_hpa)
{
    return wf5803f_detect_flood(threshold_hpa);
}

/**
 *****************************************************************************************
 * @brief Set baseline pressure for flood detection.
 *****************************************************************************************
 */
bool sensor_data_set_baseline(float baseline_hpa)
{
    return wf5803f_set_baseline_pressure(baseline_hpa);
}

/**
 *****************************************************************************************
 * @brief Get current water depth estimate (cm).
 *****************************************************************************************
 */
float sensor_data_get_water_depth(void)
{
    float baseline = wf5803f_get_baseline_pressure();
    if (baseline <= 0.0f) {
        return 0.0f;
    }
    
    wf5803f_data_t *latest = wf5803f_get_latest();
    if (latest == NULL || !latest->data_valid) {
        return 0.0f;
    }
    
    float pressure_delta = latest->pressure_filtered - baseline;
    if (pressure_delta <= 0.0f) {
        return 0.0f;
    }
    
    // 1 hPa ≈ 1.02 cm water depth
    return wf5803f_pressure_to_water_depth(pressure_delta);
}
