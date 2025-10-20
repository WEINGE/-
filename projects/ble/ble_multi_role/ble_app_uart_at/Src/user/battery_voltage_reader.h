/**
 *****************************************************************************************
 *
 * @file battery_voltage_reader.h
 *
 * @brief Battery voltage reader header file.
 *        实现电池电压读取功能，使用MSIO1口进行ADC采样
 *
 *****************************************************************************************
 */

#ifndef __BATTERY_VOLTAGE_READER_H__
#define __BATTERY_VOLTAGE_READER_H__

#include <stdint.h>
#include <stdbool.h>
#include "app_io.h"
#include "board_SK.h"

/*
 * DEFINES
 *****************************************************************************************
 */
/**@brief 分压电路参数 */
// 理论值：R1=51kΩ, R2=20kΩ → 比值 = (51+20)/20 = 3.55
// 
// 第一次校准（测量值偏高约5.4%）：
//   7.22V实际 → 7.648V测量 (偏差1.059倍)
//   6.99V实际 → 7.300V测量 (偏差1.044倍)
//   7.42V实际 → 7.854V测量 (偏差1.059倍)
//   修正: 3.55 / 1.054 = 3.369
//
// 第二次精密校准（测量值仍偏高约1.52%）：
//   7.29V实际 → 7.44V测量 (偏差1.021倍)
//   7.01V实际 → 7.144V测量 (偏差1.019倍)
//   6.67V实际 → 6.71V测量 (偏差1.006倍)
//   修正: 3.369 / 1.0152 = 3.318
//
#define VOLTAGE_DIVIDER_R1_OHM     51000
#define VOLTAGE_DIVIDER_R2_OHM     20000
#define VOLTAGE_DIVIDER_RATIO       3.312f  /**< 经过三次实测精密校准后的分压比 */

/**@brief ADC参数 */
#define ADC_REFERENCE_VOLTAGE       1.6f
#define ADC_RESOLUTION             4096      /**< 12位ADC分辨率 2^12 = 4096 */
#define ADC_MAX_VALUE              (ADC_RESOLUTION - 1)

/**@brief 电池电压范围 */
#define BATTERY_VOLTAGE_MIN        3.6f     /**< 最低电池电压 3.6V (0%) */
#define BATTERY_VOLTAGE_MAX        7.2f     /**< 最高电池电压 7.2V (100%) */

/**@brief ADC硬件配置 */
#define BATTERY_ADC_PIN            APP_IO_PIN_1         /**< MSIO1 用于电池电压采样（单端模式下配置为channel_n） */
#define BATTERY_ADC_PIN_TYPE       APP_IO_TYPE_MSIO     /**< MSIO类型 */
#define BATTERY_ADC_INPUT_SRC      ADC_INPUT_SRC_IO1    /**< ADC输入源：MSIO1（单端模式实际采样通道） */
#define BATTERY_ADC_SAMPLES        16                   /**< ADC采样次数（用于平均） */

/**@brief 校准配置 */
#define ENABLE_PIECEWISE_CALIBRATION   1               /**< 启用分段线性校准 */

/**@brief 校准点定义（三点分段线性校准） */
// 校准点1：6.0V电池电压
#define CALIB_POINT1_MEAS            6000.0f           /**< 测量值：6.0V */
#define CALIB_POINT1_REAL            6000.0f           /**< 实际值：6.0V */

// 校准点2：7.2V电池电压  
#define CALIB_POINT2_MEAS            7200.0f           /**< 测量值：7.2V */
#define CALIB_POINT2_REAL            7200.0f           /**< 实际值：7.2V */

// 校准点3：8.4V电池电压
#define CALIB_POINT3_MEAS            8400.0f           /**< 测量值：8.4V */
#define CALIB_POINT3_REAL            8400.0f           /**< 实际值：8.4V */

/*
 * STRUCTURES
 *****************************************************************************************
 */
/**@brief 电池电压数据结构 */
typedef struct
{
    uint16_t adc_raw_value;     /**< ADC原始采样值 (0-4095) */
    float raw_voltage;          /**< ADC原始电压值 (V) */
    float battery_voltage;      /**< 实际电池电压 (V) */
    uint8_t battery_percent;    /**< 电池电量百分比 (0-100) */
    bool is_valid;             /**< 数据有效性 */
} battery_voltage_data_t;

/*
 * FUNCTION DECLARATIONS
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief 初始化电池电压读取模块
 *
 * @return true if initialization successful, false otherwise.
 *****************************************************************************************
 */
bool battery_voltage_reader_init(void);

/**
 *****************************************************************************************
 * @brief 读取电池电压
 *
 * @param[out] p_voltage_data: 指向电池电压数据结构的指针
 *
 * @return true if reading successful, false otherwise.
 *****************************************************************************************
 */
bool battery_voltage_reader_get_voltage(battery_voltage_data_t *p_voltage_data);

/**
 *****************************************************************************************
 * @brief 通过BLE发送电池电压日志
 *
 * @param[in] p_voltage_data: 电池电压数据结构指针
 *****************************************************************************************
 */
void battery_voltage_send_ble_log(const battery_voltage_data_t *p_voltage_data);

/**
 *****************************************************************************************
 * @brief 反初始化电池电压读取模块
 *****************************************************************************************
 */
void battery_voltage_reader_deinit(void);

#endif /* __BATTERY_VOLTAGE_READER_H__ */


