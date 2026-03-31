/**
 *****************************************************************************************
 *
 * @file soft_i2c.c
 *
 * @brief Software I2C driver implementation using GPIO bit-banging
 *        GPIO_9 = SCL, GPIO_10 = SDA for WF5803F pressure sensor
 *
 * @note  Ported from test2.0 water level detection project
 *        Adapted for test1.0.1 low-power requirements
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "soft_i2c.h"
#include "app_io.h"
#include "app_log.h"
#include "grx_sys.h"
#include "gr55xx_delay.h"

/*
 * DEFINES
 *****************************************************************************************
 */
#define SCL_PIN     APP_IO_PIN_9   // I2C时钟线
#define SDA_PIN     APP_IO_PIN_10  // I2C数据线
#define I2C_DELAY_US    5  // 5us delay for ~100kHz I2C clock，太短已改为5ms。

// GPIO控制宏
#define SCL_HIGH()  app_io_write_pin(APP_IO_TYPE_NORMAL, SCL_PIN, APP_IO_PIN_SET)
#define SCL_LOW()   app_io_write_pin(APP_IO_TYPE_NORMAL, SCL_PIN, APP_IO_PIN_RESET)
#define SDA_HIGH()  app_io_write_pin(APP_IO_TYPE_NORMAL, SDA_PIN, APP_IO_PIN_SET)
#define SDA_LOW()   app_io_write_pin(APP_IO_TYPE_NORMAL, SDA_PIN, APP_IO_PIN_RESET)
#define SDA_READ()  app_io_read_pin(APP_IO_TYPE_NORMAL, SDA_PIN)

/*
 * LOCAL VARIABLES
 *****************************************************************************************
 */
static bool s_i2c_initialized = false;

/*
 * LOCAL FUNCTION IMPLEMENTATIONS
 *****************************************************************************************
 */

/**
 * @brief 配置SDA为输出模式
 */
static void sda_output_mode(void)
{
    app_io_init_t io_init = {
        .pin  = SDA_PIN,
        .mode = APP_IO_MODE_OUTPUT,
        .pull = APP_IO_PULLUP,
        .mux  = APP_IO_MUX_7
    };
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
}

/**
 * @brief 配置SDA为输入模式
 */
static void sda_input_mode(void)
{
    app_io_init_t io_init = {
        .pin  = SDA_PIN,
        .mode = APP_IO_MODE_INPUT,
        .pull = APP_IO_PULLUP,
        .mux  = APP_IO_MUX_7
    };
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
}

/*
 * PUBLIC FUNCTION IMPLEMENTATIONS
 *****************************************************************************************
 */

void soft_i2c_init(void)
{
    if (s_i2c_initialized) {
        return;
    }
    
    app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
    
    // SCL引脚配置为GPIO输出模式
    io_init.pin  = SCL_PIN;
    io_init.mode = APP_IO_MODE_OUTPUT;
    io_init.pull = APP_IO_PULLUP;
    io_init.mux  = APP_IO_MUX_7;  // GPIO模式
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
    
    // SDA引脚配置为GPIO输出模式（需要双向）
    io_init.pin  = SDA_PIN;
    io_init.mode = APP_IO_MODE_OUTPUT;
    io_init.pull = APP_IO_PULLUP;
    io_init.mux  = APP_IO_MUX_7;  // GPIO模式
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
    
    // 初始化为高电平（I2C空闲状态）
    SCL_HIGH();
    SDA_HIGH();
    delay_ms(5);  // 等待GPIO稳定，避免I2C通信失败（从5us改为5ms）
    
    s_i2c_initialized = true;
    APP_LOG_INFO("Soft I2C initialized on GPIO9(SCL), GPIO10(SDA)");
}

void soft_i2c_deinit(void)
{
    if (!s_i2c_initialized) {
        return;
    }
    
    // 设置为低功耗状态（输入上拉，降低漏电流）
    app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
    io_init.mode = APP_IO_MODE_INPUT;
    io_init.pull = APP_IO_PULLDOWN;  // 下拉降低功耗
    io_init.mux  = APP_IO_MUX_7;
    
    io_init.pin = SCL_PIN;
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
    
    io_init.pin = SDA_PIN;
    app_io_init(APP_IO_TYPE_NORMAL, &io_init);
    
    s_i2c_initialized = false;
    APP_LOG_DEBUG("Soft I2C deinitialized for low-power mode");
}

/**
 * @brief I2C总线复位 - 发送9个时钟脉冲释放被拉低的SDA线
 * 
 * 当I2C通信失败且从设备拉低SDA线时，主设备可通过发送额外时钟脉冲
 * 释放SDA线，然后发送STOP信号恢复总线正常状态。
 */
void soft_i2c_bus_reset(void)
{
    // 确保SDA为输出模式
    sda_output_mode();
    
    // 发送9个时钟脉冲，让从设备释放SDA线
    for (uint8_t i = 0; i < 9; i++) {
        SCL_LOW();
        delay_us(I2C_DELAY_US);
        SCL_HIGH();
        delay_us(I2C_DELAY_US);
    }
    
    // 发送STOP信号
    SDA_LOW();
    delay_us(I2C_DELAY_US);
    SDA_HIGH();
    
    APP_LOG_DEBUG("Soft I2C bus reset completed");
}

bool soft_i2c_start(void)
{
    // START信号前，确保SDA为输出模式
    sda_output_mode();
    
    SDA_HIGH();
    delay_us(I2C_DELAY_US);
    SCL_HIGH();
    delay_us(I2C_DELAY_US);
    
    // 发送起始信号：SCL高电平期间，SDA下降沿
    SDA_LOW();
    delay_us(I2C_DELAY_US);
    SCL_LOW();
    delay_us(I2C_DELAY_US);
    
    return true;
}

void soft_i2c_stop(void)
{
    // STOP信号前，确保SDA为输出模式
    sda_output_mode();
    
    // 发送停止信号：SCL高电平期间，SDA上升沿
    SDA_LOW();
    delay_us(I2C_DELAY_US);
    SCL_HIGH();
    delay_us(I2C_DELAY_US);
    SDA_HIGH();
    delay_us(I2C_DELAY_US);
}

bool soft_i2c_write_byte(uint8_t data)
{
    // 发送数据前，确保SDA为输出模式
    sda_output_mode();
    
    // 发送8位数据（MSB first）
    for (uint8_t i = 0; i < 8; i++) {
        if (data & 0x80) {
            SDA_HIGH();
        } else {
            SDA_LOW();
        }
        delay_us(I2C_DELAY_US);
        
        // 时钟脉冲
        SCL_HIGH();
        delay_us(I2C_DELAY_US);
        SCL_LOW();
        delay_us(I2C_DELAY_US);
        
        data <<= 1;
    }
    
    // 读取ACK前的正确时序：
    // 1. 先释放SDA（输出模式下设为高）
    SDA_HIGH();
    delay_us(I2C_DELAY_US);
    
    // 2. 再切换SDA为输入模式（让从设备控制SDA）
    sda_input_mode();
    delay_us(I2C_DELAY_US);
    
    // 3. 拉高SCL，读取ACK
    SCL_HIGH();
    delay_us(I2C_DELAY_US);
    
    bool ack = (SDA_READ() == APP_IO_PIN_RESET);
    
    SCL_LOW();
    delay_us(I2C_DELAY_US);
    
    return ack;
}

uint8_t soft_i2c_read_byte(bool ack)
{
    uint8_t data = 0;
    
    // 读取数据前的正确时序：
    // 1. 先确保SDA为输入模式
    sda_input_mode();
    delay_us(I2C_DELAY_US);
    
    // 读取8位数据（MSB first）
    for (uint8_t i = 0; i < 8; i++) {
        data <<= 1;
        
        SCL_HIGH();
        delay_us(I2C_DELAY_US);
        
        if (SDA_READ() == APP_IO_PIN_SET) {
            data |= 0x01;
        }
        
        SCL_LOW();
        delay_us(I2C_DELAY_US);
    }
    
    // 发送ACK/NACK前，切换SDA为输出模式
    sda_output_mode();
    if (ack) {
        SDA_LOW();   // ACK
    } else {
        SDA_HIGH();  // NACK
    }
    delay_us(I2C_DELAY_US);
    
    SCL_HIGH();
    delay_us(I2C_DELAY_US);
    SCL_LOW();
    delay_us(I2C_DELAY_US);
    
    SDA_HIGH();  // 释放SDA
    
    return data;
}

bool soft_i2c_write_reg(uint8_t dev_addr, uint8_t reg_addr, uint8_t value)
{
    if (!soft_i2c_start()) {
        return false;
    }
    
    // 发送设备地址（写操作）
    if (!soft_i2c_write_byte(dev_addr << 1)) {
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK from device 0x%02X", dev_addr);
        return false;
    }
    
    // 发送寄存器地址
    if (!soft_i2c_write_byte(reg_addr)) {
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK for register 0x%02X", reg_addr);
        return false;
    }
    
    // 发送数据
    if (!soft_i2c_write_byte(value)) {
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK for data");
        return false;
    }
    
    soft_i2c_stop();
    return true;
}

bool soft_i2c_read_reg(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buffer, uint16_t len)
{
    if (!buffer || len == 0) {
        return false;
    }
    
    // 第一步：写寄存器地址
    if (!soft_i2c_start()) {
        return false;
    }
    
    if (!soft_i2c_write_byte(dev_addr << 1)) {
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK from device 0x%02X (write phase)", dev_addr);
        return false;
    }
    
    if (!soft_i2c_write_byte(reg_addr)) {
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK for register 0x%02X", reg_addr);
        return false;
    }
    
    // 第二步：重新开始，读取数据
    if (!soft_i2c_start()) {
        return false;
    }
    
    if (!soft_i2c_write_byte((dev_addr << 1) | 0x01)) {  // 读地址
        soft_i2c_stop();
        APP_LOG_ERROR("I2C: No ACK from device 0x%02X (read phase)", dev_addr);
        return false;
    }
    
    // 读取数据
    for (uint16_t i = 0; i < len; i++) {
        buffer[i] = soft_i2c_read_byte(i < (len - 1));  // 最后一字节发送NACK
    }
    
    soft_i2c_stop();
    return true;
}
