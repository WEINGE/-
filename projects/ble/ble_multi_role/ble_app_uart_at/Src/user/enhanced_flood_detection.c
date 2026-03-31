/**
 *****************************************************************************************
 * @file enhanced_flood_detection.c
 * 
 * @brief 增强型水浸检测模块 - 实现文件
 *****************************************************************************************
 */

#include "enhanced_flood_detection.h"
#include <string.h>
#include <math.h>

/*
 * 本地宏定义 - 禁用所有打印
 *****************************************************************************************
 */
#define FLOOD_LOG_INFO(...)    // 禁用
#define FLOOD_LOG_WARNING(...) // 禁用
#define FLOOD_LOG_DEBUG(...)   // 禁用
#define FLOOD_LOG_ERROR(...)   // 禁用

/*
 * 全局变量定义
 *****************************************************************************************
 */
enhanced_flood_detector_t g_flood_detector = {0};

/*
 * 本地函数声明
 *****************************************************************************************
 */
static float calculate_variance(float *data, uint8_t count);
static float calculate_average(float *data, uint8_t count);
static void update_confirmation_state(bool flood_suspected);

/*
 * 初始化函数实现
 *****************************************************************************************
 */
void enhanced_flood_detector_init(float baseline_pressure)
{
    memset(&g_flood_detector, 0, sizeof(enhanced_flood_detector_t));
    
    g_flood_detector.baseline_pressure = baseline_pressure;
    
    // 默认全部启用
    g_flood_detector.enable_rate_check = true;
    g_flood_detector.enable_temp_check = true;
    g_flood_detector.enable_stability_check = true;
    g_flood_detector.enable_continuous_confirm = true;
    
    // 已移除打印
}

void enhanced_flood_detector_reset(void)
{
    g_flood_detector.confirmation.flood_count = 0;
    g_flood_detector.confirmation.safe_count = 0;
    g_flood_detector.confirmation.flood_confirmed = false;
    
    // 已移除打印
}

void enhanced_flood_detector_set_baseline(float new_baseline)
{
    g_flood_detector.baseline_pressure = new_baseline;
    enhanced_flood_detector_reset();  // 重置确认状态
    
    // 已移除打印
}

/*
 * 数据采集函数实现
 *****************************************************************************************
 */
void enhanced_flood_detector_add_sample(float pressure_hpa, 
                                        float temperature_c, 
                                        uint32_t timestamp_ms)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    // 添加到循环缓冲区
    hist->samples[hist->write_index].pressure_hpa = pressure_hpa;
    hist->samples[hist->write_index].temperature_c = temperature_c;
    hist->samples[hist->write_index].timestamp_ms = timestamp_ms;
    hist->samples[hist->write_index].valid = true;
    
    hist->write_index = (hist->write_index + 1) % FLOOD_HISTORY_SIZE;
    
    if (hist->count < FLOOD_HISTORY_SIZE) {
        hist->count++;
    }
}

/*
 * 核心检测函数实现
 *****************************************************************************************
 */
bool enhanced_flood_detector_analyze(flood_analysis_result_t *result)
{
    // 检查样本数量
    if (g_flood_detector.history.count < FLOOD_ANALYSIS_WINDOW) {
        // 已移除打印
        return false;
    }
    
    memset(result, 0, sizeof(flood_analysis_result_t));
    
    // 1. 计算原始数据
    result->pressure_rate = enhanced_flood_calculate_pressure_rate();
    result->pressure_delta = enhanced_flood_calculate_pressure_delta();
    result->temp_delta = enhanced_flood_calculate_temp_delta();
    result->pressure_variance = enhanced_flood_calculate_pressure_variance();
    
    // 2. 计算各维度得分
    result->rate_score = enhanced_flood_score_rate(result->pressure_rate);
    result->amplitude_score = enhanced_flood_score_amplitude(result->pressure_delta);
    result->temp_corr_score = enhanced_flood_score_temp_correlation(result->temp_delta);
    result->stability_score = enhanced_flood_score_stability(result->pressure_variance);
    
    // 3. 计算总分（根据启用状态）
    result->total_score = 0;
    uint8_t enabled_factors = 0;
    
    if (g_flood_detector.enable_rate_check) {
        result->total_score += result->rate_score;
        enabled_factors++;
    }
    
    result->total_score += result->amplitude_score;  // 幅度检查始终启用
    enabled_factors++;
    
    if (g_flood_detector.enable_temp_check) {
        result->total_score += result->temp_corr_score;
        enabled_factors++;
    }
    
    if (g_flood_detector.enable_stability_check) {
        result->total_score += result->stability_score;
        enabled_factors++;
    }
    
    // 4. 判断是否怀疑水浸
    result->is_flood_suspected = (result->total_score >= FLOOD_SCORE_THRESHOLD);
    
    // 5. 特殊情况：快速大幅变化直接判定
    if (fabs(result->pressure_rate) > RATE_FAST_THRESHOLD && 
        result->pressure_delta > AMPLITUDE_MEDIUM_HPA) {
        result->is_flood_suspected = true;
        result->total_score = 4.0f;  // 满分
    }
    
    // 6. 计算置信度（0-100）
    if (result->is_flood_suspected) {
        float confidence_ratio = result->total_score / enabled_factors;
        result->confidence_level = (uint8_t)(confidence_ratio * 100.0f);
        if (result->confidence_level > 100) result->confidence_level = 100;
    } else {
        result->confidence_level = 0;
    }
    
    // 7. 更新统计
    g_flood_detector.total_detections++;
    if (result->is_flood_suspected) {
        g_flood_detector.flood_detections++;
    }
    
    // 8. 保存分析结果
    memcpy(&g_flood_detector.last_analysis, result, sizeof(flood_analysis_result_t));
    
    // 9. 更新确认状态
    if (g_flood_detector.enable_continuous_confirm) {
        update_confirmation_state(result->is_flood_suspected);
    } else {
        // 不启用连续确认时，直接使用分析结果
        g_flood_detector.confirmation.flood_confirmed = result->is_flood_suspected;
    }
    
    return true;
}

bool enhanced_flood_detector_is_flood_confirmed(void)
{
    return g_flood_detector.confirmation.flood_confirmed;
}

/*
 * 子功能函数实现
 *****************************************************************************************
 */
float enhanced_flood_calculate_pressure_rate(void)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count < 2) return 0.0f;
    
    // 获取最新和前一次的采样
    uint8_t latest_idx = (hist->write_index + FLOOD_HISTORY_SIZE - 1) % FLOOD_HISTORY_SIZE;
    uint8_t previous_idx = (hist->write_index + FLOOD_HISTORY_SIZE - 2) % FLOOD_HISTORY_SIZE;
    
    flood_sample_t *latest = &hist->samples[latest_idx];
    flood_sample_t *previous = &hist->samples[previous_idx];
    
    // 计算时间差（转换为分钟）
    float time_delta_min = (latest->timestamp_ms - previous->timestamp_ms) / 60000.0f;
    if (time_delta_min < 0.001f) return 0.0f;  // 避免除零
    
    // 计算变化速率（hPa/分钟）
    float pressure_delta = latest->pressure_hpa - previous->pressure_hpa;
    float rate = pressure_delta / time_delta_min;
    
    return rate;
}

float enhanced_flood_calculate_pressure_delta(void)
{
    flood_sample_t latest;
    if (!enhanced_flood_get_latest_sample(&latest)) {
        return 0.0f;
    }
    
    return latest.pressure_hpa - g_flood_detector.baseline_pressure;
}

float enhanced_flood_calculate_temp_delta(void)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count < FLOOD_ANALYSIS_WINDOW) return 0.0f;
    
    // 获取分析窗口内的首尾温度
    uint8_t oldest_idx = (hist->write_index + FLOOD_HISTORY_SIZE - hist->count) % FLOOD_HISTORY_SIZE;
    uint8_t latest_idx = (hist->write_index + FLOOD_HISTORY_SIZE - 1) % FLOOD_HISTORY_SIZE;
    
    float temp_start = hist->samples[oldest_idx].temperature_c;
    float temp_end = hist->samples[latest_idx].temperature_c;
    
    return fabs(temp_end - temp_start);
}

float enhanced_flood_calculate_pressure_variance(void)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count < FLOOD_ANALYSIS_WINDOW) return 0.0f;
    
    // 提取最近N次的压力数据
    float pressures[FLOOD_ANALYSIS_WINDOW];
    uint8_t start_idx = (hist->write_index + FLOOD_HISTORY_SIZE - FLOOD_ANALYSIS_WINDOW) % FLOOD_HISTORY_SIZE;
    
    for (uint8_t i = 0; i < FLOOD_ANALYSIS_WINDOW; i++) {
        uint8_t idx = (start_idx + i) % FLOOD_HISTORY_SIZE;
        pressures[i] = hist->samples[idx].pressure_hpa;
    }
    
    return calculate_variance(pressures, FLOOD_ANALYSIS_WINDOW);
}

/*
 * 评分函数实现
 *****************************************************************************************
 */
float enhanced_flood_score_rate(float rate)
{
    float abs_rate = fabs(rate);
    
    if (abs_rate >= RATE_FAST_THRESHOLD) {
        return 1.0f;  // 快速变化，强烈怀疑水浸
    } else if (abs_rate >= RATE_MODERATE_THRESHOLD) {
        // 线性插值：1.0 ~ 3.0 hPa/分钟 → 0.5 ~ 1.0 分
        float ratio = (abs_rate - RATE_MODERATE_THRESHOLD) / (RATE_FAST_THRESHOLD - RATE_MODERATE_THRESHOLD);
        return 0.5f + ratio * 0.5f;
    } else if (abs_rate >= RATE_SLOW_THRESHOLD) {
        // 线性插值：0.1 ~ 1.0 hPa/分钟 → 0.0 ~ 0.5 分
        float ratio = (abs_rate - RATE_SLOW_THRESHOLD) / (RATE_MODERATE_THRESHOLD - RATE_SLOW_THRESHOLD);
        return ratio * 0.5f;
    } else {
        return 0.0f;  // 非常缓慢，正常大气压变化
    }
}

float enhanced_flood_score_amplitude(float delta)
{
    // 只考虑正向变化（压力上升）
    if (delta < 0) return 0.0f;
    
    if (delta >= AMPLITUDE_LARGE_HPA) {
        return 1.0f;  // 大幅上升
    } else if (delta >= AMPLITUDE_MEDIUM_HPA) {
        // 线性插值：8 ~ 12 hPa → 0.7 ~ 1.0 分
        float ratio = (delta - AMPLITUDE_MEDIUM_HPA) / (AMPLITUDE_LARGE_HPA - AMPLITUDE_MEDIUM_HPA);
        return 0.7f + ratio * 0.3f;
    } else if (delta >= AMPLITUDE_SMALL_HPA) {
        // 线性插值：5 ~ 8 hPa → 0.3 ~ 0.7 分
        float ratio = (delta - AMPLITUDE_SMALL_HPA) / (AMPLITUDE_MEDIUM_HPA - AMPLITUDE_SMALL_HPA);
        return 0.3f + ratio * 0.4f;
    } else {
        // 线性插值：0 ~ 5 hPa → 0.0 ~ 0.3 分
        return (delta / AMPLITUDE_SMALL_HPA) * 0.3f;
    }
}

float enhanced_flood_score_temp_correlation(float temp_delta)
{
    // 温度变化越小，得分越高（逆向）
    if (temp_delta < TEMP_NO_CHANGE_C) {
        return 1.0f;  // 温度几乎不变，很像水浸
    } else if (temp_delta < TEMP_SMALL_CHANGE_C) {
        // 线性插值：0.3 ~ 1.0°C → 0.5 ~ 1.0 分
        float ratio = (temp_delta - TEMP_NO_CHANGE_C) / (TEMP_SMALL_CHANGE_C - TEMP_NO_CHANGE_C);
        return 1.0f - ratio * 0.5f;
    } else if (temp_delta < TEMP_LARGE_CHANGE_C) {
        // 线性插值：1.0 ~ 2.0°C → 0.0 ~ 0.5 分
        float ratio = (temp_delta - TEMP_SMALL_CHANGE_C) / (TEMP_LARGE_CHANGE_C - TEMP_SMALL_CHANGE_C);
        return 0.5f - ratio * 0.5f;
    } else {
        return 0.0f;  // 温度变化大，像天气系统
    }
}

float enhanced_flood_score_stability(float variance)
{
    // 方差越小（越稳定），得分越高
    if (variance < STABILITY_VERY_STABLE) {
        return 1.0f;  // 非常稳定，像水浸
    } else if (variance < STABILITY_STABLE) {
        // 线性插值：0.1 ~ 0.5 → 0.5 ~ 1.0 分
        float ratio = (variance - STABILITY_VERY_STABLE) / (STABILITY_STABLE - STABILITY_VERY_STABLE);
        return 1.0f - ratio * 0.5f;
    } else if (variance < STABILITY_UNSTABLE) {
        // 线性插值：0.5 ~ 1.0 → 0.0 ~ 0.5 分
        float ratio = (variance - STABILITY_STABLE) / (STABILITY_UNSTABLE - STABILITY_STABLE);
        return 0.5f - ratio * 0.5f;
    } else {
        return 0.0f;  // 不稳定，像大气压波动
    }
}

/*
 * 辅助函数实现
 *****************************************************************************************
 */
bool enhanced_flood_get_sample(uint8_t index, flood_sample_t *sample)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (index >= hist->count) return false;
    
    uint8_t actual_idx = (hist->write_index + FLOOD_HISTORY_SIZE - hist->count + index) % FLOOD_HISTORY_SIZE;
    memcpy(sample, &hist->samples[actual_idx], sizeof(flood_sample_t));
    
    return true;
}

bool enhanced_flood_get_latest_sample(flood_sample_t *sample)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count == 0) return false;
    
    uint8_t latest_idx = (hist->write_index + FLOOD_HISTORY_SIZE - 1) % FLOOD_HISTORY_SIZE;
    memcpy(sample, &hist->samples[latest_idx], sizeof(flood_sample_t));
    
    return true;
}

float enhanced_flood_get_avg_pressure(void)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count < FLOOD_ANALYSIS_WINDOW) return 0.0f;
    
    float pressures[FLOOD_ANALYSIS_WINDOW];
    uint8_t start_idx = (hist->write_index + FLOOD_HISTORY_SIZE - FLOOD_ANALYSIS_WINDOW) % FLOOD_HISTORY_SIZE;
    
    for (uint8_t i = 0; i < FLOOD_ANALYSIS_WINDOW; i++) {
        uint8_t idx = (start_idx + i) % FLOOD_HISTORY_SIZE;
        pressures[i] = hist->samples[idx].pressure_hpa;
    }
    
    return calculate_average(pressures, FLOOD_ANALYSIS_WINDOW);
}

float enhanced_flood_get_avg_temperature(void)
{
    flood_history_t *hist = &g_flood_detector.history;
    
    if (hist->count < FLOOD_ANALYSIS_WINDOW) return 0.0f;
    
    float temps[FLOOD_ANALYSIS_WINDOW];
    uint8_t start_idx = (hist->write_index + FLOOD_HISTORY_SIZE - FLOOD_ANALYSIS_WINDOW) % FLOOD_HISTORY_SIZE;
    
    for (uint8_t i = 0; i < FLOOD_ANALYSIS_WINDOW; i++) {
        uint8_t idx = (start_idx + i) % FLOOD_HISTORY_SIZE;
        temps[i] = hist->samples[idx].temperature_c;
    }
    
    return calculate_average(temps, FLOOD_ANALYSIS_WINDOW);
}

/*
 * 诊断和调试函数实现
 *****************************************************************************************
 */
void enhanced_flood_print_analysis(void)
{
    // 打印已禁用
}

void enhanced_flood_print_status(void)
{
    // 打印已禁用
}

void enhanced_flood_print_statistics(void)
{
    // 打印已禁用
}

const char* enhanced_flood_confidence_to_string(uint8_t confidence)
{
    if (confidence >= 90) return "Very High";
    if (confidence >= 75) return "High";
    if (confidence >= 60) return "Medium";
    if (confidence >= 40) return "Low";
    return "Very Low";
}

/*
 * 配置函数实现
 *****************************************************************************************
 */
void enhanced_flood_set_rate_check(bool enable)
{
    g_flood_detector.enable_rate_check = enable;
    // 已移除打印
}

void enhanced_flood_set_temp_check(bool enable)
{
    g_flood_detector.enable_temp_check = enable;
    // 已移除打印
}

void enhanced_flood_set_stability_check(bool enable)
{
    g_flood_detector.enable_stability_check = enable;
    // 已移除打印
}

void enhanced_flood_set_continuous_confirm(bool enable)
{
    g_flood_detector.enable_continuous_confirm = enable;
    // 已移除打印
}

void enhanced_flood_report_false_alarm(void)
{
    g_flood_detector.false_alarms++;
    // 已移除打印
}

/*
 * 本地辅助函数实现
 *****************************************************************************************
 */
static float calculate_variance(float *data, uint8_t count)
{
    if (count == 0) return 0.0f;
    
    float mean = calculate_average(data, count);
    
    float variance = 0.0f;
    for (uint8_t i = 0; i < count; i++) {
        float diff = data[i] - mean;
        variance += diff * diff;
    }
    variance /= count;
    
    return variance;
}

static float calculate_average(float *data, uint8_t count)
{
    if (count == 0) return 0.0f;
    
    float sum = 0.0f;
    for (uint8_t i = 0; i < count; i++) {
        sum += data[i];
    }
    
    return sum / count;
}

static void update_confirmation_state(bool flood_suspected)
{
    flood_confirmation_t *conf = &g_flood_detector.confirmation;
    
    if (flood_suspected) {
        conf->flood_count++;
        conf->safe_count = 0;
        
        if (conf->flood_count >= FLOOD_CONTINUOUS_CONFIRM) {
            if (!conf->flood_confirmed) {
                // 已移除打印
            }
            conf->flood_confirmed = true;
            conf->confirm_time = g_flood_detector.history.samples[
                (g_flood_detector.history.write_index + FLOOD_HISTORY_SIZE - 1) % FLOOD_HISTORY_SIZE
            ].timestamp_ms;
        }
    } else {
        conf->safe_count++;
        conf->flood_count = 0;
        
        if (conf->safe_count >= FLOOD_SAFE_CONFIRM) {
            if (conf->flood_confirmed) {
                // 已移除打印
            }
            conf->flood_confirmed = false;
        }
    }
}
