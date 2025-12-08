/**
 *****************************************************************************************
 *
 * @file sensor_data_parser.h
 *
 * @brief Sensor data parser header file - WF5803F Pressure Sensor
 *        Replacing original methane sensor with barometer sensor for water level detection
 *
 * @note  Ported from test2.0 water level detection project
 *        Adapted for test1.0.1 with low-power support
 *
 *****************************************************************************************
 */

#ifndef __SENSOR_DATA_PARSER_H__
#define __SENSOR_DATA_PARSER_H__

#include <stdint.h>
#include <stdbool.h>

/*
 * TYPE DEFINITIONS
 *****************************************************************************************
 */

/**
 * @brief Sensor data structure (pressure sensor for water level detection)
 */
typedef struct
{
    float pressure_hpa;         // 气压（hPa）- 用于水位检测
    float temperature_c;        // 温度（°C）
    float altitude_m;           // 海拔（米）
    bool data_valid;            // 数据有效标志
} sensor_data_t;

/*
 * FUNCTION DECLARATIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Initialize sensor module (WF5803F pressure sensor).
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool sensor_data_init(void);

/**
 *****************************************************************************************
 * @brief Deinitialize sensor module (for low-power mode).
 *****************************************************************************************
 */
void sensor_data_deinit(void);

/**
 *****************************************************************************************
 * @brief Read sensor data with full power management (上电→读取→断电).
 *
 * @param[out] p_sensor_data: Pointer to sensor data structure.
 *
 * @return true if successful, false otherwise.
 * 
 * @note This function includes power control. Use for BLE queries or when sensor is off.
 *****************************************************************************************
 */
bool sensor_data_read(sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Read sensor data without power management (assumes sensor is already on).
 *
 * @param[out] p_sensor_data: Pointer to sensor data structure.
 *
 * @return true if successful, false otherwise.
 * 
 * @note This function assumes the sensor is already powered. Use for timed collections.
 *****************************************************************************************
 */
bool sensor_data_read_no_power_mgmt(sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Get latest parsed sensor data.
 *
 * @param[out] p_sensor_data: Pointer to sensor data structure.
 *
 * @return true if data is valid, false otherwise.
 *****************************************************************************************
 */
bool sensor_data_get_latest(sensor_data_t *p_sensor_data);

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
 * @note Use this for on-demand scenarios where fresh data is critical (BLE/4G queries).
 *****************************************************************************************
 */
bool sensor_data_get_latest_ex(sensor_data_t *p_sensor_data, bool force_read);

/**
 *****************************************************************************************
 * @brief Clear sensor data valid flag.
 *****************************************************************************************
 */
void sensor_data_clear_flag(void);

/**
 *****************************************************************************************
 * @brief Check if sensor data is available.
 *
 * @return true if data is available, false otherwise.
 *****************************************************************************************
 */
bool sensor_data_is_available(void);

/**
 *****************************************************************************************
 * @brief Test checksum calculation with known examples (preserved for compatibility).
 *****************************************************************************************
 */
void sensor_data_test_checksum(void);

/**
 *****************************************************************************************
 * @brief Detect flood/water level condition.
 *
 * @param[in] threshold_hpa: Pressure increase threshold for flood alarm (e.g., 10 hPa).
 *
 * @return true if flood detected, false otherwise.
 *****************************************************************************************
 */
bool sensor_data_detect_flood(float threshold_hpa);

/**
 *****************************************************************************************
 * @brief Set baseline pressure for flood detection.
 *
 * @param[in] baseline_hpa: Baseline pressure in hPa (if 0, use current reading).
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool sensor_data_set_baseline(float baseline_hpa);

/**
 *****************************************************************************************
 * @brief Get current water depth estimate (cm).
 *
 * @return Water depth in cm (0 if no flood detected or baseline not set).
 *****************************************************************************************
 */
float sensor_data_get_water_depth(void);

#endif /* __SENSOR_DATA_PARSER_H__ */
