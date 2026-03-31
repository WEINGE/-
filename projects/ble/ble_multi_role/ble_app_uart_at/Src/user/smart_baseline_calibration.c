/**
 *****************************************************************************************
 * @file smart_baseline_calibration.c
 * 
 * @brief ���ܻ�׼ѹ���Զ��궨���� - ʵ���ļ�
 *****************************************************************************************
 */

#include "smart_baseline_calibration.h"
#include "wf5803f_driver.h"
#include "app_log.h"
#include <string.h>
#include <math.h>

/*
 * ���غ궨��
 *****************************************************************************************
 */
#define CALIB_TAG "[SmartCalib]"  ///< ��־��ǩ

/*
 * ȫ�ֱ�������
 *****************************************************************************************
 */
smart_calibration_manager_t g_calibration_mgr = {
    .state = CALIBRATION_STATE_IDLE
};

/*
 * ���غ�������
 *****************************************************************************************
 */
static float calculate_variance_local(float *data, uint8_t count);
static float calculate_average_local(float *data, uint8_t count);
static void reset_stability_buffer(void);
static void update_flood_detection_counter(bool flood_suspected);

/*
 * ��ʼ������ʵ��
 *****************************************************************************************
 */
void smart_calibration_init(float initial_baseline)
{
    memset(&g_calibration_mgr, 0, sizeof(smart_calibration_manager_t));
    
    g_calibration_mgr.state = CALIBRATION_STATE_IDLE;
    g_calibration_mgr.current_baseline_hpa = initial_baseline;
    g_calibration_mgr.new_baseline_candidate_hpa = initial_baseline;
    g_calibration_mgr.baseline_before_calibration = initial_baseline;
    
    // Ĭ�����ã�ȫ������
    g_calibration_mgr.enable_time_window = true;
    g_calibration_mgr.enable_stability_check = true;
    g_calibration_mgr.enable_flood_prevention = true;
    
    reset_stability_buffer();
    
    APP_LOG_INFO("%s Initialized with baseline %.2f hPa", CALIB_TAG, initial_baseline);
}

/*
 * ���ĵ��Ⱥ���ʵ��
 *****************************************************************************************
 */
bool smart_calibration_schedule(uint32_t current_time_ms, uint8_t current_rtc_hour)
{
    // 1. ����Ƿ��˼��ʱ��
    if ((current_time_ms - g_calibration_mgr.last_check_time) < CALIBRATION_CHECK_INTERVAL_MS) {
        return false;  // ��û�����ʱ��
    }
    
    g_calibration_mgr.last_check_time = current_time_ms;
    
    // 2. ����Ƿ���ǿ�Ʊ궨��־
    bool force_calibration = g_calibration_mgr.force_calibration_flag;
    if (force_calibration) {
        APP_LOG_INFO("%s Force calibration flag detected", CALIB_TAG);
        g_calibration_mgr.force_calibration_flag = false;  // �����־
    }
    
    // 3. ����Ƿ���Ҫ�궨
    if (!force_calibration && !smart_calibration_is_needed(current_time_ms)) {
        return false;
    }
    
    // 4. ���ʱ�䴰��
    if (g_calibration_mgr.enable_time_window && !force_calibration) {
        if (!smart_calibration_is_in_time_window(current_rtc_hour)) {
            APP_LOG_DEBUG("%s Not in calibration time window (current: %d:00)", 
                         CALIB_TAG, current_rtc_hour);
            g_calibration_mgr.last_fail = CALIBRATION_FAIL_TIME_WINDOW;
            return false;
        }
    }
    
    // 5. ��黷���ȶ���
    if (g_calibration_mgr.enable_stability_check && !force_calibration) {
        if (!smart_calibration_is_environment_stable()) {
            APP_LOG_WARNING("%s Environment not stable enough for calibration", CALIB_TAG);
            g_calibration_mgr.last_fail = CALIBRATION_FAIL_UNSTABLE_ENV;
            return false;
        }
    }
    
    // 6. ���ˮ��״̬
    if (g_calibration_mgr.enable_flood_prevention) {
        // ���ȶ��Ի�������ȡ�����ƽ��ѹ��
        float recent_avg_pressure = calculate_average_local(
            g_calibration_mgr.stability_buffer.pressure_samples,
            g_calibration_mgr.stability_buffer.count
        );
        
        if (smart_calibration_detect_possible_flood(recent_avg_pressure)) {
            APP_LOG_WARNING("%s ?? Possible flood detected! Calibration aborted", CALIB_TAG);
            g_calibration_mgr.last_fail = CALIBRATION_FAIL_FLOOD_DETECTED;
            g_calibration_mgr.flood_prevented_count++;
            return false;
        }
    }
    
    // 7. ִ�б궨
    APP_LOG_INFO("%s All conditions met, executing calibration...", CALIB_TAG);
    bool success = smart_calibration_execute();
    
    if (success) {
        g_calibration_mgr.last_calibration_time = current_time_ms;
        g_calibration_mgr.success_count++;
        g_calibration_mgr.total_calibrations++;
        APP_LOG_INFO("%s ? Calibration successful! New baseline: %.2f hPa", 
                     CALIB_TAG, g_calibration_mgr.current_baseline_hpa);
    } else {
        g_calibration_mgr.fail_count++;
        g_calibration_mgr.total_calibrations++;
        APP_LOG_ERROR("%s ? Calibration failed!", CALIB_TAG);
    }
    
    return success;
}

/*
 * �����жϺ���ʵ��
 *****************************************************************************************
 */
bool smart_calibration_is_needed(uint32_t current_time_ms)
{
    uint32_t time_since_last = current_time_ms - g_calibration_mgr.last_calibration_time;
    
    // 1. �����δ�궨������Ҫ�궨
    if (g_calibration_mgr.last_calibration_time == 0) {
        APP_LOG_INFO("%s Calibration needed: never calibrated", CALIB_TAG);
        return true;
    }
    
    // 2. ��������ϴα궨̫��������Ҫ
    if (time_since_last < CALIBRATION_MIN_INTERVAL_MS) {
        APP_LOG_DEBUG("%s Too soon since last calibration (%d hours)",
                     CALIB_TAG, time_since_last / 3600000);
        g_calibration_mgr.last_fail = CALIBRATION_FAIL_TOO_SOON;
        return false;
    }
    
    // 3. ������������������궨
    if (time_since_last > CALIBRATION_MAX_INTERVAL_MS) {
        APP_LOG_INFO("%s Calibration needed: max interval exceeded (%d days)",
                     CALIB_TAG, time_since_last / 86400000);
        return true;
    }
    
    // 4. ����׼ѹ��Ư��
    if (g_calibration_mgr.stability_buffer.count >= STABILITY_REQUIRED_SAMPLES) {
        float recent_avg = calculate_average_local(
            g_calibration_mgr.stability_buffer.pressure_samples,
            g_calibration_mgr.stability_buffer.count
        );
        
        float drift = fabsf(recent_avg - g_calibration_mgr.current_baseline_hpa);
        
        if (drift > BASELINE_DRIFT_THRESHOLD_HPA) {
            APP_LOG_INFO("%s Calibration needed: baseline drift %.2f hPa (threshold %.2f)",
                         CALIB_TAG, drift, BASELINE_DRIFT_THRESHOLD_HPA);
            return true;
        }
    }
    
    return false;
}

bool smart_calibration_is_in_time_window(uint8_t rtc_hour)
{
    // 检查是否在配置时间窗口内，避免对无符号数做“>=0”的无意义比较
    if (CALIBRATION_WINDOW_START_HOUR == 0U) {
        return (rtc_hour < CALIBRATION_WINDOW_END_HOUR);
    }

    return (rtc_hour >= CALIBRATION_WINDOW_START_HOUR &&
            rtc_hour < CALIBRATION_WINDOW_END_HOUR);
}

bool smart_calibration_is_environment_stable(void)
{
    stability_buffer_t *buf = &g_calibration_mgr.stability_buffer;
    
    // ��Ҫ�㹻�Ĳ�������
    if (buf->count < STABILITY_REQUIRED_SAMPLES) {
        APP_LOG_DEBUG("%s Not enough samples for stability check (%d/%d)",
                     CALIB_TAG, buf->count, STABILITY_REQUIRED_SAMPLES);
        return false;
    }
    
    // ����ѹ������
    float pressure_variance = calculate_variance_local(buf->pressure_samples, buf->count);
    
    // �����¶ȷ���
    float temp_variance = calculate_variance_local(buf->temp_samples, buf->count);
    
    bool pressure_stable = (pressure_variance < STABILITY_PRESSURE_VARIANCE_HPA);
    bool temp_stable = (temp_variance < STABILITY_TEMP_VARIANCE_C);
    
    APP_LOG_DEBUG("%s Stability: P_var=%.3f (threshold %.3f), T_var=%.3f (threshold %.3f)",
                 CALIB_TAG, pressure_variance, STABILITY_PRESSURE_VARIANCE_HPA,
                 temp_variance, STABILITY_TEMP_VARIANCE_C);
    
    return (pressure_stable && temp_stable);
}

bool smart_calibration_detect_possible_flood(float sensor_pressure_hpa)
{
    // �����׼��δ��ʼ�����޷��ж�
    if (g_calibration_mgr.current_baseline_hpa == 0.0f) {
        return false;
    }
    
    float pressure_delta = sensor_pressure_hpa - g_calibration_mgr.current_baseline_hpa;
    
    // �����ж��߼�
    bool high_pressure = (pressure_delta > FLOOD_DETECTION_DELTA_HPA);
    bool safe_pressure = (pressure_delta < FLOOD_SAFE_DELTA_HPA);
    
    // ���¼�����
    update_flood_detection_counter(high_pressure);
    
    // ��Ҫ������⵽��ѹ����Ϊ��ˮ��
    bool flood_confirmed = (g_calibration_mgr.flood_detection_count >= FLOOD_CONTINUOUS_COUNT);
    
    if (flood_confirmed) {
        APP_LOG_WARNING("%s Flood suspected! Current: %.2f, Baseline: %.2f, Delta: %.2f hPa",
                       CALIB_TAG, sensor_pressure_hpa, 
                       g_calibration_mgr.current_baseline_hpa, pressure_delta);
    }
    
    return flood_confirmed;
}

bool smart_calibration_validate_baseline(float new_baseline_hpa)
{
    // 1. ������ֵ��Χ����������ѹ��Χ��900-1100 hPa��
    if (new_baseline_hpa < 900.0f || new_baseline_hpa > 1100.0f) {
        APP_LOG_ERROR("%s Invalid baseline: %.2f hPa (out of range)", 
                     CALIB_TAG, new_baseline_hpa);
        return false;
    }
    
    // 2. ������л�׼�����仯����
    if (g_calibration_mgr.current_baseline_hpa != 0.0f) {
        float delta = fabsf(new_baseline_hpa - g_calibration_mgr.current_baseline_hpa);
        
        if (delta > BASELINE_ABNORMAL_DELTA_HPA) {
            APP_LOG_ERROR("%s Baseline change too large: %.2f hPa (threshold %.2f)",
                         CALIB_TAG, delta, BASELINE_ABNORMAL_DELTA_HPA);
            g_calibration_mgr.last_fail = CALIBRATION_FAIL_ABNORMAL_DELTA;
            return false;
        }
    }
    
    return true;
}

/*
 * ִ�к���ʵ��
 *****************************************************************************************
 */
bool smart_calibration_execute(void)
{
    g_calibration_mgr.state = CALIBRATION_STATE_EXECUTING;
    
    // ���浱ǰ��׼�����ڿ��ܵĻع���
    g_calibration_mgr.baseline_before_calibration = g_calibration_mgr.current_baseline_hpa;
    
    // ����WF5803F�����ı궨����
    // ����0.0f��ʾʹ�õ�ǰ������Ϊ�»�׼
    bool success = wf5803f_set_baseline_pressure(0.0f);
    
    if (success) {
        // ��ȡ�µĻ�׼ֵ
        float new_baseline = wf5803f_get_baseline_pressure();
        
        // ��֤�»�׼ֵ
        if (smart_calibration_validate_baseline(new_baseline)) {
            g_calibration_mgr.current_baseline_hpa = new_baseline;
            g_calibration_mgr.new_baseline_candidate_hpa = new_baseline;
            g_calibration_mgr.state = CALIBRATION_STATE_SUCCESS;
            g_calibration_mgr.last_fail = CALIBRATION_FAIL_NONE;
            
            // �����ȶ��Ի���������ʼ�µļ�����ڣ�
            reset_stability_buffer();
            
            // ����ˮ����������
            g_calibration_mgr.flood_detection_count = 0;
            g_calibration_mgr.safe_detection_count = 0;
            
            return true;
        } else {
            // �»�׼���������ع�
            smart_calibration_rollback();
            g_calibration_mgr.state = CALIBRATION_STATE_FAILED;
            return false;
        }
    } else {
        g_calibration_mgr.state = CALIBRATION_STATE_FAILED;
        g_calibration_mgr.last_fail = CALIBRATION_FAIL_SENSOR_ERROR;
        return false;
    }
}

void smart_calibration_rollback(void)
{
    APP_LOG_WARNING("%s Rolling back to previous baseline: %.2f hPa",
                   CALIB_TAG, g_calibration_mgr.baseline_before_calibration);
    
    wf5803f_set_baseline_pressure(g_calibration_mgr.baseline_before_calibration);
    g_calibration_mgr.current_baseline_hpa = g_calibration_mgr.baseline_before_calibration;
}

bool smart_calibration_force_trigger(bool skip_safety_checks)
{
    if (skip_safety_checks) {
        APP_LOG_WARNING("%s ?? Force calibration with safety checks SKIPPED!", CALIB_TAG);
        return smart_calibration_execute();
    } else {
        APP_LOG_INFO("%s Force calibration triggered (with safety checks)", CALIB_TAG);
        g_calibration_mgr.force_calibration_flag = true;
        return false;  // ������һ��scheduleʱִ��
    }
}

/*
 * �������ݹ���
 *****************************************************************************************
 */
void smart_calibration_add_sample(float pressure_hpa, 
                                  float temperature_c, 
                                  uint32_t timestamp_ms)
{
    stability_buffer_t *buf = &g_calibration_mgr.stability_buffer;
    
    // �������ݵ�ѭ��������
    buf->pressure_samples[buf->index] = pressure_hpa;
    buf->temp_samples[buf->index] = temperature_c;
    buf->timestamps[buf->index] = timestamp_ms;
    
    buf->index = (buf->index + 1) % STABILITY_CHECK_WINDOW;
    
    if (buf->count < STABILITY_CHECK_WINDOW) {
        buf->count++;
    }
    
    // ����ˮ�����
    if (g_calibration_mgr.current_baseline_hpa != 0.0f) {
        float delta = pressure_hpa - g_calibration_mgr.current_baseline_hpa;
        update_flood_detection_counter(delta > FLOOD_DETECTION_DELTA_HPA);
    }
}

/*
 * ��ѯ����Ϻ���ʵ��
 *****************************************************************************************
 */
calibration_state_t smart_calibration_get_state(void)
{
    return g_calibration_mgr.state;
}

calibration_fail_reason_t smart_calibration_get_last_fail_reason(void)
{
    return g_calibration_mgr.last_fail;
}

const char* smart_calibration_fail_reason_to_string(calibration_fail_reason_t reason)
{
    switch (reason) {
        case CALIBRATION_FAIL_NONE:           return "No failure";
        case CALIBRATION_FAIL_FLOOD_DETECTED: return "Flood detected";
        case CALIBRATION_FAIL_UNSTABLE_ENV:   return "Environment unstable";
        case CALIBRATION_FAIL_TIME_WINDOW:    return "Outside time window";
        case CALIBRATION_FAIL_TOO_SOON:       return "Too soon since last";
        case CALIBRATION_FAIL_ABNORMAL_DELTA: return "Abnormal pressure change";
        case CALIBRATION_FAIL_SENSOR_ERROR:   return "Sensor error";
        default:                              return "Unknown";
    }
}

uint32_t smart_calibration_get_time_since_last(uint32_t current_time_ms)
{
    if (g_calibration_mgr.last_calibration_time == 0) {
        return 0xFFFFFFFF;  // ��δ�궨
    }
    
    return (current_time_ms - g_calibration_mgr.last_calibration_time) / 1000;  // ת��Ϊ��
}

uint32_t smart_calibration_get_time_to_next_force(uint32_t current_time_ms)
{
    if (g_calibration_mgr.last_calibration_time == 0) {
        return 0;  // ��Ҫ�����궨
    }
    
    uint32_t elapsed_ms = current_time_ms - g_calibration_mgr.last_calibration_time;
    
    if (elapsed_ms >= CALIBRATION_MAX_INTERVAL_MS) {
        return 0;  // �ѵ���
    }
    
    return (CALIBRATION_MAX_INTERVAL_MS - elapsed_ms) / 1000;  // ת��Ϊ��
}

void smart_calibration_print_statistics(void)
{
    APP_LOG_INFO("=== Smart Calibration Statistics ===");
    APP_LOG_INFO("Total calibrations: %d", g_calibration_mgr.total_calibrations);
    APP_LOG_INFO("Success count: %d", g_calibration_mgr.success_count);
    APP_LOG_INFO("Fail count: %d", g_calibration_mgr.fail_count);
    APP_LOG_INFO("Flood prevented: %d times", g_calibration_mgr.flood_prevented_count);
    
    if (g_calibration_mgr.total_calibrations > 0) {
        float success_rate = (float)g_calibration_mgr.success_count / 
                            g_calibration_mgr.total_calibrations * 100.0f;
        APP_LOG_INFO("Success rate: %.1f%%", success_rate);
    }
    
    APP_LOG_INFO("===================================");
}

void smart_calibration_print_status(void)
{
    APP_LOG_INFO("=== Smart Calibration Status ===");
    APP_LOG_INFO("State: %d", g_calibration_mgr.state);
    APP_LOG_INFO("Current baseline: %.2f hPa", g_calibration_mgr.current_baseline_hpa);
    APP_LOG_INFO("Last fail reason: %s", 
                 smart_calibration_fail_reason_to_string(g_calibration_mgr.last_fail));
    APP_LOG_INFO("Stability samples: %d/%d", 
                 g_calibration_mgr.stability_buffer.count, STABILITY_CHECK_WINDOW);
    APP_LOG_INFO("Flood detection count: %d", g_calibration_mgr.flood_detection_count);
    APP_LOG_INFO("================================");
}

/*
 * ���ú���ʵ��
 *****************************************************************************************
 */
void smart_calibration_set_time_window_enable(bool enable)
{
    g_calibration_mgr.enable_time_window = enable;
    APP_LOG_INFO("%s Time window %s", CALIB_TAG, enable ? "enabled" : "disabled");
}

void smart_calibration_set_stability_check_enable(bool enable)
{
    g_calibration_mgr.enable_stability_check = enable;
    APP_LOG_INFO("%s Stability check %s", CALIB_TAG, enable ? "enabled" : "disabled");
}

void smart_calibration_set_flood_prevention_enable(bool enable)
{
    g_calibration_mgr.enable_flood_prevention = enable;
    APP_LOG_INFO("%s Flood prevention %s", CALIB_TAG, enable ? "enabled" : "disabled");
}

/*
 * ���ظ�������ʵ��
 *****************************************************************************************
 */
static float calculate_variance_local(float *data, uint8_t count)
{
    if (count == 0) return 0.0f;
    
    // �����ֵ
    float mean = calculate_average_local(data, count);
    
    // ���㷽��
    float variance = 0.0f;
    for (uint8_t i = 0; i < count; i++) {
        float diff = data[i] - mean;
        variance += diff * diff;
    }
    variance /= count;
    
    return variance;
}

static float calculate_average_local(float *data, uint8_t count)
{
    if (count == 0) return 0.0f;
    
    float sum = 0.0f;
    for (uint8_t i = 0; i < count; i++) {
        sum += data[i];
    }
    
    return sum / count;
}

static void reset_stability_buffer(void)
{
    memset(&g_calibration_mgr.stability_buffer, 0, sizeof(stability_buffer_t));
}

static void update_flood_detection_counter(bool flood_suspected)
{
    if (flood_suspected) {
        g_calibration_mgr.flood_detection_count++;
        g_calibration_mgr.safe_detection_count = 0;  // ���ð�ȫ����
    } else {
        g_calibration_mgr.safe_detection_count++;
        
        // ���������ΰ�ȫ������ˮ������
        if (g_calibration_mgr.safe_detection_count >= FLOOD_CONTINUOUS_COUNT) {
            g_calibration_mgr.flood_detection_count = 0;
        }
    }
}
