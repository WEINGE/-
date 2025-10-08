/**
 *****************************************************************************************
 *
 * @file bm8563_rtc.h
 *
 * @brief BM8563EHA RTC芯片驱动头文件（软件I2C实现）
 *
 * @details 功能说明：
 *          - 使用AON GPIO实现软件I2C通信
 *          - 支持读取和设置时间日期
 *          - 时间格式: "YYYYMMDDHHmmss" (如: "20241114164235")
 *          - BM8563芯片I2C地址: 0x51
 *
 * 硬件连接:
 *          - AON_GPIO_5: SDA (数据线)
 *          - AON_GPIO_4: SCL (时钟线)
 *          - AON_GPIO_3: CLK_INT (中断引脚，可选)
 *
 *****************************************************************************************
 */

#ifndef __BM8563_RTC_H__
#define __BM8563_RTC_H__

#include <stdint.h>
#include <stdbool.h>

/*
 * DEFINES
 *****************************************************************************************
 */

/** BM8563芯片I2C地址 */
#define BM8563_I2C_ADDR         0x51

/** BM8563寄存器地址定义 */
#define BM8563_REG_CTRL_STATUS1 0x00  // 控制/状态寄存器1
#define BM8563_REG_CTRL_STATUS2 0x01  // 控制/状态寄存器2
#define BM8563_REG_SECOND       0x02  // 秒寄存器
#define BM8563_REG_MINUTE       0x03  // 分钟寄存器
#define BM8563_REG_HOUR         0x04  // 小时寄存器
#define BM8563_REG_DAY          0x05  // 日寄存器
#define BM8563_REG_WEEKDAY      0x06  // 星期寄存器
#define BM8563_REG_MONTH        0x07  // 月寄存器
#define BM8563_REG_YEAR         0x08  // 年寄存器

/** GPIO引脚定义 */
#define RTC_SDA_AON_GPIO        APP_IO_PIN_5  // AON_GPIO_5 -> SDA
#define RTC_SCL_AON_GPIO        APP_IO_PIN_4  // AON_GPIO_4 -> SCL
#define RTC_INT_AON_GPIO        APP_IO_PIN_3  // AON_GPIO_3 -> CLK_INT

/** 时间字符串格式长度 */
#define RTC_TIME_STRING_LEN     15  // "YYYYMMDDHHmmss" + '\0'

/*
 * TYPE DEFINITIONS
 *****************************************************************************************
 */

/**
 * @brief RTC时间结构体
 */
typedef struct
{
    uint16_t year;       ///< 年 (2000-2099)
    uint8_t  month;      ///< 月 (1-12)
    uint8_t  day;        ///< 日 (1-31)
    uint8_t  weekday;    ///< 星期 (0-6, 0=周日)
    uint8_t  hour;       ///< 时 (0-23)
    uint8_t  minute;     ///< 分 (0-59)
    uint8_t  second;     ///< 秒 (0-59)
} rtc_time_t;

/*
 * FUNCTION DECLARATIONS
 *****************************************************************************************
 */

/**
 * @brief 初始化BM8563 RTC模块
 * 
 * @details 初始化软件I2C和RTC芯片，配置GPIO引脚
 * 
 * @return true: 初始化成功
 * @return false: 初始化失败
 */
bool bm8563_init(void);

/**
 * @brief 读取RTC当前时间
 * 
 * @param[out] p_time 时间结构体指针
 * 
 * @return true: 读取成功
 * @return false: 读取失败
 */
bool bm8563_read_time(rtc_time_t *p_time);

/**
 * @brief 设置RTC时间
 * 
 * @param[in] p_time 时间结构体指针
 * 
 * @return true: 设置成功
 * @return false: 设置失败
 */
bool bm8563_set_time(const rtc_time_t *p_time);

/**
 * @brief 获取格式化的时间字符串
 * 
 * @details 返回格式: "YYYYMMDDHHmmss" (如: "20241114164235")
 * 
 * @param[out] time_str 时间字符串缓冲区 (至少15字节)
 * 
 * @return true: 获取成功
 * @return false: 获取失败
 */
bool bm8563_get_time_string(char *time_str);

/**
 * @brief 检查RTC芯片是否正常工作
 * 
 * @return true: RTC正常
 * @return false: RTC异常
 */
bool bm8563_is_running(void);

/**
 * @brief 启动RTC计时
 * 
 * @return true: 启动成功
 * @return false: 启动失败
 */
bool bm8563_start(void);

/**
 * @brief 停止RTC计时
 * 
 * @return true: 停止成功
 * @return false: 停止失败
 */
bool bm8563_stop(void);

/**
 * @brief 从4G网络时间字符串设置RTC时间
 * 
 * @details 解析4G模块返回的时间格式并设置到RTC
 *          支持的格式: "2024/11/14,16:42:35" 或 "24/11/14,16:42:35"
 * 
 * @param[in] network_time 4G网络时间字符串
 * 
 * @return true: 设置成功
 * @return false: 设置失败（格式错误或RTC通信失败）
 */
bool bm8563_set_time_from_network(const char *network_time);

#endif /* __BM8563_RTC_H__ */

