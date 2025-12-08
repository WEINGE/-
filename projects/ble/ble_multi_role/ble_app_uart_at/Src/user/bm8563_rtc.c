/**
 * @file bm8563_rtc.c
 * @brief BM8563 RTC驱动（软件I2C）
 */

#include "bm8563_rtc.h"
#include "app_io.h"
#include "app_log.h"
#include <stdio.h>
#include <string.h>

/*==============================================================================
 *                              宏定义
 *============================================================================*/
#define TAG                 "RTC"
#define I2C_DELAY_LOOPS     80
#define BCD_TO_DEC(bcd)     (((bcd) >> 4) * 10 + ((bcd) & 0x0F))
#define DEC_TO_BCD(dec)     ((((dec) / 10) << 4) | ((dec) % 10))

/*==============================================================================
 *                              I2C底层函数声明
 *============================================================================*/
static void i2c_delay(void);
static void i2c_start(void);
static void i2c_stop(void);
static void i2c_ack(void);
static void i2c_nack(void);
static bool i2c_wait_ack(void);
static void i2c_write(uint8_t byte);
static uint8_t i2c_read(void);
static void sda_mode(uint8_t output);
static void sda_set(uint8_t val);
static uint8_t sda_get(void);
static void scl_set(uint8_t val);

/*==============================================================================
 *                              I2C底层实现
 *============================================================================*/
static void i2c_delay(void) {
    for (volatile uint32_t i = 0; i < I2C_DELAY_LOOPS; i++) __NOP();
}

static void sda_mode(uint8_t output) {
    app_io_init_t io = {RTC_SDA_AON_GPIO, output ? APP_IO_MODE_OUTPUT : APP_IO_MODE_INPUT, APP_IO_PULLUP, APP_IO_MUX};
    app_io_init(APP_IO_TYPE_AON, &io);
}

static void sda_set(uint8_t val) {
    app_io_write_pin(APP_IO_TYPE_AON, RTC_SDA_AON_GPIO, val ? APP_IO_PIN_SET : APP_IO_PIN_RESET);
}

static uint8_t sda_get(void) {
    return (app_io_read_pin(APP_IO_TYPE_AON, RTC_SDA_AON_GPIO) == APP_IO_PIN_SET) ? 1 : 0;
}

static void scl_set(uint8_t val) {
    app_io_write_pin(APP_IO_TYPE_AON, RTC_SCL_AON_GPIO, val ? APP_IO_PIN_SET : APP_IO_PIN_RESET);
}

static void i2c_start(void) {
    sda_mode(1); sda_set(1); scl_set(1); i2c_delay();
    sda_set(0); i2c_delay(); scl_set(0); i2c_delay();
}

static void i2c_stop(void) {
    sda_mode(1); scl_set(0); sda_set(0); i2c_delay();
    scl_set(1); i2c_delay(); sda_set(1); i2c_delay();
}

static void i2c_ack(void) {
    scl_set(0); sda_mode(1); sda_set(0); i2c_delay();
    scl_set(1); i2c_delay(); scl_set(0);
}

static void i2c_nack(void) {
    scl_set(0); sda_mode(1); sda_set(1); i2c_delay();
    scl_set(1); i2c_delay(); scl_set(0);
}

static bool i2c_wait_ack(void) {
    uint8_t t = 0;
    sda_mode(0); sda_set(1); i2c_delay(); scl_set(1); i2c_delay();
    while (sda_get()) { if (++t > 250) { i2c_stop(); return false; } }
    scl_set(0);
    return true;
}

static void i2c_write(uint8_t byte) {
    sda_mode(1); scl_set(0);
    for (uint8_t i = 0; i < 8; i++) {
        sda_set((byte & 0x80) ? 1 : 0);
        byte <<= 1; i2c_delay(); scl_set(1); i2c_delay(); scl_set(0); i2c_delay();
    }
}

static uint8_t i2c_read(void) {
    uint8_t byte = 0;
    sda_mode(0);
    for (uint8_t i = 0; i < 8; i++) {
        scl_set(0); i2c_delay(); scl_set(1);
        byte = (byte << 1) | sda_get(); i2c_delay();
    }
    scl_set(0);
    return byte;
}

/**
 * @brief 向BM8563写入数据
 * 
 * @param reg_addr 寄存器地址
 * @param p_data 数据指针
 * @param len 数据长度
 * 
 * @return true: 写入成功
 * @return false: 写入失败
 */
static bool bm8563_write_regs(uint8_t reg_addr, const uint8_t *p_data, uint8_t len)
{
    i2c_start();
    
    // 发送设备地址+写命令
    i2c_write((BM8563_I2C_ADDR << 1) | 0x00);
    if (!i2c_wait_ack()) {
        APP_LOG_ERROR("%s Write: No ACK for device address", TAG);
        return false;
    }
    
    // 发送寄存器地址
    i2c_write(reg_addr);
    if (!i2c_wait_ack()) {
        APP_LOG_ERROR("%s Write: No ACK for register address", TAG);
        return false;
    }
    
    // 发送数据
    for (uint8_t i = 0; i < len; i++) {
        i2c_write(p_data[i]);
        if (!i2c_wait_ack()) {
            APP_LOG_ERROR("%s Write: No ACK for data[%d]", TAG, i);
            return false;
        }
    }
    
    i2c_stop();
    return true;
}

/**
 * @brief 从BM8563读取数据
 * 
 * @param reg_addr 寄存器地址
 * @param p_data 数据缓冲区
 * @param len 读取长度
 * 
 * @return true: 读取成功
 * @return false: 读取失败
 */
static bool bm8563_read_regs(uint8_t reg_addr, uint8_t *p_data, uint8_t len)
{
    i2c_start();
    
    // 发送设备地址+写命令
    i2c_write((BM8563_I2C_ADDR << 1) | 0x00);
    if (!i2c_wait_ack()) {
        APP_LOG_ERROR("%s Read: No ACK for device address (write)", TAG);
        return false;
    }
    
    // 发送寄存器地址
    i2c_write(reg_addr);
    if (!i2c_wait_ack()) {
        APP_LOG_ERROR("%s Read: No ACK for register address", TAG);
        return false;
    }
    
    // 重新启动
    i2c_start();
    
    // 发送设备地址+读命令
    i2c_write((BM8563_I2C_ADDR << 1) | 0x01);
    if (!i2c_wait_ack()) {
        APP_LOG_ERROR("%s Read: No ACK for device address (read)", TAG);
        return false;
    }
    
    // 读取数据
    for (uint8_t i = 0; i < len; i++) {
        p_data[i] = i2c_read();
        if (i < len - 1) {
            i2c_ack();   // 未读完，发送ACK继续读取
        } else {
            i2c_nack();  // 最后一个字节，发送NACK
        }
    }
    
    i2c_stop();
    return true;
}

/*
 * GLOBAL FUNCTIONS
 *****************************************************************************************
 */

bool bm8563_init(void)
{
    // 初始化SCL引脚（输出模式，上拉）
    app_io_init_t io_init = {
        .pin  = RTC_SCL_AON_GPIO,
        .mode = APP_IO_MODE_OUTPUT,
        .pull = APP_IO_PULLUP,
        .mux  = APP_IO_MUX
    };
    app_io_init(APP_IO_TYPE_AON, &io_init);
    
    // 初始化SDA引脚（输出模式，上拉）
    io_init.pin = RTC_SDA_AON_GPIO;
    app_io_init(APP_IO_TYPE_AON, &io_init);
    
    // 初始化中断引脚（输入模式，可选）
    io_init.pin  = RTC_INT_AON_GPIO;
    io_init.mode = APP_IO_MODE_INPUT;
    app_io_init(APP_IO_TYPE_AON, &io_init);
    
    // 设置初始状态
    scl_set(1);
    sda_set(1);
    i2c_delay();
    
    // 复位BM8563
    uint8_t ctrl_status1 = 0x00;  // 清除TESTC位，正常工作模式
    if (!bm8563_write_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        APP_LOG_ERROR("%s Failed to reset BM8563", TAG);
        return false;
    }
    
    // 启动RTC
    if (!bm8563_start()) {
        APP_LOG_ERROR("%s Failed to start BM8563", TAG);
        return false;
    }
    
    APP_LOG_INFO("%s BM8563 RTC initialized successfully", TAG);
    return true;
}

bool bm8563_read_time(rtc_time_t *p_time)
{
    if (p_time == NULL) {
        return false;
    }
    
    uint8_t time_data[7];
    
    // 从寄存器读取时间数据
    if (!bm8563_read_regs(BM8563_REG_SECOND, time_data, 7)) {
        APP_LOG_ERROR("%s Failed to read time registers", TAG);
        return false;
    }
    
    // BCD转十进制并保存
    p_time->second  = BCD_TO_DEC(time_data[0] & 0x7F);  // 去除VL位
    p_time->minute  = BCD_TO_DEC(time_data[1] & 0x7F);
    p_time->hour    = BCD_TO_DEC(time_data[2] & 0x3F);
    p_time->day     = BCD_TO_DEC(time_data[3] & 0x3F);
    p_time->weekday = BCD_TO_DEC(time_data[4] & 0x07);
    p_time->month   = BCD_TO_DEC(time_data[5] & 0x1F);  // 去除世纪位
    p_time->year    = BCD_TO_DEC(time_data[6]) + 2000;  // BM8563年份基准是2000年
    
    return true;
}

bool bm8563_set_time(const rtc_time_t *p_time)
{
    if (p_time == NULL) {
        return false;
    }
    
    uint8_t time_data[7];
    
    // 十进制转BCD
    time_data[0] = DEC_TO_BCD(p_time->second);
    time_data[1] = DEC_TO_BCD(p_time->minute);
    time_data[2] = DEC_TO_BCD(p_time->hour);
    time_data[3] = DEC_TO_BCD(p_time->day);
    time_data[4] = DEC_TO_BCD(p_time->weekday);
    time_data[5] = DEC_TO_BCD(p_time->month);
    time_data[6] = DEC_TO_BCD(p_time->year - 2000);  // 转换为相对2000年的偏移
    
    // 写入时间寄存器
    if (!bm8563_write_regs(BM8563_REG_SECOND, time_data, 7)) {
        APP_LOG_ERROR("%s Failed to write time registers", TAG);
        return false;
    }
    
    APP_LOG_INFO("%s Time set: %04d-%02d-%02d %02d:%02d:%02d", 
                 TAG, p_time->year, p_time->month, p_time->day,
                 p_time->hour, p_time->minute, p_time->second);
    
    return true;
}

bool bm8563_get_time_string(char *time_str)
{
    if (time_str == NULL) {
        return false;
    }
    
    rtc_time_t time;
    
    if (!bm8563_read_time(&time)) {
        return false;
    }
    
    // 格式化为 "YYYYMMDDHHmmss"
    snprintf(time_str, RTC_TIME_STRING_LEN, "%04d%02d%02d%02d%02d%02d",
             time.year, time.month, time.day, time.hour, time.minute, time.second);
    
    return true;
}

bool bm8563_is_running(void)
{
    uint8_t ctrl_status1;
    
    if (!bm8563_read_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        return false;
    }
    
    // 检查STOP位（bit5），如果为0则RTC正在运行
    return ((ctrl_status1 & 0x20) == 0);
}

bool bm8563_start(void)
{
    uint8_t ctrl_status1;
    
    // 读取当前控制寄存器
    if (!bm8563_read_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        return false;
    }
    
    // 清除STOP位（bit5）启动RTC
    ctrl_status1 &= ~0x20;
    
    if (!bm8563_write_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        return false;
    }
    
    APP_LOG_INFO("%s RTC started", TAG);
    return true;
}

bool bm8563_stop(void)
{
    uint8_t ctrl_status1;
    
    // 读取当前控制寄存器
    if (!bm8563_read_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        return false;
    }
    
    // 设置STOP位（bit5）停止RTC
    ctrl_status1 |= 0x20;
    
    if (!bm8563_write_regs(BM8563_REG_CTRL_STATUS1, &ctrl_status1, 1)) {
        return false;
    }
    
    APP_LOG_INFO("%s RTC stopped", TAG);
    return true;
}

/**
 *****************************************************************************************
 * @brief 计算星期几（Zeller公式）
 *
 * @param[in] year  年份 (2000-2099)
 * @param[in] month 月份 (1-12)
 * @param[in] day   日期 (1-31)
 *
 * @return 星期几 (0=周日, 1=周一, ..., 6=周六)
 *****************************************************************************************
 */
static uint8_t calculate_weekday(uint16_t year, uint8_t month, uint8_t day)
{
    // Zeller公式计算星期
    // 注意：1月和2月要当作上一年的13月和14月来计算
    if (month < 3) {
        month += 12;
        year--;
    }
    
    int c = year / 100;
    int y = year % 100;
    int w = (c / 4 - 2 * c + y + y / 4 + 13 * (month + 1) / 5 + day - 1) % 7;
    
    // 转换为0=周日格式
    return (w + 7) % 7;
}

/**
 *****************************************************************************************
 * @brief 从4G网络时间字符串设置RTC时间
 *
 * @details 解析4G模块返回的时间格式并设置到RTC
 *          支持的格式: "2024/11/14,16:42:35" 或 "24/11/14,16:42:35"
 *
 * @param[in] network_time 4G网络时间字符串
 *
 * @return true: 设置成功, false: 设置失败
 *****************************************************************************************
 */
bool bm8563_set_time_from_network(const char *network_time)
{
    if (network_time == NULL) {
        APP_LOG_ERROR("%s Network time string is NULL", TAG);
        return false;
    }
    
    APP_LOG_INFO("%s Parsing network time: %s", TAG, network_time);
    
    // 跳过前导空格和双引号（DTU返回格式: +CCLK: "25/12/03,16:30:00+32"）
    const char *time_str = network_time;
    while (*time_str == ' ' || *time_str == '"') {
        time_str++;
    }
    
    APP_LOG_DEBUG("%s Time string after trim: %s", TAG, time_str);
    
    rtc_time_t time = {0};
    int year, month, day, hour, minute, second;
    
    // 尝试解析完整年份格式: "2024/11/14,16:42:35" 或带时区 "25/12/03,16:30:00+32"
    if (sscanf(time_str, "%d/%d/%d,%d:%d:%d", 
               &year, &month, &day, &hour, &minute, &second) == 6) {
        // 完整年份格式
        if (year < 100) {
            year += 2000;  // 如果是两位数年份，加上2000
        }
    }
    // 尝试不带秒的格式: "2024/11/14,16:42"
    else if (sscanf(time_str, "%d/%d/%d,%d:%d", 
                    &year, &month, &day, &hour, &minute) == 5) {
        second = 0;  // 秒数默认为0
        if (year < 100) {
            year += 2000;
        }
    }
    else {
        APP_LOG_ERROR("%s Failed to parse network time format", TAG);
        return false;
    }
    
    // 验证时间范围
    if (year < 2000 || year > 2099 ||
        month < 1 || month > 12 ||
        day < 1 || day > 31 ||
        hour < 0 || hour > 23 ||
        minute < 0 || minute > 59 ||
        second < 0 || second > 59) {
        APP_LOG_ERROR("%s Invalid time values: %04d/%02d/%02d %02d:%02d:%02d", 
                     TAG, year, month, day, hour, minute, second);
        return false;
    }
    
    APP_LOG_INFO("%s Time validation passed: %04d/%02d/%02d %02d:%02d:%02d", 
                TAG, year, month, day, hour, minute, second);
    
    // 填充时间结构体
    time.year = year;
    time.month = month;
    time.day = day;
    time.hour = hour;
    time.minute = minute;
    time.second = second;
    time.weekday = calculate_weekday(year, month, day);
    
    APP_LOG_INFO("%s Parsed time: %04d/%02d/%02d(%d) %02d:%02d:%02d", 
                TAG, time.year, time.month, time.day, time.weekday,
                time.hour, time.minute, time.second);
    
    // 设置RTC时间
    if (!bm8563_set_time(&time)) {
        APP_LOG_ERROR("%s Failed to set RTC time", TAG);
        return false;
    }
    
    APP_LOG_INFO("%s Successfully set RTC time from network", TAG);
    return true;
}

