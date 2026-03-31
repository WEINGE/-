/**
 *****************************************************************************************
 *
 * @file ble_protocol.h
 *
 * @brief 4G Protocol Handler Header File
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
#include "sensor_data_parser.h"

/*
 * DEFINES
 *****************************************************************************************
 */
// 协议命令定义（根据协议文档）
#define PROTOCOL_CMD_QUERY                  101     /**< 查询指令 */
#define PROTOCOL_CMD_DEVICE_INFO_REPORT     102     /**< 设备信息上报 */
#define PROTOCOL_CMD_STATUS_INFO_REPORT     103     /**< 状态信息上报 */
#define PROTOCOL_CMD_PARAM_INFO_REPORT      104     /**< 当前设置参数上报 */
#define PROTOCOL_CMD_DATA_REPORT            105     /**< 监测数据上报 */
#define PROTOCOL_CMD_COLLECT_TIME_SET       106     /**< 检测周期设置 */
#define PROTOCOL_CMD_UPDATE_TIME_SET        107     /**< 数据上报周期设置 */
#define PROTOCOL_CMD_THRESHOLD_SET          108     /**< 水位及温度报警阈值设置 */
#define PROTOCOL_CMD_LOCATION_SET           109     /**< 安装坐标设置 */
#define PROTOCOL_CMD_WATER_THRESHOLD_SET    110     /**< 水浸报警阈值设置 */
#define PROTOCOL_CMD_SERVER_ADDRESS_SET     111     /**< 服务器地址设置 */

// 查询类型定义
#define PROTOCOL_QUERY_TYPE_DEVICE_INFO     1   /**< 设备信息 */
#define PROTOCOL_QUERY_TYPE_STATUS_INFO     2   /**< 状态信息 */
#define PROTOCOL_QUERY_TYPE_CURRENT_DATA    3   /**< 当前监测数据 */
#define PROTOCOL_QUERY_TYPE_PARAM_INFO      4   /**< 当前设置参数 */

// 协议结果定义
#define PROTOCOL_RESULT_AUTO_REPORT         0   /**< 自动上报信息 */
#define PROTOCOL_RESULT_QUERY_RESPONSE      1   /**< 查询指令回文 */
#define PROTOCOL_RESULT_SET_SUCCESS         0   /**< 设置成功 */
#define PROTOCOL_RESULT_SET_FAILED          1   /**< 设置失败 */

#define WATER_DEPTH_HPA_PER_CM      0.98f   /**< 1cm水深约等于0.98hPa压力变化 */
#define MAX_WATER_DEPTH_CM          500.0f  /**< 最大检测水深 500cm */

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
    char sensor_pressure[16];    /**< 气压和水深数据 "hPa,cm" */
    int16_t sensor_TEMP;        /**< 温度值，单位 */
    char sensor_battery[16];    /**< 电池电压与电池电量百分比 */
} protocol_data_report_body_t;

/**@brief Protocol result structure. */
typedef struct
{
    uint8_t result;     /**< 0:自动上报信息，1:查询指令回义 */
} protocol_result_t;

/**@brief 4G protocol sensor data structure - WF5803F Pressure Sensor */
typedef struct
{
    float pressure_hpa;     /**< 气压 hPa （用于水位检测） */
    float water_depth_cm;   /**< 水深 cm（根据压力变化计算） */
    float altitude_m;       /**< 海拔 m */
    float temperature_c;      /**< 温度 °C */
    float battery_voltage;  /**< 电池电压 V */
    uint8_t battery_percent; /**< 电池电量 % */
    uint8_t water_level_grade;   /**< 水位档位 (0~6) */
    float water_level_temp_c;    /**< 水位传感器温度 */
    float water_level_height_cm; /**< 水位高度cm (档位*1.8) */
    float water_level_cap[7];    /**< C0-C6电容值 (pF) */
    bool is_valid;          /**< 数据有效性 */
} ble_sensor_data_t;

/**@brief Device information structure. */
typedef struct
{
    char device_id[32];         /**< 设备ID */
    char device_name[64];       /**< 设备名称 */
    char firmware_version[16];  /**< 固件版本 */
    char hardware_version[16];  /**< 硬件版本 */
    char manufacturer[32];      /**< 制造商 */
} device_info_t;

/**@brief Status information structure. */
typedef struct
{
    uint8_t device_status;      /**< 设备状态 */
    uint8_t sensor_status;      /**< 传感器状态 */
    uint8_t communication_status; /**< 通信状态 */
    uint8_t power_status;       /**< 电源状态 */
} status_info_t;

/**@brief Parameter settings structure. */
typedef struct
{
    uint16_t collect_interval;          /**< 检测周期(秒) */
    uint16_t report_interval;           /**< 上报周期(秒) */
    uint16_t device_collect_time;       /**< 传感器采集间隔，单位分钟 */
    uint16_t device_updata_time;        /**< 数据上报间隔，单位分钟 */
    float water_depth_threshold_cm;     /**< 水深报警阈值，单位cm */
    float temp_threshold;               /**< 温度报警阈值(°C) */
    float water_threshold;              /**< 水浸报警阈值 (已废弃，保留兼容) */
    float location_lat;                 /**< 纬度 */
    float location_lon;                 /**< 经度 */
    char server_address[128];           /**< 服务器地址 */
} param_settings_t;

/**@brief AT response collector structure. */
typedef struct {
    char imei[32];                      /**< IMEI */
    char iccid[32];                     /**< ICCID */
    char latitude[16];                  /**< 纬度 */
    char longitude[16];                 /**< 经度 */
    int signal_quality;                 /**< 信号质量 */
    int gps_status;                     /**< GPS状态: 0=正常定位, 1=异常 */
    int network_reg_status;             /**< 网络注册状态: 0=未注册, 1=已注册 */
    uint8_t pending_query_type;         /**< 待处理查询类型 */
    bool is_collecting;                 /**< 是否正在收集 */
    uint32_t collection_start_time;     /**< 收集开始时间 */
    char device_id[32];                 /**< 设备ID */
    char device_version[16];            /**< 设备版本 */
    char installation_location[32];     /**< 安装坐标 */
} at_response_collector_t;

/*
 * GLOBAL VARIABLE DECLARATION
 *****************************************************************************************
 */
extern at_response_collector_t g_at_collector;

/*
 * GLOBAL FUNCTION DECLARATION
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Initialize 4G protocol handler.
 *****************************************************************************************
 */
void ble_protocol_init(void);

/**
 *****************************************************************************************
 * @brief Process received data and send via 4G.
 *
 * @param[in] p_data: Pointer to received data.
 * @param[in] length: Length of received data.
 *****************************************************************************************
 */
void ble_protocol_data_process(const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Handle query command (code 101) via 4G.
 *
 * @param[in] query_type: Query type (1-4).
 *****************************************************************************************
 */
void ble_protocol_handle_query(uint8_t query_type);

/**
 *****************************************************************************************
 * @brief Send data report via 4G (code 105).
 *
 * @param[in] p_sensor_data: Pointer to sensor data.
 *****************************************************************************************
 */
void ble_protocol_send_data_report(const ble_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Handle parameter setting commands.
 *
 * @param[in] cmd_code: Command code (106-111).
 * @param[in] p_data: Pointer to parameter data.
 * @param[in] length: Length of parameter data.
 *****************************************************************************************
 */
void ble_protocol_handle_param_set(uint16_t cmd_code, const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Convert pressure change (hPa) to water depth (cm).
 *
 * @param[in] pressure_delta_hpa: Pressure change from baseline in hPa.
 *
 * @return Water depth in cm.
 *****************************************************************************************
 */
float ble_protocol_pressure_to_depth(float pressure_delta_hpa);

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
 * @brief Get current sensor data (alias for compatibility).
 *
 * @param[out] p_sensor_data: Pointer to store sensor data.
 *
 * @return true if data is valid, false otherwise.
 *****************************************************************************************
 */
bool ble_protocol_get_current_data(ble_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Send JSON formatted response via 4G.
 *
 * @param[in] p_json_str: Pointer to JSON string.
 *****************************************************************************************
 */
void ble_protocol_send_json_response(const char *p_json_str);

/**
 *****************************************************************************************
 * @brief Send debug message via 4G and UART.
 *
 * @param[in] format: Printf-style format string.
 * @param[in] ...: Variable arguments.
 *****************************************************************************************
 */
void ble_debug_printf(const char *format, ...);

/**
 *****************************************************************************************
 * @brief Get device information.
 *
 * @param[out] p_device_info: Pointer to store device information.
 *****************************************************************************************
 */
void ble_protocol_get_device_info(device_info_t *p_device_info);

/**
 *****************************************************************************************
 * @brief Get status information.
 *
 * @param[out] p_status_info: Pointer to store status information.
 *****************************************************************************************
 */
void ble_protocol_get_status_info(status_info_t *p_status_info);

/**
 *****************************************************************************************
 * @brief Get parameter settings.
 *
 * @param[out] p_param_settings: Pointer to store parameter settings.
 *****************************************************************************************
 */
void ble_protocol_get_param_settings(param_settings_t *p_param_settings);

/**
 *****************************************************************************************
 * @brief Update sensor data from external source.
 *
 * @param[in] p_sensor_data: Pointer to sensor data to update.
 *****************************************************************************************
 */
void ble_protocol_update_sensor_data(const ble_sensor_data_t *p_sensor_data);

/**
 *****************************************************************************************
 * @brief Handle 4G module response data received via UART1.
 *
 * @param[in] p_data: Pointer to received data from 4G module.
 * @param[in] length: Length of received data.
 *****************************************************************************************
 */
void ble_protocol_handle_4g_data(const uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief UART1发送函数声明
 *****************************************************************************************
 */
void uart1_tx_data_send(uint8_t *p_data, uint16_t length);

/**
 *****************************************************************************************
 * @brief Get IMEI from AT response collector.
 *
 * @param[out] p_imei_buffer: Buffer to store IMEI string.
 * @param[in] buffer_size: Size of the buffer.
 *
 * @return true if IMEI is available, false otherwise.
 *****************************************************************************************
 */
bool ble_protocol_get_imei(char *p_imei_buffer, uint16_t buffer_size);

/**
 *****************************************************************************************
 * @brief Send success response to BLE client.
 *
 * @param[in] message: Success message to send.
 *****************************************************************************************
 */
void ble_protocol_send_success_response(const char* message);

/**
 *****************************************************************************************
 * @brief Send error response to BLE client.
 *
 * @param[in] message: Error message to send.
 *****************************************************************************************
 */
void ble_protocol_send_error_response(const char* message);

#endif /* __BLE_PROTOCOL_H__ */








