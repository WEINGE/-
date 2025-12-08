/**
 *****************************************************************************************
 *
 * @file wf5803f_driver.h
 *
 * @brief WF5803F Barometer Sensor Driver Header File
 *        Digital barometer with I2C interface for water level detection
 *
 * @note  Ported from test2.0 water level detection project
 *        Adapted for test1.0.1 with low-power support
 *
 *****************************************************************************************
 */

#ifndef WF5803F_DRIVER_H
#define WF5803F_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

/*
 * DEFINES
 *****************************************************************************************
 */

// WF5803F I2C地址说明（根据数据手册Table 8）
// 7位地址格式：1101100b (SDO/ADDR=GND)
//   - 7位地址：0x6C
//   - 8位写地址：0xD8 (0x6C << 1 | 0)
//   - 8位读地址：0xD9 (0x6C << 1 | 1)
// 注：代码中使用7位地址0x6C，I2C驱动会自动添加R/W位

// 基于官方驱动的寄存器定义
#define WF5803F_REG_CMD         0x30  // 命令寄存器
#define WF5803F_REG_STATUS      0x02  // 状态寄存器
#define WF5803F_REG_DATA        0x06  // 数据寄存器起始地址（5字节：P[0:2], T[3:4]）

// 官方驱动命令
#define WF5803F_CMD_CONVERT     0x0A  // 组合转换命令（温度+压力）

// 数据有效性范围定义
#define WF5803F_PRESSURE_MIN_HPA        250.0f   // 最低压力（hPa）- 硬限制
#define WF5803F_PRESSURE_MAX_HPA        1500.0f  // 最高压力（hPa）- 硬限制
#define WF5803F_PRESSURE_NORMAL_MIN     300.0f   // 正常最低压力（海平面）
#define WF5803F_PRESSURE_NORMAL_MAX     1100.0f  // 正常最高压力（珠峰）
#define WF5803F_TEMP_MIN_C              -40.0f   // 最低温度（°C）
#define WF5803F_TEMP_MAX_C              85.0f    // 最高温度（°C）

// ADC饱和检测值（24位ADC溢出标志）
#define WF5803F_ADC_POSITIVE_SAT        0x7FFFFF // 正满量程饱和值
#define WF5803F_ADC_NEGATIVE_SAT        0x800000 // 负满量程饱和值

// 卡尔曼滤波器配置参数（针对水浸检测优化 - 快速响应版本）
// 响应优先模式：平衡滤波效果与响应速度，确保首次测量误差<5%
#define KF_PROCESS_NOISE        0.5f   // 过程噪声协方差Q - 增大以提高响应速度
#define KF_MEASUREMENT_NOISE    0.8f   // 测量噪声协方差R - 降低以更信任测量值
#define KF_INITIAL_ESTIMATE_ERROR 1.0f // 初始估计误差P0 - 降低以加快收敛
#define KF_FAST_CONVERGENCE_COUNT 3    // 快速收敛阶段的测量次数
#define KF_FAST_CONVERGENCE_GAIN  0.8f // 快速收敛阶段的最小卡尔曼增益
#define KF_LARGE_CHANGE_THRESHOLD 0.5f // 大变化阈值（hPa）- 约0.5cm水深变化即触发快速响应（5%误差控制）

/*
 * TYPE DEFINITIONS
 *****************************************************************************************
 */

/**
 * @brief 卡尔曼滤波器状态结构（一维卡尔曼滤波 - 带快速收敛支持）
 */
typedef struct {
    float x;        // 状态估计值（滤波后的气压）
    float P;        // 估计误差协方差
    float Q;        // 过程噪声协方差
    float R;        // 测量噪声协方差
    float K;        // 卡尔曼增益
    bool initialized; // 是否已初始化
    uint8_t update_count; // 更新计数器（用于快速收敛模式）
} kalman_filter_t;

/**
 * @brief WF5803F传感器数据结构
 */
typedef struct {
    float pressure_hpa;         // 气压（hPa）- 原始测量值
    float pressure_filtered;    // 气压（hPa）- 卡尔曼滤波后
    float temperature_c;        // 温度（℃）
    float altitude_m;           // 海拔高度（米）
    uint32_t raw_pressure;      // 原始气压数据（24位）
    uint16_t raw_temperature;   // 原始温度数据（16位）
    bool data_valid;            // 数据有效性标志
    uint32_t timestamp;         // 时间戳
} wf5803f_data_t;

/*
 * PUBLIC FUNCTION DECLARATIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Initialize WF5803F sensor.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_init(void);

/**
 *****************************************************************************************
 * @brief Deinitialize WF5803F sensor (for low-power mode).
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_deinit(void);

/**
 *****************************************************************************************
 * @brief Read compensated data (pressure, temperature, altitude).
 * 
 * This function implements the complete measurement cycle based on official driver:
 * 1. Trigger group conversion (WFSensor_indicateGroupConvert)
 * 2. Wait for conversion complete (WFSensor_WaitFinish)
 * 3. Read 5-byte raw data (WFSensor_getTPData)
 * 4. Calculate pressure and temperature (calculatePress)
 *
 * @param[out] data: Pointer to store sensor data.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_read_data(wf5803f_data_t *data);

/**
 *****************************************************************************************
 * @brief Get latest sensor data.
 *
 * @return Pointer to latest sensor data.
 *****************************************************************************************
 */
wf5803f_data_t* wf5803f_get_latest(void);

/**
 *****************************************************************************************
 * @brief Calculate altitude from pressure.
 *
 * @param[in] pressure_hpa: Current pressure in hPa.
 * @param[in] sea_level_hpa: Sea level pressure in hPa (default: 1013.25).
 *
 * @return Altitude in meters.
 *****************************************************************************************
 */
float wf5803f_calculate_altitude(float pressure_hpa, float sea_level_hpa);

/**
 *****************************************************************************************
 * @brief Enable/Disable Kalman filter for pressure data.
 * 
 * When enabled, wf5803f_read_data() will apply Kalman filtering to pressure readings.
 * Recommended for flood detection to reduce noise and false alarms.
 *
 * @param[in] enable: true to enable, false to disable.
 *****************************************************************************************
 */
void wf5803f_set_kalman_filter(bool enable);

/**
 *****************************************************************************************
 * @brief Reset Kalman filter to initial state.
 * 
 * Call this when sensor is relocated or baseline pressure changes significantly.
 *****************************************************************************************
 */
void wf5803f_reset_kalman_filter(void);

/**
 *****************************************************************************************
 * @brief Get pressure change rate (hPa/reading).
 * 
 * Useful for flood detection: rapid pressure increase indicates water rising.
 * 
 * @return Pressure change rate in hPa per reading cycle.
 *****************************************************************************************
 */
float wf5803f_get_pressure_change_rate(void);

/**
 *****************************************************************************************
 * @brief Read multiple samples and return average (for high-precision scenarios).
 * 
 * This function performs multiple sensor readings and returns the averaged pressure value.
 * Useful when high accuracy is needed (e.g., alarm confirmation).
 *
 * @param[in] samples: Number of samples to take (3-10 recommended).
 * @param[out] data: Pointer to store averaged sensor data.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_read_multi_samples(uint8_t samples, wf5803f_data_t *data);

/**
 *****************************************************************************************
 * @brief Set baseline pressure for flood detection.
 * 
 * This sets the reference pressure for detecting water immersion.
 * Should be called when device is installed in normal (dry) condition.
 *
 * @param[in] baseline_hpa: Baseline pressure in hPa (if 0, use current reading).
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_set_baseline_pressure(float baseline_hpa);

/**
 *****************************************************************************************
 * @brief Get baseline pressure.
 *
 * @return Baseline pressure in hPa.
 *****************************************************************************************
 */
float wf5803f_get_baseline_pressure(void);

/**
 *****************************************************************************************
 * @brief Detect flood condition based on pressure change.
 * 
 * Compares current filtered pressure against baseline.
 * Returns flood status based on configured threshold.
 *
 * @param[in] threshold_hpa: Pressure increase threshold for flood alarm (e.g., 10 hPa).
 *
 * @return true if flood detected, false otherwise.
 *****************************************************************************************
 */
bool wf5803f_detect_flood(float threshold_hpa);

/**
 *****************************************************************************************
 * @brief Convert water depth (cm) to pressure change (hPa).
 * 
 * Helper function for flood detection threshold conversion.
 * Conversion formula: 1 cm water depth ≈ 0.98 hPa pressure increase
 *
 * @param[in] water_depth_cm: Water depth in centimeters.
 *
 * @return Pressure change in hPa.
 *****************************************************************************************
 */
static inline float wf5803f_water_depth_to_pressure(float water_depth_cm)
{
    return water_depth_cm * 0.98f;  // 1 cm ≈ 0.98 hPa
}

/**
 *****************************************************************************************
 * @brief Convert pressure change (hPa) to water depth (cm).
 * 
 * Helper function for reporting water depth from pressure change.
 * Conversion formula: 1 hPa ≈ 1.02 cm water depth
 *
 * @param[in] pressure_hpa: Pressure change in hPa.
 *
 * @return Water depth in centimeters.
 *****************************************************************************************
 */
static inline float wf5803f_pressure_to_water_depth(float pressure_hpa)
{
    return pressure_hpa / 0.98f;  // 1 hPa ≈ 1.02 cm
}

#endif // WF5803F_DRIVER_H
