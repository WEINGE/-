#include "shared_params.h"
#include "app_log.h"
#include "hal_flash.h"
#include <string.h>
#include <stdlib.h>

#define TAG "PARAMS"

// Flash存储相关定义
#define PARAMS_FLASH_ADDR   0x01080000  // Flash存储地址

// 全局共享参数实例
shared_device_params_t g_shared_params = {0};

// 参数变更回调函数指针
static param_change_callback_t s_param_callback = NULL;

// 默认参数�?
static const shared_device_params_t default_params = {
    .device_collect_time = 60,              // 默认60分钟采集
    .device_updata_time = 60,              // 默认60分钟上报
    .water_depth_threshold_cm = 5.0f,      // 默认5cm水深报警阈�?
    .temp_high_threshold = 50,              // 默认50℃高温阈�?
    .temp_low_threshold = -20,              // 默认-20℃低温阈�?
    .water_threshold = 0,                   // 兼容字段
    .location_lat = 0.0f,
    .location_lon = 0.0f,
    .install_lat = 0.0f,
    .install_lon = 0.0f,
    // 服务器默认配置（MQTT�?
    .server_address = "101.200.34.226",     // 默认服务器地址
    .server_port    = 1883,                 // 默认服务器端�?
    .username       = "admin",              // 默认用户�?
    .password       = "Admin123",           // 默认密码
    .server_type    = 1,                    // 默认MQTT
    .pub_topic      = "/water_sensor/test/report",
    .sub_topic      = "/water_sensor/test/command",
    
    // 实时状态信息默认�?
    .sensor_status = 0,                     // 默认传感器正�?
    .device_water = 0,                      // 默认无水�?
    .device_move = 0,                       // 默认未移�?
    .device_GPS_status = 0,                 // 默认GPS正常
    
    .params_version = PARAMS_VERSION,       // 参数版本�?
    .params_initialized = true,
    .params_checksum = 0
};

/**
 * @brief 计算参数校验�?
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

/** @brief 验证参数有效�?*/
bool shared_params_validate(void)
{
    // 校验和验�?
    if (g_shared_params.params_checksum != shared_params_calculate_checksum()) return false;
    // 参数范围验证
    if (g_shared_params.device_collect_time < 1 || g_shared_params.device_collect_time > 1440) return false;
    if (g_shared_params.device_updata_time < 1 || g_shared_params.device_updata_time > 1440) return false;
    // 水深阈值范围：0-500 cm
    if (g_shared_params.water_depth_threshold_cm < 0.0f || g_shared_params.water_depth_threshold_cm > 500.0f) return false;
    return true;
}

/** @brief 初始化共享参�?*/
bool shared_params_init(void)
{
    // 尝试从Flash加载参数
    if (shared_params_load_from_flash() && 
        g_shared_params.params_version == PARAMS_VERSION && 
        shared_params_validate()) {
        APP_LOG_INFO("Shared params loaded from flash, version=0x%08X", g_shared_params.params_version);
        return true;
    }
    
    // 使用默认参数（水位检测配置）
    APP_LOG_INFO("Using default params for water level detection");
    memcpy(&g_shared_params, &default_params, sizeof(shared_device_params_t));
    g_shared_params.params_checksum = shared_params_calculate_checksum();
    shared_params_save_to_flash();
    return true;
}

/** @brief 保存参数到Flash */
bool shared_params_save_to_flash(void)
{
    g_shared_params.params_checksum = shared_params_calculate_checksum();
    if (!hal_flash_erase(PARAMS_FLASH_ADDR, sizeof(shared_device_params_t))) return false;
    return hal_flash_write(PARAMS_FLASH_ADDR, (uint8_t*)&g_shared_params, sizeof(shared_device_params_t)) == sizeof(shared_device_params_t);
}

/** @brief 从Flash加载参数 */
bool shared_params_load_from_flash(void)
{
    return hal_flash_read(PARAMS_FLASH_ADDR, (uint8_t*)&g_shared_params, sizeof(shared_device_params_t)) == sizeof(shared_device_params_t);
}

/** @brief 注册参数变更回调 */
void shared_params_register_callback(param_change_callback_t callback) { s_param_callback = callback; }

/**
 * @brief 通知参数变更
 */
static void notify_param_change(uint16_t param_type, const void* param_data)
{
    if (s_param_callback) {
        s_param_callback(param_type, param_data);
    }
}

/** @brief 设置采集周期(1-1440分钟) */
bool shared_params_set_collect_time(uint16_t time_minutes)
{
    if (time_minutes < 1 || time_minutes > 1440) return false;
    g_shared_params.device_collect_time = time_minutes;
    notify_param_change(PARAM_TYPE_COLLECT_TIME, &time_minutes);
    return shared_params_save_to_flash();
}

/** @brief 设置上报周期(1-1440分钟) */
bool shared_params_set_update_time(uint16_t time_minutes)
{
    if (time_minutes < 1 || time_minutes > 1440) return false;
    g_shared_params.device_updata_time = time_minutes;
    notify_param_change(PARAM_TYPE_UPDATE_TIME, &time_minutes);
    return shared_params_save_to_flash();
}

/** @brief 设置水深报警阈�?cm�?-500) */
bool shared_params_set_water_depth_threshold(float threshold_cm)
{
    if (threshold_cm < 0.0f || threshold_cm > 500.0f) return false;
    g_shared_params.water_depth_threshold_cm = threshold_cm;
    notify_param_change(PARAM_TYPE_WATER_DEPTH_THRESH, &threshold_cm);
    return shared_params_save_to_flash();
}

/** @brief 设置温度阈�?high>low) */
bool shared_params_set_temp_thresholds(int16_t high, int16_t low)
{
    if (high <= low) return false;
    g_shared_params.temp_high_threshold = high;
    g_shared_params.temp_low_threshold = low;
    struct { int16_t high; int16_t low; } td = {high, low};
    notify_param_change(PARAM_TYPE_TEMP_THRESH, &td);
    return shared_params_save_to_flash();
}

/** @brief 设置水浸报警阈�?兼容字段) */
bool shared_params_set_water_threshold(uint16_t threshold)
{
    g_shared_params.water_threshold = threshold;
    notify_param_change(PARAM_TYPE_WATER_THRESH, &threshold);
    return shared_params_save_to_flash();
}

/** @brief 设置当前位置 */
bool shared_params_set_location(float lat, float lon)
{
    g_shared_params.location_lat = lat;
    g_shared_params.location_lon = lon;
    struct { float lat; float lon; } ld = {lat, lon};
    notify_param_change(PARAM_TYPE_LOCATION, &ld);
    return shared_params_save_to_flash();
}

/** @brief 设置安装位置 */
bool shared_params_set_install_location(float lat, float lon)
{
    g_shared_params.install_lat = lat;
    g_shared_params.install_lon = lon;
    struct { float lat; float lon; } ld = {lat, lon};
    notify_param_change(PARAM_TYPE_INSTALL_LOC, &ld);
    return shared_params_save_to_flash();
}

/* 参数获取函数 */
uint16_t shared_params_get_collect_time(void) { return g_shared_params.device_collect_time; }
uint16_t shared_params_get_update_time(void) { return g_shared_params.device_updata_time; }
float shared_params_get_water_depth_threshold(void) { return g_shared_params.water_depth_threshold_cm; }
int16_t shared_params_get_temp_high_threshold(void) { return g_shared_params.temp_high_threshold; }
int16_t shared_params_get_temp_low_threshold(void) { return g_shared_params.temp_low_threshold; }
uint16_t shared_params_get_water_threshold(void) { return g_shared_params.water_threshold; }

/* 状态设置函�?不保存Flash) */
void shared_params_set_sensor_status(uint8_t s) {
    if (g_shared_params.sensor_status != s) { g_shared_params.sensor_status = s; notify_param_change(PARAM_TYPE_SENSOR_STATUS, &s); }
}
void shared_params_set_device_water(uint8_t s) {
    if (g_shared_params.device_water != s) { g_shared_params.device_water = s; notify_param_change(PARAM_TYPE_DEVICE_WATER, &s); }
}
void shared_params_set_device_move(uint8_t s) {
    if (g_shared_params.device_move != s) { g_shared_params.device_move = s; notify_param_change(PARAM_TYPE_DEVICE_MOVE, &s); }
}
void shared_params_set_device_gps_status(uint8_t s) {
    if (g_shared_params.device_GPS_status != s) { g_shared_params.device_GPS_status = s; notify_param_change(PARAM_TYPE_DEVICE_GPS_STATUS, &s); }
}


