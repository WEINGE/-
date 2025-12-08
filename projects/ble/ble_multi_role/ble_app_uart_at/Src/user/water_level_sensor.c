/**
 *****************************************************************************************
 *
 * @file water_level_sensor.c
 *
 * @brief MER-MCP1081-22-150 电子水尺液位传感模组驱动实现
 *
 * @details 通信协议：Modbus-RTU
 *          - 波特率：9600bps
 *          - 数据位：8位
 *          - 停止位：1位
 *          - 校验位：无
 *          - CRC：CRC-16/MODBUS（低字节在前）
 *
 * @attention
 *  Copyright (c) 2025 GOODIX
 *  All rights reserved.
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "water_level_sensor.h"
#include "app_uart.h"
#include "app_log.h"
#include "board_SK.h"
#include "grx_sys.h"
#include <string.h>

/*
 * LOCAL DEFINITIONS
 *****************************************************************************************
 */
#define WLS_UART_ID                     APP_UART_ID_0   /**< 使用UART0 */

/*
 * LOCAL VARIABLES
 *****************************************************************************************
 */
static bool s_wls_initialized = false;                          /**< 初始化标志 */
static uint8_t s_tx_buffer[WLS_TX_BUFFER_SIZE];                /**< 发送缓冲区 */
static uint8_t s_rx_buffer[WLS_RX_BUFFER_SIZE];                /**< 接收缓冲区 */
static volatile bool s_tx_done = false;                         /**< 发送完成标志 */
static volatile bool s_rx_done = false;                         /**< 接收完成标志 */
static volatile uint16_t s_rx_len = 0;                          /**< 接收数据长度 */
static uint8_t s_ring_buffer[WLS_RX_BUFFER_SIZE];              /**< 环形缓冲区 */

static app_uart_params_t s_wls_uart_params = {
    .id = APP_UART_ID_0,
    .pin_cfg = {
        .tx = {
            .type = APP_UART_TX_IO_TYPE,
            .mux  = APP_UART_TX_PINMUX,
            .pin  = APP_UART_TX_PIN,
            .pull = APP_IO_PULLUP,
        },
        .rx = {
            .type = APP_UART_RX_IO_TYPE,
            .mux  = APP_UART_RX_PINMUX,
            .pin  = APP_UART_RX_PIN,
            .pull = APP_IO_PULLUP,
        },
    },
    .init = {
        .baud_rate       = WLS_UART_BAUD_RATE,
        .data_bits       = UART_DATABITS_8,
        .stop_bits       = UART_STOPBITS_1,
        .parity          = UART_PARITY_NONE,
        .hw_flow_ctrl    = UART_HWCONTROL_NONE,
        .rx_timeout_mode = UART_RECEIVER_TIMEOUT_ENABLE,
    },
};

/*
 * LOCAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
static void wls_uart_callback(app_uart_evt_t *p_evt);
static bool wls_send_request(const uint8_t *p_data, uint16_t len);
static bool wls_receive_response(uint8_t *p_data, uint16_t *p_len, uint32_t timeout_ms);
static bool wls_read_registers(uint16_t start_addr, uint16_t num_regs, uint8_t *p_data, uint16_t *p_len);
static bool wls_write_register(uint16_t reg_addr, uint16_t value);
static bool wls_verify_crc(const uint8_t *p_data, uint16_t len);

/*
 * CRC-16/MODBUS 查找表
 *****************************************************************************************
 */
static const uint16_t s_crc16_table[256] = {
    0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
    0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
    0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
    0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
    0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
    0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
    0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
    0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
    0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
    0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
    0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
    0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
    0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
    0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
    0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
    0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
    0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
    0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
    0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
    0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
    0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
    0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
    0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
    0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
    0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
    0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
    0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
    0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
    0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
    0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
    0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
    0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
};

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief UART事件回调函数
 *****************************************************************************************
 */
static void wls_uart_callback(app_uart_evt_t *p_evt)
{
    if (p_evt->type == APP_UART_EVT_TX_CPLT)
    {
        s_tx_done = true;
    }
    else if (p_evt->type == APP_UART_EVT_RX_DATA)
    {
        s_rx_len = p_evt->data.size;
        s_rx_done = true;
    }
    else if (p_evt->type == APP_UART_EVT_ERROR)
    {
        s_tx_done = true;
        s_rx_done = true;
    }
}

/**
 *****************************************************************************************
 * @brief 计算CRC-16/MODBUS
 *****************************************************************************************
 */
uint16_t water_level_sensor_calc_crc16(const uint8_t *p_data, uint16_t length)
{
    uint16_t crc = 0xFFFF;
    
    while (length--)
    {
        uint8_t index = (crc ^ *p_data++) & 0xFF;
        crc = (crc >> 8) ^ s_crc16_table[index];
    }
    
    return crc;
}

/**
 *****************************************************************************************
 * @brief 验证响应CRC
 *****************************************************************************************
 */
static bool wls_verify_crc(const uint8_t *p_data, uint16_t len)
{
    if (len < 4) return false;
    
    uint16_t calc_crc = water_level_sensor_calc_crc16(p_data, len - 2);
    uint16_t recv_crc = (uint16_t)(p_data[len - 1] << 8) | p_data[len - 2];
    
    return (calc_crc == recv_crc);
}

/**
 *****************************************************************************************
 * @brief 发送Modbus请求
 *****************************************************************************************
 */
static bool wls_send_request(const uint8_t *p_data, uint16_t len)
{
    if (!s_wls_initialized || p_data == NULL || len == 0)
    {
        return false;
    }
    
    s_tx_done = false;
    
    uint16_t ret = app_uart_transmit_async(WLS_UART_ID, (uint8_t*)p_data, len);
    if (ret != APP_DRV_SUCCESS)
    {
        return false;
    }
    
    // 等待发送完成
    uint32_t timeout = WLS_TX_TIMEOUT_MS;
    while (!s_tx_done && timeout > 0)
    {
        sys_delay_ms(1);
        timeout--;
    }
    
    return s_tx_done;
}

/**
 *****************************************************************************************
 * @brief 接收Modbus响应
 *****************************************************************************************
 */
static bool wls_receive_response(uint8_t *p_data, uint16_t *p_len, uint32_t timeout_ms)
{
    if (!s_wls_initialized || p_data == NULL || p_len == NULL)
    {
        return false;
    }
    
    s_rx_done = false;
    s_rx_len = 0;
    
    // 启动异步接收（必须在等待响应延时之前启动，否则会丢失数据）
    uint16_t ret = app_uart_receive_async(WLS_UART_ID, s_rx_buffer, WLS_RX_BUFFER_SIZE);
    if (ret != APP_DRV_SUCCESS)
    {
        return false;
    }
    
    // 等待传感器响应延时（至少300ms）
    sys_delay_ms(WLS_RESPONSE_DELAY_MS);
    
    // 等待接收完成（传感器响应后还需要一些时间接收完整帧）
    uint32_t wait_time = timeout_ms;
    while (!s_rx_done && wait_time > 0)
    {
        sys_delay_ms(1);
        wait_time--;
    }
    
    if (!s_rx_done || s_rx_len == 0)
    {
        return false;
    }
    
    // 复制接收数据
    memcpy(p_data, s_rx_buffer, s_rx_len);
    *p_len = s_rx_len;
    
    return true;
}

/**
 *****************************************************************************************
 * @brief 读取多个寄存器
 *****************************************************************************************
 */
static bool wls_read_registers(uint16_t start_addr, uint16_t num_regs, uint8_t *p_data, uint16_t *p_len)
{
    // 构建读取请求帧
    // 地址码 | 功能码 | 起始地址高 | 起始地址低 | 寄存器数高 | 寄存器数低 | CRC低 | CRC高
    s_tx_buffer[0] = WLS_MODBUS_SLAVE_ADDR;
    s_tx_buffer[1] = WLS_MODBUS_FUNC_READ;
    s_tx_buffer[2] = (start_addr >> 8) & 0xFF;
    s_tx_buffer[3] = start_addr & 0xFF;
    s_tx_buffer[4] = (num_regs >> 8) & 0xFF;
    s_tx_buffer[5] = num_regs & 0xFF;
    
    // 计算CRC（低字节在前）
    uint16_t crc = water_level_sensor_calc_crc16(s_tx_buffer, 6);
    s_tx_buffer[6] = crc & 0xFF;        // CRC低字节
    s_tx_buffer[7] = (crc >> 8) & 0xFF; // CRC高字节
    
    // ✅ 关键：在发送之前先启动异步接收，避免丢失响应数据
    s_rx_done = false;
    s_rx_len = 0;
    uint16_t ret = app_uart_receive_async(WLS_UART_ID, s_rx_buffer, WLS_RX_BUFFER_SIZE);
    if (ret != APP_DRV_SUCCESS)
    {
        APP_LOG_ERROR("[WLS] Start receive failed");
        return false;
    }
    
    // 发送请求
    if (!wls_send_request(s_tx_buffer, 8))
    {
        APP_LOG_ERROR("[WLS] Send request failed");
        return false;
    }
    
    // 等待传感器响应（至少300ms）
    sys_delay_ms(WLS_RESPONSE_DELAY_MS);
    
    // 等待接收完成
    uint32_t wait_time = WLS_RX_TIMEOUT_MS;
    while (!s_rx_done && wait_time > 0)
    {
        sys_delay_ms(1);
        wait_time--;
    }
    
    if (!s_rx_done || s_rx_len == 0)
    {
        APP_LOG_ERROR("[WLS] Receive response timeout");
        return false;
    }
    
    // 复制接收数据
    memcpy(p_data, s_rx_buffer, s_rx_len);
    *p_len = s_rx_len;
    
    // 验证响应
    // 应答帧格式：地址码 | 功能码 | 有效字节数 | 数据... | CRC低 | CRC高
    if (*p_len < 5)
    {
        APP_LOG_ERROR("[WLS] Response too short: %d", *p_len);
        return false;
    }
    
    if (p_data[0] != WLS_MODBUS_SLAVE_ADDR || p_data[1] != WLS_MODBUS_FUNC_READ)
    {
        APP_LOG_ERROR("[WLS] Invalid response header: %02X %02X", p_data[0], p_data[1]);
        return false;
    }
    
    // 验证CRC
    if (!wls_verify_crc(p_data, *p_len))
    {
        APP_LOG_ERROR("[WLS] CRC verification failed");
        return false;
    }
    
    return true;
}

/**
 *****************************************************************************************
 * @brief 写入单个寄存器
 *****************************************************************************************
 */
static bool wls_write_register(uint16_t reg_addr, uint16_t value)
{
    // 构建写入请求帧
    // 地址码 | 功能码 | 寄存器地址高 | 寄存器地址低 | 写入值高 | 写入值低 | CRC低 | CRC高
    s_tx_buffer[0] = WLS_MODBUS_SLAVE_ADDR;
    s_tx_buffer[1] = WLS_MODBUS_FUNC_WRITE;
    s_tx_buffer[2] = (reg_addr >> 8) & 0xFF;
    s_tx_buffer[3] = reg_addr & 0xFF;
    s_tx_buffer[4] = (value >> 8) & 0xFF;
    s_tx_buffer[5] = value & 0xFF;
    
    // 计算CRC（低字节在前）
    uint16_t crc = water_level_sensor_calc_crc16(s_tx_buffer, 6);
    s_tx_buffer[6] = crc & 0xFF;
    s_tx_buffer[7] = (crc >> 8) & 0xFF;
    
    // ✅ 关键：在发送之前先启动异步接收
    s_rx_done = false;
    s_rx_len = 0;
    uint16_t ret = app_uart_receive_async(WLS_UART_ID, s_rx_buffer, WLS_RX_BUFFER_SIZE);
    if (ret != APP_DRV_SUCCESS)
    {
        return false;
    }
    
    // 发送请求
    if (!wls_send_request(s_tx_buffer, 8))
    {
        return false;
    }
    
    // 等待传感器响应（至少300ms）
    sys_delay_ms(WLS_RESPONSE_DELAY_MS);
    
    // 等待接收完成
    uint32_t wait_time = WLS_RX_TIMEOUT_MS;
    while (!s_rx_done && wait_time > 0)
    {
        sys_delay_ms(1);
        wait_time--;
    }
    
    if (!s_rx_done || s_rx_len == 0)
    {
        return false;
    }
    
    // 验证响应（写入响应与请求帧相同）
    if (s_rx_len < 8)
    {
        return false;
    }
    
    if (!wls_verify_crc(s_rx_buffer, s_rx_len))
    {
        return false;
    }
    
    return true;
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

bool water_level_sensor_init(void)
{
    if (s_wls_initialized)
    {
        return true;
    }
    
    app_uart_tx_buf_t uart_buffer = {
        .tx_buf = s_ring_buffer,
        .tx_buf_size = sizeof(s_ring_buffer)
    };
    
    // 先反初始化确保干净配置
    app_uart_deinit(WLS_UART_ID);
    
    // 初始化UART0
    uint16_t ret = app_uart_init(&s_wls_uart_params, wls_uart_callback, &uart_buffer);
    if (ret != APP_DRV_SUCCESS)
    {
        APP_LOG_ERROR("[WLS] UART init failed: %d", ret);
        return false;
    }
    
    s_wls_initialized = true;
    APP_LOG_INFO("[WLS] MER-MCP1081-22-150 initialized (UART0@9600)");
    
    // 测试通信 - 尝试读取液位档位
    sys_delay_ms(100);
    uint8_t level = water_level_sensor_get_level_grade();
    if (level != 0xFF)
    {
        APP_LOG_INFO("[WLS] Communication OK, level grade: %d", level);
    }
    else
    {
        APP_LOG_WARNING("[WLS] Communication test failed, sensor may not be connected");
    }
    
    return true;
}

void water_level_sensor_deinit(void)
{
    if (!s_wls_initialized)
    {
        return;
    }
    
    app_uart_deinit(WLS_UART_ID);
    s_wls_initialized = false;
    
    APP_LOG_INFO("[WLS] Deinitialized");
}

bool water_level_sensor_read_basic(water_level_data_t *p_data)
{
    if (!s_wls_initialized || p_data == NULL)
    {
        return false;
    }
    
    memset(p_data, 0, sizeof(water_level_data_t));
    
    // 读取液位档位和温度（寄存器0x0004和0x0007）
    // 先读取档位
    uint8_t response[32];
    uint16_t resp_len;
    
    // 读取液位档位 (0x0004, 1个寄存器)
    if (wls_read_registers(WLS_REG_LEVEL_GRADE, 1, response, &resp_len))
    {
        // 数据在第3和第4字节（16位，高字节在前）
        if (resp_len >= 5 && response[2] >= 2)
        {
            p_data->level_grade = response[4]; // 低字节即为档位值
        }
    }
    
    // 读取温度 (0x0007, 1个寄存器)
    if (wls_read_registers(WLS_REG_TEMPERATURE, 1, response, &resp_len))
    {
        if (resp_len >= 5 && response[2] >= 2)
        {
            // 温度为有符号整数，扩大10倍
            p_data->temperature_raw = (int16_t)((response[3] << 8) | response[4]);
            p_data->temperature_c = (float)p_data->temperature_raw / 10.0f;
        }
    }
    
    // 更新时间戳
    static uint32_t counter = 0;
    p_data->timestamp = counter++;
    p_data->is_valid = true;
    
    return true;
}

uint8_t water_level_sensor_get_level_grade(void)
{
    if (!s_wls_initialized)
    {
        return 0xFF;
    }
    
    uint8_t response[16];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_LEVEL_GRADE, 1, response, &resp_len))
    {
        return 0xFF;
    }
    
    if (resp_len >= 5 && response[2] >= 2)
    {
        return response[4];  // 档位值在低字节
    }
    
    return 0xFF;
}

float water_level_sensor_get_temperature(void)
{
    if (!s_wls_initialized)
    {
        return -999.0f;
    }
    
    uint8_t response[16];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_TEMPERATURE, 1, response, &resp_len))
    {
        return -999.0f;
    }
    
    if (resp_len >= 5 && response[2] >= 2)
    {
        int16_t temp_raw = (int16_t)((response[3] << 8) | response[4]);
        return (float)temp_raw / 10.0f;
    }
    
    return -999.0f;
}

bool water_level_sensor_read_capacitance(water_level_cap_data_t *p_cap)
{
    if (!s_wls_initialized || p_cap == NULL)
    {
        return false;
    }
    
    memset(p_cap, 0, sizeof(water_level_cap_data_t));
    
    // 读取电容C0~C6 (0x0008 ~ 0x000E, 共7个寄存器)
    uint8_t response[32];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_C0, 7, response, &resp_len))
    {
        return false;
    }
    
    // 响应格式：地址码 | 功能码 | 有效字节数(14) | C0高 | C0低 | C1高 | C1低 | ... | CRC低 | CRC高
    if (resp_len >= 17 && response[2] >= 14)
    {
        for (int i = 0; i < 7; i++)
        {
            p_cap->c[i] = (uint16_t)((response[3 + i*2] << 8) | response[4 + i*2]);
            p_cap->c_pf[i] = (float)p_cap->c[i] / 1000.0f;
        }
        p_cap->is_valid = true;
        return true;
    }
    
    p_cap->is_valid = false;
    return false;
}

bool water_level_sensor_read_frequency(water_level_freq_data_t *p_freq)
{
    if (!s_wls_initialized || p_freq == NULL)
    {
        return false;
    }
    
    memset(p_freq, 0, sizeof(water_level_freq_data_t));
    
    // 读取FRE和F0~F6 (0x000F ~ 0x0016, 共8个寄存器)
    uint8_t response[32];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_FRE, 8, response, &resp_len))
    {
        return false;
    }
    
    if (resp_len >= 19 && response[2] >= 16)
    {
        // FRE
        p_freq->fre = (uint16_t)((response[3] << 8) | response[4]);
        p_freq->fre_mhz = (float)p_freq->fre / 1000.0f;
        
        // F0~F6
        for (int i = 0; i < 7; i++)
        {
            p_freq->f[i] = (uint16_t)((response[5 + i*2] << 8) | response[6 + i*2]);
            p_freq->f_mhz[i] = (float)p_freq->f[i] / 1000.0f;
        }
        return true;
    }
    
    return false;
}

bool water_level_sensor_read_count(water_level_count_data_t *p_count)
{
    if (!s_wls_initialized || p_count == NULL)
    {
        return false;
    }
    
    memset(p_count, 0, sizeof(water_level_count_data_t));
    
    // 读取COUNT10和COUNT0~COUNT6 (0x0017 ~ 0x001E, 共8个寄存器)
    uint8_t response[32];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_COUNT10, 8, response, &resp_len))
    {
        return false;
    }
    
    if (resp_len >= 19 && response[2] >= 16)
    {
        // COUNT10
        p_count->count10 = (uint16_t)((response[3] << 8) | response[4]);
        
        // COUNT0~COUNT6
        for (int i = 0; i < 7; i++)
        {
            p_count->count[i] = (uint16_t)((response[5 + i*2] << 8) | response[6 + i*2]);
        }
        return true;
    }
    
    return false;
}

bool water_level_sensor_read_full(water_level_full_data_t *p_full)
{
    if (!s_wls_initialized || p_full == NULL)
    {
        return false;
    }
    
    memset(p_full, 0, sizeof(water_level_full_data_t));
    p_full->error_code = WLS_ERR_NONE;
    
    // 读取基础数据
    if (!water_level_sensor_read_basic(&p_full->basic))
    {
        p_full->error_code = WLS_ERR_RX_TIMEOUT;
    }
    
    // 读取电容数据
    if (!water_level_sensor_read_capacitance(&p_full->cap))
    {
        if (p_full->error_code == WLS_ERR_NONE)
        {
            p_full->error_code = WLS_ERR_RX_TIMEOUT;
        }
    }
    
    // 读取频率数据
    if (!water_level_sensor_read_frequency(&p_full->freq))
    {
        if (p_full->error_code == WLS_ERR_NONE)
        {
            p_full->error_code = WLS_ERR_RX_TIMEOUT;
        }
    }
    
    // 读取计数数据
    if (!water_level_sensor_read_count(&p_full->count))
    {
        if (p_full->error_code == WLS_ERR_NONE)
        {
            p_full->error_code = WLS_ERR_RX_TIMEOUT;
        }
    }
    
    return (p_full->error_code == WLS_ERR_NONE);
}

bool water_level_sensor_set_avg_samples(uint8_t avg_count)
{
    if (!s_wls_initialized)
    {
        return false;
    }
    
    if (avg_count < 1 || avg_count > 20)
    {
        return false;
    }
    
    return wls_write_register(WLS_REG_AVG_SAMPLES, (uint16_t)avg_count);
}

uint8_t water_level_sensor_get_avg_samples(void)
{
    if (!s_wls_initialized)
    {
        return 0;
    }
    
    uint8_t response[16];
    uint16_t resp_len;
    
    if (!wls_read_registers(WLS_REG_AVG_SAMPLES, 1, response, &resp_len))
    {
        return 0;
    }
    
    if (resp_len >= 5 && response[2] >= 2)
    {
        return response[4];
    }
    
    return 0;
}

bool water_level_sensor_calibrate(void)
{
    if (!s_wls_initialized)
    {
        return false;
    }
    
    // 写入校准指令（向寄存器0x0006写入1）
    if (!wls_write_register(WLS_REG_CALIBRATION, 1))
    {
        APP_LOG_ERROR("[WLS] Calibration command failed");
        return false;
    }
    
    APP_LOG_INFO("[WLS] Calibration command sent successfully");
    return true;
}

bool water_level_sensor_is_ready(void)
{
    if (!s_wls_initialized)
    {
        return false;
    }
    
    // 尝试读取液位档位验证通信
    uint8_t level = water_level_sensor_get_level_grade();
    return (level != 0xFF);
}

void water_level_sensor_print_data(const water_level_data_t *p_data)
{
    if (p_data == NULL || !p_data->is_valid)
    {
        APP_LOG_WARNING("[WLS] Invalid data");
        return;
    }
    
    APP_LOG_INFO("[WLS] Level=%d, Temp=%.1fC", 
                 p_data->level_grade, 
                 p_data->temperature_c);
}
