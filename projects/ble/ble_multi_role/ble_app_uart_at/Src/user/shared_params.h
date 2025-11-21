#ifndef SHARED_PARAMS_H
#define SHARED_PARAMS_H

#include <stdint.h>
#include <stdbool.h>

/**
 * @brief 统一的设备参数结构体
 * 蓝牙和4G协议共享此数据结构，确保参数同步一致性
 */
typedef struct {
    // 采集和上报周期
    uint16_t device_collect_time;       /**< 传感器采集间隔，单位分钟 (1-1440) */
    uint16_t device_updata_time;        /**< 数据上报间隔，单位分钟 (1-1440) */
    
    // 阈值设置 - 统一数据类型
    float    methane_threshold;         /**< 甲烷报警阈值，单位%vol */
    int16_t  temp_high_threshold;       /**< 高温报警阈值，单位℃ */
    int16_t  temp_low_threshold;        /**< 低温报警阈值，单位℃ */
    uint16_t water_threshold;           /**< 水浸报警阈值 */
    
    // 位置信息
    float    location_lat;              /**< 纬度 */
    float    location_lon;              /**< 经度 */
    float    install_lat;               /**< 安装位置纬度 */
    float    install_lon;               /**< 安装位置经度 */
    
    // 服务器配置
    char     server_address[64];        /**< 服务器地址 */
    uint16_t server_port;               /**< 服务器端口 */
    char     username[32];              /**< 用户名 */
    char     password[32];              /**< 密码 */
    uint8_t  server_type;               /**< 服务器类型: 0=TCP, 1=MQTT, 2=HTTP */
    
    // 设备信息
    char     device_id[32];             /**< 设备ID */
    char     device_version[16];        /**< 固件版本 */
    char     imei[16];                  /**< IMEI号 */
    char     sim_id[32];                /**< SIM卡ID */
    
    // 实时状态信息 (蓝牙同步，不存Flash)
    uint8_t  sensor_status;             /**< 传感器状态: 0=正常, 1=异常 */
    uint8_t  device_water;              /**< 水浸状态: 0=正常, 1=水浸 */
    uint8_t  device_move;               /**< 移动状态: 0=正常, 1=移动 */
    uint8_t  device_GPS_status;         /**< GPS状态: 0=正常, 1=异常 */

    // 参数有效性标志
    uint32_t params_version;            /**< 参数版本号，用于检测结构体变更 */
    bool     params_initialized;        /**< 参数是否已初始化 */
    uint32_t params_checksum;           /**< 参数校验和 */
    
} shared_device_params_t;

// 全局共享参数实例
extern shared_device_params_t g_shared_params;

// 参数管理函数
bool shared_params_init(void);
bool shared_params_save_to_flash(void);
bool shared_params_load_from_flash(void);
uint32_t shared_params_calculate_checksum(void);
bool shared_params_validate(void);

// 参数设置函数 - 带同步通知
bool shared_params_set_collect_time(uint16_t time_minutes);
bool shared_params_set_update_time(uint16_t time_minutes);
bool shared_params_set_methane_threshold(float threshold);
bool shared_params_set_temp_thresholds(int16_t high, int16_t low);
bool shared_params_set_water_threshold(uint16_t threshold);
bool shared_params_set_location(float lat, float lon);
bool shared_params_set_install_location(float lat, float lon);

// 状态设置函数 (不保存到Flash, 只更新内存并通知)
void shared_params_set_sensor_status(uint8_t status);
void shared_params_set_device_water(uint8_t status);
void shared_params_set_device_move(uint8_t status);
void shared_params_set_device_gps_status(uint8_t status);

// 参数获取函数
uint16_t shared_params_get_collect_time(void);
uint16_t shared_params_get_update_time(void);
float shared_params_get_methane_threshold(void);
int16_t shared_params_get_temp_high_threshold(void);
int16_t shared_params_get_temp_low_threshold(void);
uint16_t shared_params_get_water_threshold(void);

// 同步回调函数类型
typedef void (*param_change_callback_t)(uint16_t param_type, const void* param_data);

// 回调注册函数
void shared_params_register_callback(param_change_callback_t callback);

// 参数类型定义
#define PARAM_TYPE_COLLECT_TIME     0x0001
#define PARAM_TYPE_UPDATE_TIME      0x0002
#define PARAM_TYPE_METHANE_THRESH   0x0003
#define PARAM_TYPE_TEMP_THRESH      0x0004
#define PARAM_TYPE_WATER_THRESH     0x0005
#define PARAM_TYPE_LOCATION         0x0006
#define PARAM_TYPE_INSTALL_LOC      0x0007

#define PARAM_TYPE_SENSOR_STATUS    0x0101
#define PARAM_TYPE_DEVICE_WATER     0x0102
#define PARAM_TYPE_DEVICE_MOVE      0x0103
#define PARAM_TYPE_DEVICE_GPS_STATUS 0x0104

// 参数版本号定义
// 每次修改 shared_device_params_t 结构体时，请递增此版本号
// 这样可以确保Flash中的旧数据不会被错误加载
#define PARAMS_VERSION              0x00010005 // v1.2 - 添加device_water默认值为1

#endif // SHARED_PARAMS_H
