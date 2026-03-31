/**
 *****************************************************************************************
 * @file smart_baseline_calibration.h
 * 
 * @brief 智能基准压力自动标定策略
 *        解决大气压波动和水浸状态下的标定冲突问�?
 * 
 * @details 核心问题�?
 *          1. 大气压自然波动导致传感器精度下降（天气变化：±10hPa�?
 *          2. 不能在水浸状态下标定基准（会误判水浸为正常）
 *          3. 需要智能判断最佳标定时�?
 * 
 * @solution 多层智能判断策略�?
 *          - 环境稳定性检测（压力波动、温度稳定）
 *          - 水浸状态排除（多重验证�?
 *          - 时间窗口控制（深�?/设备空闲期）
 *          - 历史数据对比（异常检测）
 * 
 * @author  Your Name
 * @date    2026-01-07
 *****************************************************************************************
 */

#ifndef __SMART_BASELINE_CALIBRATION_H
#define __SMART_BASELINE_CALIBRATION_H

#include <stdint.h>
#include <stdbool.h>

/*
 * 配置参数
 *****************************************************************************************
 */

// 标定时间策略
#define CALIBRATION_CHECK_INTERVAL_MS     3600000    // 检查间隔：1小时
#define CALIBRATION_MIN_INTERVAL_MS       10800000   // 最小标定间隔：3小时（防止频繁标定）
#define CALIBRATION_MAX_INTERVAL_MS       604800000  // 最大标定间隔：7天（必须标定�?

// 基准压力阈值（用于判断是否标定�?
#define BASELINE_DRIFT_THRESHOLD_HPA      1.0f       // 基准漂移阈值：1hPa（超过此值需要标定）
#define BASELINE_ABNORMAL_DELTA_HPA       10.0f      // 异常压力变化�?10hPa（可能是水浸�?

// 环境稳定性判断阈�?
#define STABILITY_PRESSURE_VARIANCE_HPA   5.0f       // 压力稳定性阈值：5hPa（越小越稳定�?
#define STABILITY_TEMP_VARIANCE_C         999.0f    // 温度稳定性阈值：999℃（禁用温度检查）
#define STABILITY_CHECK_WINDOW            10         // 稳定性检查窗口：10次采�?
#define STABILITY_REQUIRED_SAMPLES        8          // 需要至�?8次稳定采�?

// 水浸排除策略
#define FLOOD_DETECTION_DELTA_HPA         5.0f       // 水浸检测阈值：5hPa（相对基准）
#define FLOOD_CONTINUOUS_COUNT            3          // 连续检测次数：3次确认才认为水浸
#define FLOOD_SAFE_DELTA_HPA              5.0f       // 安全裕度�?5hPa（低于此值认为安全）

// 标定时间窗口�?24小时制）
#define CALIBRATION_WINDOW_START_HOUR     0          // 标定窗口开始时间：0点（全天候）
#define CALIBRATION_WINDOW_END_HOUR       24         // 标定窗口结束时间�?23点（全天候）

/*
 * 标定状态枚�?
 *****************************************************************************************
 */
typedef enum {
    CALIBRATION_STATE_IDLE = 0,          // 空闲状�?
    CALIBRATION_STATE_CHECKING,          // 正在检查条�?
    CALIBRATION_STATE_COLLECTING_DATA,   // 正在收集稳定数据
    CALIBRATION_STATE_VALIDATING,        // 正在验证数据有效�?
    CALIBRATION_STATE_EXECUTING,         // 正在执行标定
    CALIBRATION_STATE_SUCCESS,           // 标定成功
    CALIBRATION_STATE_FAILED             // 标定失败
} calibration_state_t;

/*
 * 标定失败原因枚举
 *****************************************************************************************
 */
typedef enum {
    CALIBRATION_FAIL_NONE = 0,           // 无失�?
    CALIBRATION_FAIL_FLOOD_DETECTED,     // 检测到水浸
    CALIBRATION_FAIL_UNSTABLE_ENV,       // 环境不稳�?
    CALIBRATION_FAIL_TIME_WINDOW,        // 不在时间窗口�?
    CALIBRATION_FAIL_TOO_SOON,           // 距离上次标定太近
    CALIBRATION_FAIL_ABNORMAL_DELTA,     // 压力变化异常
    CALIBRATION_FAIL_SENSOR_ERROR        // 传感器读取错�?
} calibration_fail_reason_t;

/*
 * 采样数据缓冲区（用于稳定性判断）
 *****************************************************************************************
 */
typedef struct {
    float pressure_samples[STABILITY_CHECK_WINDOW];  // 压力采样
    float temp_samples[STABILITY_CHECK_WINDOW];      // 温度采样
    uint32_t timestamps[STABILITY_CHECK_WINDOW];     // 时间�?
    uint8_t count;                                   // 当前采样数量
    uint8_t index;                                   // 循环索引
} stability_buffer_t;

/*
 * 智能标定管理�?
 *****************************************************************************************
 */
typedef struct {
    // 状态信�?
    calibration_state_t state;               // 当前标定状�?
    calibration_fail_reason_t last_fail;     // 上次失败原因
    
    // 时间�?
    uint32_t last_calibration_time;          // 上次成功标定时间（毫秒）
    uint32_t last_check_time;                // 上次检查时�?
    uint32_t calibration_start_time;         // 本次标定开始时�?
    
    // 基准压力信息
    float current_baseline_hpa;              // 当前基准压力
    float new_baseline_candidate_hpa;        // 新基准候选�?
    float baseline_before_calibration;       // 标定前的基准值（用于回滚�?
    
    // 稳定性数�?
    stability_buffer_t stability_buffer;     // 稳定性采样缓冲区
    
    // 水浸检�?
    uint8_t flood_detection_count;           // 连续检测到高压的次�?
    uint8_t safe_detection_count;            // 连续检测到安全压力的次�?
    
    // 统计信息
    uint32_t total_calibrations;             // 总标定次�?
    uint32_t success_count;                  // 成功次数
    uint32_t fail_count;                     // 失败次数
    uint32_t flood_prevented_count;          // 阻止水浸标定次数
    
    // 配置参数
    bool enable_time_window;                 // 是否启用时间窗口控制
    bool enable_stability_check;             // 是否启用稳定性检�?
    bool enable_flood_prevention;            // 是否启用水浸排除
    bool force_calibration_flag;             // 强制标定标志（下次调度时执行�?
    
} smart_calibration_manager_t;

/*
 * 全局变量声明
 *****************************************************************************************
 */
extern smart_calibration_manager_t g_calibration_mgr;

/*
 * 初始化函�?
 *****************************************************************************************
 */

/**
 * @brief 初始化智能标定管理系�?
 * @param initial_baseline 初始基准压力（hPa�?
 */
void smart_calibration_init(float initial_baseline);

/*
 * 调度业务函数
 *****************************************************************************************
 */

/**
 * @brief 智能标定调度主函�?
 *        应该在循环定时器中调用，建议每小时调用一�?
 * 
 * @param current_time_ms 当前系统时间（毫秒）
 * @param current_rtc_hour 当前RTC小时�?0-23, 用于时间窗口判断
 * @return true: 执行了标�?, false: 未执行标�?
 */
bool smart_calibration_schedule(uint32_t current_time_ms, uint8_t current_rtc_hour);

/**
 * @brief 手动触发强制标定
 *        适用于设备重新安装或维护校准
 * 
 * @param skip_safety_checks 是否跳过安全检查（危险，慎用）
 * @return true: 标定成功, false: 标定失败
 */
bool smart_calibration_force_trigger(bool skip_safety_checks);

/**
 * @brief 添加采样数据，用�?
 *        环境稳定性判断应该在每次采集到数据后调用
 * 
 * @param pressure_hpa 当前气压值（hPa�?
 * @param temperature_c 当前温度（℃�?
 * @param timestamp_ms 时间戳（毫秒�?
 */
void smart_calibration_add_sample(float pressure_hpa, 
                                  float temperature_c, 
                                  uint32_t timestamp_ms);

/*
 * 条件判断函数
 *****************************************************************************************
 */

/**
 * @brief 判断是否需要标�?
 * @param current_time_ms 当前系统时间（毫秒）
 * @return true: 需要标�?, false: 不需�?
 */
bool smart_calibration_is_needed(uint32_t current_time_ms);

/**
 * @brief 判断是否在标定的最佳时间窗口内
 * @param rtc_hour 当前RTC小时�?0-23
 * @return true: 在窗口内, false: 不在窗口�?
 */
bool smart_calibration_is_in_time_window(uint8_t rtc_hour);

/**
 * @brief 判断环境是否稳定
 * @return true: 稳定, false: 不稳�?
 */
bool smart_calibration_is_environment_stable(void);

/**
 * @brief 判断是否可能处于水浸状�?
 * @param sensor_pressure_hpa 当前传感器气压值（hPa�?
 * @return true: 检测到水浸, false: 安全
 */
bool smart_calibration_detect_possible_flood(float sensor_pressure_hpa);

/**
 * @brief 验证新基准值是否合�?
 * @param new_baseline_hpa 新基准值（hPa�?
 * @return true: 合理, false: 不合�?
 */
bool smart_calibration_validate_baseline(float new_baseline_hpa);

/*
 * 执行函数
 *****************************************************************************************
 */

/**
 * @brief 执行基准压力标定
 *        通过调用WF5803F驱动的标定函数来实现实际标定
 * 
 * @return true: 标定成功, false: 标定失败
 */
bool smart_calibration_execute(void);

/**
 * @brief 回滚到标定前的基准�?
 *        当标定异常时用于回滚
 */
void smart_calibration_rollback(void);

/*
 * 查询和诊断函�?
 *****************************************************************************************
 */

/**
 * @brief 获取当前标定状�?
 * @return 标定状态枚�?
 */
calibration_state_t smart_calibration_get_state(void);

/**
 * @brief 获取上次失败原因
 * @return 失败原因枚举
 */
calibration_fail_reason_t smart_calibration_get_last_fail_reason(void);

/**
 * @brief 获取失败原因的字符串描述
 * @param reason 失败原因
 * @return 字符串描�?
 */
const char* smart_calibration_fail_reason_to_string(calibration_fail_reason_t reason);

/**
 * @brief 获取距离上次标定的时间（秒）
 * @param current_time_ms 当前时间（毫秒）
 * @return 时间差（秒）
 */
uint32_t smart_calibration_get_time_since_last(uint32_t current_time_ms);

/**
 * @brief 获取距离下次强制标定的时间（秒）
 * @param current_time_ms 当前时间（毫秒）
 * @return 剩余时间（秒），0表示已到�?
 */
uint32_t smart_calibration_get_time_to_next_force(uint32_t current_time_ms);

/**
 * @brief 打印标定统计信息
 */
void smart_calibration_print_statistics(void);

/**
 * @brief 打印标定管理系统状�?
 */
void smart_calibration_print_status(void);

/*
 * 配置函数
 *****************************************************************************************
 */

/**
 * @brief 启用/禁用时间窗口控制
 * @param true-启用, false-禁用
 */
void smart_calibration_set_time_window_enable(bool enable);

/**
 * @brief 启用/禁用稳定性检�?
 * @param true-启用, false-禁用
 */
void smart_calibration_set_stability_check_enable(bool enable);

/**
 * @brief 启用/禁用水浸排除
 * @param true-启用, false-禁用
 */
void smart_calibration_set_flood_prevention_enable(bool enable);

#endif // __SMART_BASELINE_CALIBRATION_H
