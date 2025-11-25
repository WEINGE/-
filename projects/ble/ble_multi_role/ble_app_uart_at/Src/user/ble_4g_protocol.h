/**
 *****************************************************************************************
 *
 * @file ble_4g_protocol.h
 *
 * @brief 4G Protocol Handler Header File
 *
 *****************************************************************************************
 * @attention
  #####Copyright (c) 2019 GOODIX
  All rights reserved.
 *****************************************************************************************
 */
#ifndef __BLE_4G_PROTOCOL_H__
#define __BLE_4G_PROTOCOL_H__

#include <stdint.h>
#include <stdbool.h>
#include "gr_includes.h"
#include "sensor_data_parser.h"
#include "app_timer.h"

/*
 * DEFINES
 *****************************************************************************************
 */
// 4G协议命令定义（根据4g协议.md文档）
#define PROTOCOL_4G_CMD_DEVICE_INFO_REPORT     102     /**< 设备信息上报 */
#define PROTOCOL_4G_CMD_STATUS_INFO_REPORT     103     /**< 状态信息上报 */
#define PROTOCOL_4G_CMD_PARAM_INFO_REPORT      104     /**< 当前设置参数上报 */
#define PROTOCOL_4G_CMD_DATA_REPORT            105     /**< 监测数据上报 */
#define PROTOCOL_4G_CMD_COLLECT_TIME_SET       106     /**< 检测周期设置 */
#define PROTOCOL_4G_CMD_UPDATE_TIME_SET        107     /**< 数据上报周期设置 */
#define PROTOCOL_4G_CMD_THRESHOLD_SET          108     /**< 甲烷及温度报警阈值设置 */
#define PROTOCOL_4G_CMD_WATER_THRESHOLD_SET    110     /**< 水浸报警阈值设置 */
#define PROTOCOL_4G_CMD_QUERY_SETTINGS         120     /**< 查询设置变更 */

// 4G协议结果定义
#define PROTOCOL_4G_RESULT_SET_SUCCESS         0   /**< 设置成功 */
#define PROTOCOL_4G_RESULT_SET_FAILED          1   /**< 设置失败 */

// 设备ID缓冲区长度定义
#define DEVICE_ID_SIZE                         32

// 特殊字段定义（根据图片中的特殊字段说明）
#define SPECIAL_FIELD_IMEI          "${IMEI}"        /**< IMEI号 */
#define SPECIAL_FIELD_ICCID         "${ICCID}"       /**< SIM卡ICCID */
#define SPECIAL_FIELD_SN            "${SN}"          /**< 设备序列号 */
#define SPECIAL_FIELD_CSQ           "${CSQ}"         /**< 信号质量 */
#define SPECIAL_FIELD_UNIX          "${UNIX}"        /**< Unix时间戳 */
#define SPECIAL_FIELD_LAC           "${LAC}"         /**< 基站LAC */
#define SPECIAL_FIELD_CID           "${CID}"         /**< 基站CID */
#define SPECIAL_FIELD_LON           "${LON}"         /**< GPS经度 */
#define SPECIAL_FIELD_LAT           "${LAT}"         /**< GPS纬度 */
#define SPECIAL_FIELD_ALT           "${ALT}"         /**< GPS海拔 */
#define SPECIAL_FIELD_UTC_TIME      "${UTC_TIME}"    /**< UTC时间 */

#define METHANE_MAX_VOL_PERCENT     5.0f    /**< 甲烷最大浓度 5%vol */
#define METHANE_MAX_LEL_PERCENT     100.0f  /**< 对应100%LEL */

/*
 * TYPE DEFINITIONS
 *****************************************************************************************
 */
/**@brief 4G protocol sensor data structure. */
typedef struct
{
    float methane_vol;      /**< 甲烷浓度 %vol */
    float methane_lel;      /**< 甲烷浓度 %LEL */
    int16_t temperature;    /**< 温度 ℃ */
    float battery_voltage;  /**< 电池电压 V */
    uint8_t battery_percent; /**< 电池电量 % */
    char collect_time[16];  /**< 数据收集时间 */
    bool is_valid;          /**< 数据有效性 */
} ble_4g_sensor_data_t;

/**@brief 4G device information structure. */
typedef struct
{
    char device_id[32];         /**< 设备ID */
    char device_ver[16];        /**< 设备固件版本号 */
} ble_4g_device_info_t;

/**@brief 4G status information structure. */
typedef struct
{
    uint8_t device_water;       /**< 水浸状态（1：水浸，0：未水浸） */
    uint8_t sensor_status;      /**< 激光传感器状态（0：正常，1：异常） */
    uint8_t device_move;        /**< 防盗状态（0：定位与安装坐标一致，1：定位与安装坐标不一致） */
    uint8_t device_LTE_signal;  /**< 4G信号值，0-31 */
    uint8_t device_GPS_status;  /**< GPS信号状态（0：正常，1：异常） */
} ble_4g_status_info_t;

/**@brief 4G parameter settings structure. */
typedef struct
{
    uint16_t device_collect_time;   /**< 传感器采集间隔，单位分钟 */
    uint16_t device_updata_time;    /**< 数据上报间隔，单位分钟 */
    float methane_threshold;        /**< 甲烷报警阈值浓度，单位%vol */
    int16_t TEMPH_threshold;        /**< 高温报警阈值，单位℃ */
    int16_t TEMPL_threshold;        /**< 低温报警阈值，单位℃ */
    int16_t water_threshold;        /**< 水浸报警阈值 */
} ble_4g_param_settings_t;

/*
 * GLOBAL FUNCTION DECLARATION
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Initialize 4G protocol handler.
 *****************************************************************************************
 */
void ble_4g_protocol_init(void);

/**
 *****************************************************************************************
 * @brief Process received JSON data from 4G module.
 *
 * @param[in] p_data: Pointer to received JSON data.
 * @param[in] length: Length of received data.
 *****************************************************************************************
 */
void ble_4g_protocol_data_process(const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Send device information report (code 102).
 *****************************************************************************************
 */
void ble_4g_protocol_send_device_info_report(void);

/**
 *****************************************************************************************
 * @brief Send status information report (code 103).
 *****************************************************************************************
 */
void ble_4g_protocol_send_status_info_report(void);

/**
 *****************************************************************************************
 * @brief Send parameter information report (code 104).
 *****************************************************************************************
 */
void ble_4g_protocol_send_param_info_report(void);

/**
 *****************************************************************************************
 * @brief Send sensor data report (code 105).
 *
 * @param[in] p_sensor_data: Pointer to sensor data.
 *****************************************************************************************
 */
void ble_4g_protocol_send_data_report(const ble_4g_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Send settings query (code 120).
 *****************************************************************************************
 */
void ble_4g_protocol_send_settings_query(void);

/**
 *****************************************************************************************
 * @brief Handle parameter setting commands from server.
 *
 * @param[in] cmd_code: Command code (106, 107, 108, 110).
 * @param[in] p_data: Pointer to parameter data.
 * @param[in] length: Length of parameter data.
 *****************************************************************************************
 */
void ble_4g_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Convert methane %vol to %LEL.
 *
 * @param[in] vol_percent: Methane concentration in %vol.
 *
 * @return Methane concentration in %LEL.
 *****************************************************************************************
 */
float ble_4g_protocol_vol_to_lel(float vol_percent);

/**
 *****************************************************************************************
 * @brief Get current sensor data.
 *
 * @param[out] p_sensor_data: Pointer to store sensor data.
 *
 * @return true if data is valid, false otherwise.
 *****************************************************************************************
 */
bool ble_4g_protocol_get_sensor_data(ble_4g_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Get device information.
 *
 * @param[out] p_device_info: Pointer to store device information.
 *****************************************************************************************
 */
void ble_4g_protocol_get_device_info(ble_4g_device_info_t *p_device_info);

/**
 *****************************************************************************************
 * @brief Get status information.
 *
 * @param[out] p_status_info: Pointer to store status information.
 *****************************************************************************************
 */
void ble_4g_protocol_get_status_info(ble_4g_status_info_t *p_status_info);

/**
 *****************************************************************************************
 * @brief Get parameter settings.
 *
 * @param[out] p_param_settings: Pointer to store parameter settings.
 *****************************************************************************************
 */
void ble_4g_protocol_get_param_settings(ble_4g_param_settings_t *p_param_settings);

/**
 *****************************************************************************************
 * @brief Start sensor data collection timer.
 *****************************************************************************************
 */
void ble_4g_protocol_start_collect_timer(void);

/**
 *****************************************************************************************
 * @brief Start data report timer.
 *****************************************************************************************
 */
void ble_4g_protocol_start_report_timer(void);

/**
 *****************************************************************************************
 * @brief Stop sensor data collection timer.
 *****************************************************************************************
 */
void ble_4g_protocol_stop_collect_timer(void);

/**
 *****************************************************************************************
 * @brief Stop data report timer.
 *****************************************************************************************
 */
void ble_4g_protocol_stop_report_timer(void);

/**
 *****************************************************************************************
 * @brief Restart collect timer with new interval.
 *****************************************************************************************
 */
void ble_4g_protocol_restart_collect_timer(void);

/**
 *****************************************************************************************
 * @brief Restart report timer with new interval.
 *****************************************************************************************
 */
void ble_4g_protocol_restart_report_timer(void);

/**
 *****************************************************************************************
 * @brief Update sensor data from external source.
 *
 * @param[in] p_sensor_data: Pointer to sensor data to update.
 *****************************************************************************************
 */
void ble_4g_protocol_update_sensor_data(const ble_4g_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Get collected data count.
 *
 * @return Number of collected data points.
 *****************************************************************************************
 */
uint8_t ble_4g_protocol_get_collected_data_count(void);

/**
 *****************************************************************************************
 * @brief Clear collected data buffer.
 *****************************************************************************************
 */
void ble_4g_protocol_clear_collected_data(void);

/**
 *****************************************************************************************
 * @brief Trigger immediate upload with current sensor data.
 * 
 * This function performs an immediate upload of the current sensor data along with
 * status information, similar to the timer-triggered upload but without delay.
 * Used for threshold-exceeded scenarios.
 *
 * @param[in] p_sensor_data: Pointer to the sensor data to upload immediately
 *****************************************************************************************
 */
void ble_4g_protocol_trigger_immediate_upload(const ble_4g_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Send static information reports.
 * 
 * This function sends all static information including:
 * - Device info report (code 102)
 * - Parameter info report (code 104) 
 * - Settings query (code 120)
 *****************************************************************************************
 */
void ble_4g_protocol_send_static_info(void);

/**
 *****************************************************************************************
 * @brief Control sensor power (S_EN pin).
 *
 * @param[in] enable: true to power on sensor, false to power off.
 *****************************************************************************************
 */
void ble_4g_protocol_sensor_power_control(bool enable);



/**
 *****************************************************************************************
 * @brief Read sensor data with power management.
 * 
 * This function:
 * 1. Powers on the 4G/sensor power domain and sensor (S_EN), and opens the sensor UART
 * 2. Waits several seconds for the sensor to stabilize and produce fresh data
 * 3. Reads the latest sensor data, updates shared status flags, and attaches a timestamp
 * 4. Powers off the sensor, closes UART, and turns off the related power domain
 *
 * @param[out] p_sensor_data: Pointer to store sensor data.
 *
 * @return true if data read successfully, false otherwise.
 *****************************************************************************************
 */
bool ble_4g_protocol_read_sensor_with_power_mgmt(ble_4g_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Get collection timestamp for 4G protocol
 * 
 * This helper reads time from the RTC (bm8563) and returns a formatted
 * collection timestamp string for use in 4G reports. The timestamp uses
 * minute resolution in the form "YYYYMMDDHHmm" (12 digits), and falls back
 * to safe default values if the RTC is not running or time is invalid.
 * 
 * @param[out] timestamp_buffer Buffer to store the timestamp string
 * 
 * @return true if timestamp obtained successfully, false otherwise
 *****************************************************************************************
 */
bool get_collection_timestamp_for_4g(char *timestamp_buffer);

/**
 *****************************************************************************************
 * @brief Core data upload function (without power management).
 * 
 * This helper sends the current dynamic reports (105 sensor data and
 * 103 status) followed by static reports (102 device info, 104 parameter
 * info, and a 120 settings query). It assumes the 4G/DTU module and UART
 * are already powered on and initialized by the caller.
 *****************************************************************************************
 */
void ble_4g_protocol_upload(void);

/**
 *****************************************************************************************
 * @brief Upload data with 4G/DTU power management.
 * 
 * This function performs a full upload cycle with DTU电源管理:
 * 1. Powers on the 4G/DTU power domain and UART, then waits for the module to stabilize
 * 2. If server configuration has changed, pushes updated MQTT settings to the DTU and saves them
 * 3. Updates DTU info cache (IMEI, CSQ, ICCID, GPS) using AT commands
 * 4. Reports sensor (105) and status (103) data according to water-alarm state
 *    and any accumulated samples, then clears the collected buffer if needed
 * 5. Sends static information (102/104) and a settings query (120)
 * 6. Waits briefly for possible downlink commands, then powers off the 4G/DTU
 *    module and closes the related UART/power resources
 *****************************************************************************************
 */
void ble_4g_protocol_upload_with_power_mgmt(void);

// 内部工具函数，用于获取当前设备ID（IMEI或回退ID）
void ble_4g_protocol_get_device_id(char *p_device_id_buffer, uint16_t buffer_size);

#endif /* __BLE_4G_PROTOCOL_H__ */
