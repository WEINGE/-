/**
 *****************************************************************************************
 *
 * @file sensor_data_parser.h
 *
 * @brief Sensor data parser header file.
 *
 *****************************************************************************************
 */

#ifndef __SENSOR_DATA_PARSER_H__
#define __SENSOR_DATA_PARSER_H__

#include <stdint.h>
#include <stdbool.h>

/*
 * DEFINES
 *****************************************************************************************
 */
#define SENSOR_DATA_MAX_LEN         64
#define SENSOR_DATA_FIELDS_COUNT    5

/*
 * ENUMERATIONS
 *****************************************************************************************
 */
/**@brief Sensor data parse result. */
typedef enum
{
    SENSOR_PARSE_SUCCESS = 0,
    SENSOR_PARSE_ERROR_INVALID_FORMAT,
    SENSOR_PARSE_ERROR_CHECKSUM,
    SENSOR_PARSE_ERROR_LENGTH,
} sensor_parse_result_t;

/*
 * STRUCTURES
 *****************************************************************************************
 */
/**@brief Sensor data structure. */
typedef struct
{
    float concentration;        // 浓度 (%vol)
    float temperature;         // 温度 (°C)
    uint32_t reserved_field;   // 预留字段
    uint8_t status_code;       // 状态码
    uint8_t checksum;          // 校验码
    bool data_valid;           // 数据有效标志
} sensor_data_t;

/*
 * FUNCTION DECLARATIONS
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Parse sensor data from received string.
 *
 * @param[in]  p_data: Pointer to received data string.
 * @param[in]  length: Length of received data.
 * @param[out] p_sensor_data: Pointer to parsed sensor data structure.
 *
 * @return Parse result.
 *****************************************************************************************
 */
sensor_parse_result_t sensor_data_parse(const uint8_t *p_data, uint16_t length, sensor_data_t *p_sensor_data);

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
 * @brief Test checksum calculation with known examples.
 *****************************************************************************************
 */
void sensor_data_test_checksum(void);

#endif /* __SENSOR_DATA_PARSER_H__ */
