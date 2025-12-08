/**
 *****************************************************************************************
 *
 * @file wf5803f_driver.c
 *
 * @brief WF5803F Barometer Sensor Driver Implementation
 *        For water level detection via pressure measurement
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
#include "wf5803f_driver.h"
#include "soft_i2c.h"
#include "app_log.h"
#include "grx_sys.h"
#include "gr55xx_delay.h"
#include <math.h>
#include <string.h>

/*
 * DEFINES
 *****************************************************************************************
 */
// I2C地址配置（确认硬件：SDO/ADDR引脚接GND）
// 说明：soft_i2c_read_reg() 会自动执行 (addr << 1)，所以传入7位地址
// 
// 地址计算：
//   7位地址 0x6C << 1 = 0xD8 (8位写地址)
//   7位地址 0x6C << 1 | 1 = 0xD9 (8位读地址)
//
// 如果你的硬件 SDO/ADDR 引脚接 VDD，改用：
//   #define WF5803F_ADDR  0x6D  (对应8位地址0xDA/0xDB)
#define WF5803F_ADDR            0x6C  // 7位地址（SDO=GND）
#define WF5803F_REG_CMD         0x30  // 命令寄存器
#define WF5803F_REG_STATUS      0x02  // 状态寄存器
#define WF5803F_REG_DATA        0x06  // 数据寄存器起始地址
#define WF5803F_CMD_CONVERT     0x0A  // 组合转换命令（温度+压力）

/*
 * LOCAL VARIABLES
 *****************************************************************************************
 */
static wf5803f_data_t s_latest_data = {0};
static bool s_initialized = false;
static kalman_filter_t s_kf_pressure = {0};  // 气压卡尔曼滤波器
static bool s_kalman_enabled = true;         // 默认启用卡尔曼滤波
static float s_prev_pressure = 0.0f;         // 上一次压力值（用于变化率计算）
static float s_pressure_change_rate = 0.0f;  // 压力变化率（hPa/次）

// 水浸检测基准压力
static float s_baseline_pressure = 0.0f;     // 基准压力（正常干燥状态下的压力）
static bool s_baseline_set = false;          // 基准压力是否已设置

/*
 * LOCAL FUNCTION IMPLEMENTATIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Initialize Kalman filter for pressure.
 * 
 * One-dimensional Kalman filter algorithm:
 * - State: x (pressure in hPa)
 * - Measurement: z (raw pressure reading)
 * 
 * Kalman filter equations:
 *   Prediction:  x_pred = x (constant model, no motion)
 *                P_pred = P + Q
 *   Update:      K = P_pred / (P_pred + R)
 *                x = x_pred + K * (z - x_pred)
 *                P = (1 - K) * P_pred
 * 
 * @param[in] kf: Pointer to Kalman filter structure
 * @param[in] initial_value: Initial pressure estimate (hPa)
 *****************************************************************************************
 */
static void kalman_filter_init(kalman_filter_t *kf, float initial_value)
{
    kf->x = initial_value;
    kf->P = KF_INITIAL_ESTIMATE_ERROR;
    kf->Q = KF_PROCESS_NOISE;
    kf->R = KF_MEASUREMENT_NOISE;
    kf->K = 0.0f;
    kf->initialized = true;
    kf->update_count = 0;  // 初始化更新计数器
    
    APP_LOG_INFO("WF5803F: Kalman filter initialized with x=%.2f hPa (fast convergence mode for first %d samples)",
                 initial_value, KF_FAST_CONVERGENCE_COUNT);
}

/**
 *****************************************************************************************
 * @brief Update Kalman filter with new measurement.
 * 
 * @param[in] kf: Pointer to Kalman filter structure
 * @param[in] measurement: New pressure measurement (hPa)
 * 
 * @return Filtered pressure value (hPa)
 *****************************************************************************************
 */
static float kalman_filter_update(kalman_filter_t *kf, float measurement)
{
    if (!kf->initialized) {
        kalman_filter_init(kf, measurement);
        return measurement;  // 第一次测量直接返回测量值，不做滤波
    }
    
    // 更新计数器
    if (kf->update_count < 255) {
        kf->update_count++;
    }
    
    // 预测步骤（简化模型：假设压力恒定）
    // x_pred = x
    // P_pred = P + Q
    float P_pred = kf->P + kf->Q;
    
    // 更新步骤
    // K = P_pred / (P_pred + R)
    kf->K = P_pred / (P_pred + kf->R);
    
    // 快速收敛模式：前N次测量使用更高的卡尔曼增益
    bool fast_convergence = (kf->update_count <= KF_FAST_CONVERGENCE_COUNT);
    if (fast_convergence && kf->K < KF_FAST_CONVERGENCE_GAIN) {
        kf->K = KF_FAST_CONVERGENCE_GAIN;  // 强制使用更高的增益以快速跟踪测量值
        APP_LOG_DEBUG("WF5803F: Fast convergence mode - K forced to %.2f (sample %d/%d)",
                     kf->K, kf->update_count, KF_FAST_CONVERGENCE_COUNT);
    }
    
    // 计算测量值与滤波值的差异
    float diff = measurement - kf->x;
    float abs_diff = fabsf(diff);
    
    // 使用绝对压力差（hPa）判断，而非百分比
    // 原因：对于水浸检测，10cm水深≈10hPa，相对于1010hPa大气压只有1%
    //       使用百分比会导致阈值过高（20%≈200cm水深）
    bool large_change = (abs_diff > KF_LARGE_CHANGE_THRESHOLD);
    
    // 如果差异超过阈值（默认2 hPa≈2cm水深），采取快速响应策略
    if (large_change) {
        APP_LOG_WARNING("WF5803F: Large pressure change detected - diff=%.2f hPa (threshold=%.1f hPa), fast tracking enabled", 
                       diff, KF_LARGE_CHANGE_THRESHOLD);
        
        // 策略1：直接使用测量值（而不是限制到20%）
        // 这样可以确保第一次检测到水浸时立即响应
        kf->x = measurement;
        
        // 策略2：重置P值以加快后续收敛
        kf->P = KF_INITIAL_ESTIMATE_ERROR;
        
        // 重置快速收敛计数器，以便后续测量也使用快速响应
        kf->update_count = 0;
        
        APP_LOG_INFO("WF5803F: Filter reset to measurement value - measurement=%.2f hPa", measurement);
    } else {
        // 正常卡尔曼滤波更新
        // x = x_pred + K * (z - x_pred)
        kf->x = kf->x + kf->K * diff;
        
        // P = (1 - K) * P_pred
        kf->P = (1.0f - kf->K) * P_pred;
        
        // 调试输出：显示当前滤波状态
        if (kf->update_count <= KF_FAST_CONVERGENCE_COUNT + 1) {
            APP_LOG_INFO("WF5803F: Kalman update #%d - meas=%.2f, filtered=%.2f, K=%.3f, diff=%.2f hPa",
                        kf->update_count, measurement, kf->x, kf->K, diff);
        }
    }
    
    return kf->x;
}

/**
 *****************************************************************************************
 * @brief Compensate raw data to physical values (OFFICIAL ALGORITHM).
 * 
 * This function implements the OFFICIAL WF5803F conversion formulas
 * from manufacturer's reference driver code.
 * 
 * Algorithm source: wfsensor.c::calculatePress()
 * 
 * Data format (5 bytes from register 0x06):
 * - QT[0:2]: 24-bit signed pressure ADC value
 * - QT[3:4]: 16-bit temperature ADC value
 * 
 * Conversion formulas:
 * - Pressure: Press_Data = fDat * 125 + 17.5 (kPa)
 * - Temperature: Temp_Data = -1.2 + QT[3] + QT[4] * 0.004 (C)
 * 
 * @param[in]  QT: 5-byte raw data buffer
 * @param[out] pressure: Compensated pressure in hPa
 * @param[out] temperature: Compensated temperature in C
 *****************************************************************************************
 */
static void wf5803f_compensate_data(const uint8_t *QT, float *pressure, float *temperature)
{
    // 官方压力计算公式（来自wfsensor.c）
    int32_t dat;
    float fDat;
    
    // 组合24位有符号压力值
    dat = QT[0];
    dat <<= 8;
    dat |= QT[1];
    dat <<= 8;
    dat |= QT[2];
    
    // 转换为24位有符号数（2's complement）
    if (dat >= 8388608) {  // 2^23
        fDat = (dat - 16777216) / 8388608.0f;  // 2^24 / 2^23
    } else {
        fDat = dat / 8388608.0f;
    }
    
    // 计算压力（kPa）并转换为hPa（1 kPa = 10 hPa）
    float Press_kPa = fDat * 125.0f + 17.5f;
    *pressure = Press_kPa * 10.0f;  // kPa -> hPa
    
    // 官方温度计算公式（来自wfsensor.c）
    *temperature = -1.2f + (float)QT[3] + (float)QT[4] * 0.004f;
    
    // 处理负温度（QT[3]的符号扩展）
    if (QT[3] >= 0x80) {
        *temperature -= 256.0f;
    }
}

/*
 * PUBLIC FUNCTION IMPLEMENTATIONS
 *****************************************************************************************
 */

bool wf5803f_init(void)
{
    if (s_initialized) {
        return true;
    }
    
    // 初始化软件I2C
    soft_i2c_init();
    delay_ms(50);  // 等待传感器启动
    
    // 验证I2C通信（读取状态寄存器）
    uint8_t status;
    if (!soft_i2c_read_reg(WF5803F_ADDR, WF5803F_REG_STATUS, &status, 1)) {
        APP_LOG_ERROR("WF5803F: I2C communication failed");
        return false;  // I2C通信失败
    }
    
    s_initialized = true;
    memset(&s_latest_data, 0, sizeof(wf5803f_data_t));
    
    APP_LOG_INFO("WF5803F sensor initialized successfully");
    return true;
}

bool wf5803f_deinit(void)
{
    if (!s_initialized) {
        return true;
    }
    
    // 反初始化I2C以节省功耗
    soft_i2c_deinit();
    
    s_initialized = false;
    APP_LOG_DEBUG("WF5803F sensor deinitialized for low-power mode");
    return true;
}

/**
 *****************************************************************************************
 * @brief Trigger group conversion (Temperature + Pressure).
 * 
 * Based on official driver: WFSensor_indicateGroupConvert()
 *****************************************************************************************
 */
static bool wf5803f_trigger_conversion(void)
{
    // 官方驱动：WFSensor_WriteByte(0x30, 0x0A)
    if (!soft_i2c_write_reg(WF5803F_ADDR, WF5803F_REG_CMD, WF5803F_CMD_CONVERT)) {
        APP_LOG_ERROR("WF5803F: Failed to trigger conversion");
        return false;
    }
    delay_ms(5);  // 官方驱动延时5ms
    return true;
}

/**
 *****************************************************************************************
 * @brief Wait for measurement to complete.
 * 
 * Based on official driver: WFSensor_WaitFinish()
 * 
 * @return 0x01 if ready, 0x00 if not ready, 0xFF on error
 *****************************************************************************************
 */
static uint8_t wf5803f_wait_finish(void)
{
    uint8_t status = 0;
    
    // 官方驱动：读取寄存器0x02的状态
    if (!soft_i2c_read_reg(WF5803F_ADDR, WF5803F_REG_STATUS, &status, 1)) {
        APP_LOG_ERROR("WF5803F: Failed to read status");
        return 0xFF;
    }
    
    return status;  // 0x01表示转换完成
}

/**
 *****************************************************************************************
 * @brief Read 5-byte raw data from sensor.
 * 
 * Based on official driver: WFSensor_getTPData()
 * 
 * @param[out] QT: 5-byte buffer (QT[0:2]=Pressure, QT[3:4]=Temperature)
 *****************************************************************************************
 */
static bool wf5803f_read_tp_data(uint8_t *QT)
{
    // 官方驱动：WFSensor_ReadContiune(0x06, QT, 5)
    if (!soft_i2c_read_reg(WF5803F_ADDR, WF5803F_REG_DATA, QT, 5)) {
        APP_LOG_ERROR("WF5803F: Failed to read T/P data");
        return false;
    }
    
    return true;
}

bool wf5803f_read_data(wf5803f_data_t *data)
{
    if (!s_initialized || !data) {
        APP_LOG_ERROR("WF5803F: Not initialized or invalid data pointer");
        return false;
    }
    
    // 官方驱动流程：
    // 1. WFSensor_indicateGroupConvert() - 触发转换
    // 2. WFSensor_WaitFinish() - 等待完成
    // 3. WFSensor_getTPData() - 读取数据
    // 4. calculatePress() - 计算压力和温度
    
    // Step 1: 触发组合转换（温度+压力）
    if (!wf5803f_trigger_conversion()) {
        APP_LOG_ERROR("WF5803F: Failed to trigger conversion");
        return false;
    }
    
    // Step 2: 等待转换完成（超时保护）
    uint8_t status;
    uint32_t timeout = 100;  // 最多等待100次，每次2ms
    while (timeout--) {
        status = wf5803f_wait_finish();
        if (status == 0x01) {
            break;  // 转换完成
        }
        if (status == 0xFF) {
            APP_LOG_ERROR("WF5803F: Failed to read status");
            return false;
        }
        delay_ms(2);  // 官方驱动使用2ms间隔
    }
    
    if (timeout == 0) {
        APP_LOG_ERROR("WF5803F: Conversion timeout");
        return false;
    }
    
    // Step 3: 读取5字节原始数据
    uint8_t QT[5] = {0};
    if (!wf5803f_read_tp_data(QT)) {
        APP_LOG_ERROR("WF5803F: Failed to read T/P data");
        return false;
    }
    
    // 保存原始数据用于调试
    data->raw_pressure = ((uint32_t)QT[0] << 16) | ((uint32_t)QT[1] << 8) | QT[2];
    data->raw_temperature = ((uint16_t)QT[3] << 8) | QT[4];
    
    // Step 4: 检查ADC原始值是否饱和（溢出检测）
    if (data->raw_pressure == WF5803F_ADC_POSITIVE_SAT || 
        data->raw_pressure == WF5803F_ADC_NEGATIVE_SAT) {
        APP_LOG_WARNING("WF5803F: ADC saturation detected");
        // ADC饱和，继续计算但数据可疑
    }
    
    // Step 5: 计算压力和温度（使用官方算法）
    float raw_pressure_hpa, raw_temp_c;
    wf5803f_compensate_data(QT, &raw_pressure_hpa, &raw_temp_c);
    
    // 保存原始测量值
    data->pressure_hpa = raw_pressure_hpa;
    data->temperature_c = raw_temp_c;
    
    // Step 5.5: 应用卡尔曼滤波（如果启用）
    if (s_kalman_enabled) {
        data->pressure_filtered = kalman_filter_update(&s_kf_pressure, raw_pressure_hpa);
    } else {
        data->pressure_filtered = raw_pressure_hpa;
    }
    
    // 计算压力变化率（用于水浸检测）
    if (s_prev_pressure != 0.0f) {
        s_pressure_change_rate = data->pressure_filtered - s_prev_pressure;
    }
    s_prev_pressure = data->pressure_filtered;
    
    // Step 6: 数据有效性检查
    // 正常大气压范围：300-1100 hPa（覆盖海平面到珠峰）
    // 扩展范围：250-1500 hPa（支持特殊应用场景）
    if (data->pressure_hpa < WF5803F_PRESSURE_MIN_HPA || 
        data->pressure_hpa > WF5803F_PRESSURE_MAX_HPA) {
        APP_LOG_WARNING("WF5803F: Pressure out of range: %.2f hPa", data->pressure_hpa);
        data->data_valid = false;
        return false;
    }
    
    // 温度有效性检查（WF5803F工作范围：-40°C ~ 85°C）
    if (data->temperature_c < WF5803F_TEMP_MIN_C || 
        data->temperature_c > WF5803F_TEMP_MAX_C) {
        APP_LOG_WARNING("WF5803F: Temperature out of range: %.1f C", data->temperature_c);
        data->data_valid = false;
        return false;
    }
    
    // 计算海拔高度（使用滤波后的压力值）
    data->altitude_m = wf5803f_calculate_altitude(data->pressure_filtered, 1013.25f);
    
    data->data_valid = true;
    data->timestamp = 0;  // 可以添加时间戳
    
    // 更新全局缓存
    memcpy(&s_latest_data, data, sizeof(wf5803f_data_t));
    
    return true;
}

wf5803f_data_t* wf5803f_get_latest(void)
{
    return &s_latest_data;
}

float wf5803f_calculate_altitude(float pressure_hpa, float sea_level_hpa)
{
    // 国际标准大气压公式
    return 44330.0f * (1.0f - powf(pressure_hpa / sea_level_hpa, 0.1903f));
}

void wf5803f_set_kalman_filter(bool enable)
{
    s_kalman_enabled = enable;
    
    // 如果禁用滤波器，重置滤波器状态
    if (!enable) {
        memset(&s_kf_pressure, 0, sizeof(kalman_filter_t));
    }
}

void wf5803f_reset_kalman_filter(void)
{
    memset(&s_kf_pressure, 0, sizeof(kalman_filter_t));
    s_prev_pressure = 0.0f;
    s_pressure_change_rate = 0.0f;
}

float wf5803f_get_pressure_change_rate(void)
{
    return s_pressure_change_rate;
}

/**
 *****************************************************************************************
 * @brief Read multiple samples and return average (high-precision mode).
 *****************************************************************************************
 */
bool wf5803f_read_multi_samples(uint8_t samples, wf5803f_data_t *data)
{
    if (!s_initialized || !data || samples == 0 || samples > 20) {
        APP_LOG_ERROR("WF5803F: Invalid parameters for multi-sample read");
        return false;
    }
    
    // 存储所有测量值用于统计处理
    float pressure_samples[20];
    float temp_samples[20];
    float altitude_samples[20];
    uint8_t valid_count = 0;
    
    APP_LOG_INFO("WF5803F: Reading %d samples for high-precision averaging...", samples);
    
    // 1. 采集所有样本
    for (uint8_t i = 0; i < samples; i++) {
        wf5803f_data_t single_read;
        
        if (wf5803f_read_data(&single_read) && single_read.data_valid) {
            // 使用原始测量值（非滤波值）进行平均，避免滤波器延迟
            pressure_samples[valid_count] = single_read.pressure_hpa;
            temp_samples[valid_count] = single_read.temperature_c;
            altitude_samples[valid_count] = single_read.altitude_m;
            valid_count++;
            
            APP_LOG_DEBUG("WF5803F: Sample %d/%d: P=%.2f hPa", i+1, samples, single_read.pressure_hpa);
        } else {
            APP_LOG_WARNING("WF5803F: Sample %d/%d failed", i+1, samples);
        }
        
        // 两次采样间隔10ms
        if (i < samples - 1) {
            delay_ms(10);
        }
    }
    
    if (valid_count == 0) {
        APP_LOG_ERROR("WF5803F: All samples failed");
        return false;
    }
    
    // 2. 异常值剔除：如果样本数>=5，去掉最大和最小值
    float pressure_sum = 0.0f;
    float temp_sum = 0.0f;
    float altitude_sum = 0.0f;
    uint8_t used_count = valid_count;
    
    if (valid_count >= 5) {
        // 找出压力的最大最小值索引
        uint8_t min_idx = 0, max_idx = 0;
        for (uint8_t i = 1; i < valid_count; i++) {
            if (pressure_samples[i] < pressure_samples[min_idx]) min_idx = i;
            if (pressure_samples[i] > pressure_samples[max_idx]) max_idx = i;
        }
        
        // 计算总和（跳过最大最小值）
        for (uint8_t i = 0; i < valid_count; i++) {
            if (i != min_idx && i != max_idx) {
                pressure_sum += pressure_samples[i];
                temp_sum += temp_samples[i];
                altitude_sum += altitude_samples[i];
            }
        }
        used_count = valid_count - 2;  // 去掉2个异常值
        
        APP_LOG_DEBUG("WF5803F: Outlier removal - discarded P_min=%.2f, P_max=%.2f", 
                     pressure_samples[min_idx], pressure_samples[max_idx]);
    } else {
        // 样本数<5，直接平均
        for (uint8_t i = 0; i < valid_count; i++) {
            pressure_sum += pressure_samples[i];
            temp_sum += temp_samples[i];
            altitude_sum += altitude_samples[i];
        }
    }
    
    // 3. 计算平均值
    data->pressure_hpa = pressure_sum / used_count;
    data->temperature_c = temp_sum / used_count;
    data->altitude_m = altitude_sum / used_count;
    
    // 应用卡尔曼滤波到平均压力值
    if (s_kalman_enabled) {
        data->pressure_filtered = kalman_filter_update(&s_kf_pressure, data->pressure_hpa);
    } else {
        data->pressure_filtered = data->pressure_hpa;
    }
    
    data->data_valid = true;
    
    APP_LOG_INFO("WF5803F: Multi-sample result (%d valid): P_avg=%.2f hPa, P_filtered=%.2f hPa, T=%.1f C",
                 valid_count, data->pressure_hpa, data->pressure_filtered, data->temperature_c);
    
    // 更新全局缓存
    memcpy(&s_latest_data, data, sizeof(wf5803f_data_t));
    
    return true;
}

/**
 *****************************************************************************************
 * @brief Set baseline pressure for flood detection.
 *****************************************************************************************
 */
bool wf5803f_set_baseline_pressure(float baseline_hpa)
{
    // 如果传入0，使用缓存的读数作为基准（不再要求传感器初始化）
    if (baseline_hpa == 0.0f) {
        // ✅ 修复：优先使用缓存数据，因为传感器可能已经deinit
        if (s_latest_data.data_valid && s_latest_data.pressure_filtered > 0.0f) {
            s_baseline_pressure = s_latest_data.pressure_filtered;
            s_baseline_set = true;
            APP_LOG_INFO("WF5803F: Baseline pressure set from cached data: %.2f hPa", s_baseline_pressure);
            return true;
        }
        
        // 如果缓存无效且传感器已初始化，尝试读取
        if (s_initialized) {
            wf5803f_data_t current_data;
            if (wf5803f_read_data(&current_data) && current_data.data_valid) {
                s_baseline_pressure = current_data.pressure_filtered;
                s_baseline_set = true;
                APP_LOG_INFO("WF5803F: Baseline pressure set to current reading: %.2f hPa", s_baseline_pressure);
                return true;
            }
        }
        
        APP_LOG_ERROR("WF5803F: No valid data for baseline (cached or fresh)");
        return false;
    }
    
    // 验证基准压力是否合理
    if (baseline_hpa < WF5803F_PRESSURE_MIN_HPA || baseline_hpa > WF5803F_PRESSURE_MAX_HPA) {
        APP_LOG_ERROR("WF5803F: Invalid baseline pressure: %.2f hPa", baseline_hpa);
        return false;
    }
    
    s_baseline_pressure = baseline_hpa;
    s_baseline_set = true;
    
    APP_LOG_INFO("WF5803F: Baseline pressure set to: %.2f hPa", s_baseline_pressure);
    return true;
}

/**
 *****************************************************************************************
 * @brief Get baseline pressure.
 *****************************************************************************************
 */
float wf5803f_get_baseline_pressure(void)
{
    if (!s_baseline_set) {
        APP_LOG_WARNING("WF5803F: Baseline pressure not set, returning 0");
        return 0.0f;
    }
    
    return s_baseline_pressure;
}

/**
 *****************************************************************************************
 * @brief Detect flood condition based on pressure change.
 *****************************************************************************************
 */
bool wf5803f_detect_flood(float threshold_hpa)
{
    // ✅ 修复：不再检查s_initialized，因为水浸检测只使用缓存的s_latest_data
    // 传感器可能已经deinit（省电），但缓存数据仍然有效
    if (!s_latest_data.data_valid) {
        APP_LOG_WARNING("WF5803F: No valid cached data for flood detection");
        return false;
    }
    
    if (!s_baseline_set) {
        APP_LOG_WARNING("WF5803F: Baseline not set (%.2f hPa), attempting to set from current reading...", s_baseline_pressure);
        if (wf5803f_set_baseline_pressure(0.0f)) {  // 使用当前值作为基准
            APP_LOG_INFO("WF5803F: Baseline set successfully (%.2f hPa), will detect on next reading", s_baseline_pressure);
        } else {
            APP_LOG_ERROR("WF5803F: Failed to set baseline, flood detection disabled");
        }
        return false;  // 本次返回false，但下次如果设置成功则可检测
    }
    
    // 使用最新的滤波后压力值
    float current_pressure = s_latest_data.pressure_filtered;
    float pressure_delta = current_pressure - s_baseline_pressure;
    
    // 水浸检测：压力显著上升（水深1m约增加100 hPa）
    // threshold_hpa 通常设置为 5-20 hPa（对应 5-20 cm 水深）
    bool flood_detected = (pressure_delta > threshold_hpa);
    
    // 详细诊断日志
    APP_LOG_DEBUG("WF5803F: Flood check - baseline=%.2f hPa, current=%.2f hPa, delta=%.2f hPa, threshold=%.2f hPa, result=%s",
                  s_baseline_pressure, current_pressure, pressure_delta, threshold_hpa,
                  flood_detected ? "FLOOD" : "OK");
    
    if (flood_detected) {
        float estimated_water_depth_cm = pressure_delta / 0.98f;  // 1 hPa = 1.02 cm 水深
        APP_LOG_WARNING("WF5803F: FLOOD DETECTED! Pressure increase: %.2f hPa (~ %.1f cm water depth)", 
                       pressure_delta, estimated_water_depth_cm);
        APP_LOG_INFO("WF5803F: Baseline: %.2f hPa, Current: %.2f hPa, Threshold: %.2f hPa",
                     s_baseline_pressure, current_pressure, threshold_hpa);
    }
    
    return flood_detected;
}
