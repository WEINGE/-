/**
 *****************************************************************************************
 *
 * @file ble_protocol.h
 *
 * @brief BLE Protocol Handler Header File
 *
 *****************************************************************************************
 * @attention
  #####Copyright (c) 2019 GOODIX
  All rights reserved.
 *****************************************************************************************
 */
#ifndef __BLE_PROTOCOL_H__
#define __BLE_PROTOCOL_H__

#include <stdint.h>
#include <stdbool.h>
#include "gr_includes.h"

/*
 * DEFINES
 *****************************************************************************************
 */
#define PROTOCOL_CMD_QUERY          101     /**< 查询指令 */
#define PROTOCOL_CMD_DATA_REPORT    105     /**< 蓝牙数据上报 */

#define PROTOCOL_QUERY_TYPE_DEVICE_INFO     1   /**< 设备信息 */
#define PROTOCOL_QUERY_TYPE_PARAM_INFO      2   /**< 状态信息 */
#define PROTOCOL_QUERY_TYPE_STATUS_INFO     3   /**< 当前监测数据 */
#define PROTOCOL_QUERY_TYPE_PARAM_SET       4   /**< 当前设置参数 */

#define METHANE_MAX_VOL_PERCENT     5.0f    /**< 甲烷最大浓度 5%vol */
#define METHANE_MAX_LEL_PERCENT     100.0f  /**< 对应100%LEL */

/*
 * TYPE DEFINITIONS
 *****************************************************************************************
 */
/**@brief Protocol header structure. */
typedef struct
{
    uint16_t code;      /**< 命令代码 */
} protocol_header_t;

/**@brief Protocol body for query command. */
typedef struct
{
    uint8_t type;       /**< 查询内容类型 */
} protocol_query_body_t;

/**@brief Protocol body for data report. */
typedef struct
{
    char sensor_methane[16];    /**< 甲烷检测数值，包含%vol和LEL两种数据格式 */
    int16_t sensor_TEMP;        /**< 温度值，单位℃ */
    char sensor_battery[16];    /**< 电池电压与电池电量百分比 */
} protocol_data_report_body_t;

/**@brief Protocol result structure. */
typedef struct
{
    uint8_t result;     /**< 0:自动上报信息，1:查询指令回义 */
} protocol_result_t;

/**@brief BLE protocol sensor data structure. */
typedef struct
{
    float methane_vol;      /**< 甲烷浓度 %vol */
    float methane_lel;      /**< 甲烷浓度 %LEL */
    float temperature;      /**< 温度 ℃ */
    float battery_voltage;  /**< 电池电压 V (预留) */
    uint8_t battery_percent; /**< 电池电量 % (预留) */
    bool is_valid;          /**< 数据有效性 */
} ble_sensor_data_t;

/*
 * GLOBAL FUNCTION DECLARATION
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Initialize BLE protocol handler.
 *****************************************************************************************
 */
void ble_protocol_init(void);

/**
 *****************************************************************************************
 * @brief Process received BLE protocol data.
 *
 * @param[in] p_data: Pointer to received data.
 * @param[in] length: Length of received data.
 *****************************************************************************************
 */
void ble_protocol_data_process(const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Handle query command (code 101).
 *
 * @param[in] query_type: Query type (1-4).
 *****************************************************************************************
 */
void ble_protocol_handle_query(uint8_t query_type);

/**
 *****************************************************************************************
 * @brief Send data report (code 105).
 *
 * @param[in] p_sensor_data: Pointer to sensor data.
 *****************************************************************************************
 */
void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Convert methane %vol to %LEL.
 *
 * @param[in] vol_percent: Methane concentration in %vol.
 *
 * @return Methane concentration in %LEL.
 *****************************************************************************************
 */
float ble_protocol_vol_to_lel(float vol_percent);

/**
 *****************************************************************************************
 * @brief Get current sensor data.
 *
 * @param[out] p_sensor_data: Pointer to store sensor data.
 *
 * @return true if data is valid, false otherwise.
 *****************************************************************************************
 */
bool ble_protocol_get_sensor_data(ble_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Send JSON formatted response.
 *
 * @param[in] p_json_str: Pointer to JSON string.
 *****************************************************************************************
 */
void ble_protocol_send_json_response(const char *p_json_str);

#endif /* __BLE_PROTOCOL_H__ */
