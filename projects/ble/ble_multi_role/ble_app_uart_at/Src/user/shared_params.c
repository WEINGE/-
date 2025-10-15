#include "shared_params.h"
#include "app_log.h"
#include "hal_flash.h"
#include <string.h>
#include <stdlib.h>

#define DEBUG_TAG "SHARED_PARAMS"

// Flash存储相关定义
#define PARAMS_FLASH_ADDR   0x01080000  // Flash存储地址

// 全局共享参数实例
shared_device_params_t g_shared_params = {0};

// 参数变更回调函数指针
static param_change_callback_t s_param_callback = NULL;

// 默认参数值
static const shared_device_params_t default_params = {
    .device_collect_time = 60,          // 默认1小时采集
    .device_updata_time = 1440,         // 默认24小时上报
    .methane_threshold = 5.0f,          // 默认5%vol甲烷阈值
    .temp_high_threshold = 50,          // 默认50℃高温阈值
    .temp_low_threshold = -20,          // 默认-20℃低温阈值
    .water_threshold = 1000,            // 默认水浸阈值
    .location_lat = 0.0f,
    .location_lon = 0.0f,
    .install_lat = 0.0f,
    .install_lon = 0.0f,
    .server_port = 1883,
    .server_type = 1,                   // 默认MQTT
    .params_initialized = true,
    .params_checksum = 0
};

/**
 * @brief 计算参数校验和
 */
uint32_t shared_params_calculate_checksum(void)
{
    uint32_t checksum = 0;
    uint8_t *data = (uint8_t*)&g_shared_params;
    size_t size = sizeof(shared_device_params_t) - sizeof(uint32_t); // 排除checksum字段
    
    for (size_t i = 0; i < size; i++) {
        checksum += data[i];
    }
    
    return checksum;
}

/**
 * @brief 验证参数有效性
 */
bool shared_params_validate(void)
{
    uint32_t calculated_checksum = shared_params_calculate_checksum();
    
    if (g_shared_params.params_checksum != calculated_checksum) {
        APP_LOG_ERROR("%s Checksum mismatch: stored=0x%08X, calculated=0x%08X", 
                     DEBUG_TAG, g_shared_params.params_checksum, calculated_checksum);
        return false;
    }
    
    // 参数范围验证
    if (g_shared_params.device_collect_time < 1 || g_shared_params.device_collect_time > 1440) {
        APP_LOG_ERROR("%s Invalid collect time: %d", DEBUG_TAG, g_shared_params.device_collect_time);
        return false;
    }
    
    if (g_shared_params.device_updata_time < 1 || g_shared_params.device_updata_time > 1440) {
        APP_LOG_ERROR("%s Invalid update time: %d", DEBUG_TAG, g_shared_params.device_updata_time);
        return false;
    }
    
    if (g_shared_params.methane_threshold < 0.0f || g_shared_params.methane_threshold > 100.0f) {
        APP_LOG_ERROR("%s Invalid methane threshold: %.2f", DEBUG_TAG, g_shared_params.methane_threshold);
        return false;
    }
    
    return true;
}

/**
 * @brief 初始化共享参数
 */
bool shared_params_init(void)
{
    // 尝试从Flash加载参数
    if (shared_params_load_from_flash()) {
        if (shared_params_validate()) {
            APP_LOG_INFO("%s Parameters loaded from Flash", DEBUG_TAG);
            return true;
        } else {
            APP_LOG_WARNING("%s Invalid parameters in Flash, using defaults", DEBUG_TAG);
        }
    }
    
    // 使用默认参数
    memcpy(&g_shared_params, &default_params, sizeof(shared_device_params_t));
    g_shared_params.params_checksum = shared_params_calculate_checksum();
    
    // 保存默认参数到Flash
    if (shared_params_save_to_flash()) {
        APP_LOG_INFO("%s Default parameters saved to Flash", DEBUG_TAG);
    }
    
    return true;
}

/**
 * @brief 保存参数到Flash
 */
bool shared_params_save_to_flash(void)
{
    g_shared_params.params_checksum = shared_params_calculate_checksum();
    
    // 擦除Flash扇区
    if (!hal_flash_erase(PARAMS_FLASH_ADDR, sizeof(shared_device_params_t)))
    {
        APP_LOG_ERROR("%s Failed to erase flash", DEBUG_TAG);
        return false;
    }
    
    // 写入Flash
    uint32_t written = hal_flash_write(PARAMS_FLASH_ADDR, (uint8_t *)&g_shared_params, sizeof(shared_device_params_t));
    if (written != sizeof(shared_device_params_t))
    {
        APP_LOG_ERROR("%s Failed to write flash: written=%d, expected=%d", DEBUG_TAG, written, sizeof(shared_device_params_t));
        return false;
    }
    
    APP_LOG_INFO("%s Parameters saved to Flash (checksum: 0x%08X)", 
                 DEBUG_TAG, g_shared_params.params_checksum);
    return true;
}

/**
 * @brief 从Flash加载参数
 */
bool shared_params_load_from_flash(void)
{
    // 从Flash读取数据
    uint32_t read_bytes = hal_flash_read(PARAMS_FLASH_ADDR, (uint8_t *)&g_shared_params, sizeof(shared_device_params_t));
    if (read_bytes != sizeof(shared_device_params_t))
    {
        APP_LOG_ERROR("%s Failed to read flash: read=%d, expected=%d", DEBUG_TAG, read_bytes, sizeof(shared_device_params_t));
        return false;
    }
    
    APP_LOG_INFO("%s Parameters loaded from Flash", DEBUG_TAG);
    return true;
}

/**
 * @brief 注册参数变更回调函数
 */
void shared_params_register_callback(param_change_callback_t callback)
{
    s_param_callback = callback;
    APP_LOG_INFO("%s Parameter change callback registered", DEBUG_TAG);
}

/**
 * @brief 通知参数变更
 */
static void notify_param_change(uint16_t param_type, const void* param_data)
{
    if (s_param_callback) {
        s_param_callback(param_type, param_data);
    }
}

/**
 * @brief 设置采集周期
 */
bool shared_params_set_collect_time(uint16_t time_minutes)
{
    if (time_minutes < 1 || time_minutes > 1440) {
        APP_LOG_ERROR("%s Invalid collect time: %d (range: 1-1440)", DEBUG_TAG, time_minutes);
        return false;
    }
    
    g_shared_params.device_collect_time = time_minutes;
    
    APP_LOG_INFO("%s Set collect time: %d minutes", DEBUG_TAG, time_minutes);
    
    // 通知变更
    notify_param_change(PARAM_TYPE_COLLECT_TIME, &time_minutes);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置上报周期
 */
bool shared_params_set_update_time(uint16_t time_minutes)
{
    if (time_minutes < 1 || time_minutes > 1440) {
        APP_LOG_ERROR("%s Invalid update time: %d (range: 1-1440)", DEBUG_TAG, time_minutes);
        return false;
    }
    
    g_shared_params.device_updata_time = time_minutes;
    
    APP_LOG_INFO("%s Set update time: %d minutes", DEBUG_TAG, time_minutes);
    
    // 通知变更
    notify_param_change(PARAM_TYPE_UPDATE_TIME, &time_minutes);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置甲烷阈值
 */
bool shared_params_set_methane_threshold(float threshold)
{
    if (threshold < 0.0f || threshold > 100.0f) {
        APP_LOG_ERROR("%s Invalid methane threshold: %.2f (range: 0-100)", DEBUG_TAG, threshold);
        return false;
    }
    
    g_shared_params.methane_threshold = threshold;
    
    APP_LOG_INFO("%s Set methane threshold: %.2f%%vol", DEBUG_TAG, threshold);
    
    // 通知变更
    notify_param_change(PARAM_TYPE_METHANE_THRESH, &threshold);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置温度阈值
 */
bool shared_params_set_temp_thresholds(int16_t high, int16_t low)
{
    if (high <= low) {
        APP_LOG_ERROR("%s Invalid temp thresholds: high=%d, low=%d", DEBUG_TAG, high, low);
        return false;
    }
    
    g_shared_params.temp_high_threshold = high;
    g_shared_params.temp_low_threshold = low;
    
    APP_LOG_INFO("%s Set temp thresholds: high=%d°C, low=%d°C", DEBUG_TAG, high, low);
    
    // 通知变更
    struct { int16_t high; int16_t low; } temp_data = {high, low};
    notify_param_change(PARAM_TYPE_TEMP_THRESH, &temp_data);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置水浸阈值
 */
bool shared_params_set_water_threshold(uint16_t threshold)
{
    g_shared_params.water_threshold = threshold;
    
    APP_LOG_INFO("%s Set water threshold: %d", DEBUG_TAG, threshold);
    
    // 通知变更
    notify_param_change(PARAM_TYPE_WATER_THRESH, &threshold);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置当前位置
 */
bool shared_params_set_location(float lat, float lon)
{
    g_shared_params.location_lat = lat;
    g_shared_params.location_lon = lon;
    
    APP_LOG_INFO("%s Set location: lat=%.6f, lon=%.6f", DEBUG_TAG, lat, lon);
    
    // 通知变更
    struct { float lat; float lon; } loc_data = {lat, lon};
    notify_param_change(PARAM_TYPE_LOCATION, &loc_data);
    
    return shared_params_save_to_flash();
}

/**
 * @brief 设置安装位置
 */
bool shared_params_set_install_location(float lat, float lon)
{
    g_shared_params.install_lat = lat;
    g_shared_params.install_lon = lon;
    
    APP_LOG_INFO("%s Set install location: lat=%.6f, lon=%.6f", DEBUG_TAG, lat, lon);
    
    // 通知变更
    struct { float lat; float lon; } loc_data = {lat, lon};
    notify_param_change(PARAM_TYPE_INSTALL_LOC, &loc_data);
    
    return shared_params_save_to_flash();
}

// 参数获取函数实现
uint16_t shared_params_get_collect_time(void) { return g_shared_params.device_collect_time; }
uint16_t shared_params_get_update_time(void) { return g_shared_params.device_updata_time; }
float shared_params_get_methane_threshold(void) { return g_shared_params.methane_threshold; }
int16_t shared_params_get_temp_high_threshold(void) { return g_shared_params.temp_high_threshold; }
int16_t shared_params_get_temp_low_threshold(void) { return g_shared_params.temp_low_threshold; }
uint16_t shared_params_get_water_threshold(void) { return g_shared_params.water_threshold; }

// 状态设置函数实现 (不保存到Flash)
void shared_params_set_sensor_status(uint8_t status)
{
    if (g_shared_params.sensor_status != status)
    {
        g_shared_params.sensor_status = status;
        APP_LOG_INFO("%s Set sensor status: %d", DEBUG_TAG, status);
        notify_param_change(PARAM_TYPE_SENSOR_STATUS, &status);
    }
}

void shared_params_set_device_water(uint8_t status)
{
    if (g_shared_params.device_water != status)
    {
        g_shared_params.device_water = status;
        APP_LOG_INFO("%s Set device water status: %d", DEBUG_TAG, status);
        notify_param_change(PARAM_TYPE_DEVICE_WATER, &status);
    }
}

void shared_params_set_device_move(uint8_t status)
{
    if (g_shared_params.device_move != status)
    {
        g_shared_params.device_move = status;
        APP_LOG_INFO("%s Set device move status: %d", DEBUG_TAG, status);
        notify_param_change(PARAM_TYPE_DEVICE_MOVE, &status);
    }
}
