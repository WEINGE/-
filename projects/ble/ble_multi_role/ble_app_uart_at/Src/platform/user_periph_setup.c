/**
 *****************************************************************************************
 *
 * @file user_periph_setup.c
 *
 * @brief  User Periph Init Function Implementation.
 *
 *****************************************************************************************
 * @attention
  #####Copyright (c) 2019 GOODIX
  All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
  * Neither the name of GOODIX nor the names of its contributors may be used
    to endorse or promote products derived from this software without
    specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "user_periph_setup.h"
#include "at_cmd.h"
#include "at_cmd_utils.h"
#include "transport_scheduler.h"
#include "board_SK.h"
#include "gr_includes.h"
#include "hal_flash.h"
#include "app_uart.h"
#include "app_uart_dma.h"  // UART0支持DMA，需要包含
#include "app_log.h"       // 添加日志支持

#include "app_assert.h"
#include "sensor_data_parser.h"
#include "ble_protocol.h"
#include "app_aon_wdt.h"  // 看门狗
#include "app_pwr_mgmt.h" // 电源管理回调（用于低功耗看门狗处理）
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "at_cmd_handler.h"
#include "bm8563_rtc.h"

/*
 * DEFINES
 *****************************************************************************************
 */
#define UART_TX_BUFFER_SIZE      0x2000
#define UART_RX_BUFFER_SIZE      244

// UART1 for 4G module
#define UART1_TX_BUFFER_SIZE     0x1000
#define UART1_RX_BUFFER_SIZE     512

// 看门狗配置（32kHz时钟）
// counter = 32768 * 超时秒数，这里设置120秒超时
#define WDT_TIMEOUT_SECONDS      120
#define WDT_COUNTER_VALUE        (32768 * WDT_TIMEOUT_SECONDS)
#define WDT_ALARM_VALUE          20  // 复位前20个时钟周期触发中断

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static const uint8_t     s_bd_addr[SYS_BD_ADDR_LEN] = {0x01, 0x02, 0xcf, 0x3e, 0xcb, 0xea};
static app_uart_tx_buf_t s_uart_buffer;
static app_uart_params_t s_uart_param;

static uint8_t s_uart_tx_buffer[UART_TX_BUFFER_SIZE];

// AT命令接收缓冲区（按行累积）
static uint8_t s_uart_rx_line[AT_CMD_BUFFER_SIZE_MAX];
static uint16_t s_uart_rx_len = 0;

// DMA接收缓冲区（块接收）
static uint8_t s_uart_dma_rx_buf[UART_RX_BUFFER_SIZE];

// UART1 for 4G module
static app_uart_tx_buf_t s_uart1_buffer;
static app_uart_params_t s_uart1_param;
static uint8_t s_uart1_tx_buffer[UART1_TX_BUFFER_SIZE];
static uint8_t s_uart1_rx_buffer[UART1_RX_BUFFER_SIZE]; // 改为中断接收缓冲
static uint8_t s_uart1_rx_line[UART1_RX_BUFFER_SIZE];
static uint16_t s_uart1_rx_len = 0;

static bool s_sensor_uart_opened = false;
static bool s_fourg_uart_opened  = false;

// 看门狗参数
static app_aon_wdt_params_t s_wdt_params;
static bool s_wdt_initialized = false;


/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 * @brief 看门狗超时回调（即将复位前触发）
 */
static void wdt_timeout_callback(void)
{
    APP_LOG_ERROR("!!! WATCHDOG TIMEOUT - System will reset !!!");
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
void app_uart_evt_handler(app_uart_evt_t *p_evt)
{
    if (p_evt == NULL)
    {
        return;
    }

    switch (p_evt->type)
    {
    case APP_UART_EVT_RX_DATA:
    {
        uint16_t rx_size = p_evt->data.size;
        // 将DMA接收到的数据写入按行缓冲，检测CRLF并处理
        for (uint16_t i = 0; i < rx_size; i++)
        {
            uint8_t ch = s_uart_dma_rx_buf[i];
            if (s_uart_rx_len < sizeof(s_uart_rx_line))
            {
                s_uart_rx_line[s_uart_rx_len++] = ch;

                if (s_uart_rx_len >= 2 &&
                    s_uart_rx_line[s_uart_rx_len - 2] == 0x0D &&
                    s_uart_rx_line[s_uart_rx_len - 1] == 0x0A)
                {
                    // 完整一帧到达，处理AT指令或回显
                    // 注：水位传感器使用I2C接口，不再通过UART接收传感器数据
                    bool is_at_cmd = false;
                    if (s_uart_rx_len >= 3 && strncmp((char*)s_uart_rx_line, "AT:", 3) == 0)
                    {
                        is_at_cmd = true;
                    }
                    else if (s_uart_rx_len >= 8 && strncmp((char*)s_uart_rx_line, "adminAT+", 8) == 0)
                    {
                        is_at_cmd = true;
                    }

                    if (is_at_cmd)
                    {
                        // 进入指令模式/+++等预处理；返回false表示需继续解析
                        if (!uart_at_preprocess_command(AT_CMD_SRC_UART, s_uart_rx_line, s_uart_rx_len))
                        {
                            at_cmd_parse(AT_CMD_SRC_UART, s_uart_rx_line, s_uart_rx_len);
                        }
                    }
                    else
                    {
                        // 原样回显给上位机
                        uart_tx_data_send(s_uart_rx_line, s_uart_rx_len);
                    }

                    // 重置行缓冲
                    s_uart_rx_len = 0;
                }
            }
            else
            {
                // 缓冲溢出，丢弃并复位
                s_uart_rx_len = 0;
            }
        }

        // 重新启动下一次DMA接收
        app_uart_dma_receive_async(APP_UART_ID, s_uart_dma_rx_buf, UART_RX_BUFFER_SIZE);
        break;
    }

    case APP_UART_EVT_TX_CPLT:
        // 发送完成可根据需要处理
        break;

    case APP_UART_EVT_ERROR:
        // 错误处理：复位行缓冲并重启接收
        s_uart_rx_len = 0;
        app_uart_dma_receive_async(APP_UART_ID, s_uart_dma_rx_buf, UART_RX_BUFFER_SIZE);
        break;

    default:
        break;
    }
}

/**
 *****************************************************************************************
 * @brief UART1 event handler for 4G module communication (Interrupt mode)
 *****************************************************************************************
 */
static int s_json_brace_level = 0;

static void app_uart1_evt_handler(app_uart_evt_t *p_evt)
{
    if (p_evt->type == APP_UART_EVT_RX_DATA)
    {
        for (uint16_t i = 0; i < p_evt->data.size; i++)
        {
            uint8_t ch = s_uart1_rx_buffer[i];

            // 缓冲区溢出检查
            if (s_uart1_rx_len >= sizeof(s_uart1_rx_line) - 1)
            {
                APP_LOG_WARNING("UART1 RX buffer overflow, resetting");
                s_uart1_rx_len = 0;
                s_json_brace_level = 0;
                continue;
            }

            // 存储字符
            s_uart1_rx_line[s_uart1_rx_len++] = ch;

            // 确定处理模式：JSON 或 AT指令
            if (s_uart1_rx_len == 1)
            {
                if (ch == '{')
                {
                    s_json_brace_level = 1;
                }
                else
                {
                    s_json_brace_level = 0; // AT指令模式
                }
            }
            else if (s_json_brace_level > 0) // 仅在JSON模式下处理括号
            {
                if (ch == '{')
                {
                    s_json_brace_level++;
                }
                else if (ch == '}')
                {
                    s_json_brace_level--;
                }
            }

            // 检查数据帧是否结束
            bool frame_end = false;
            if (s_json_brace_level == 0 && s_uart1_rx_len > 0) // 括号匹配完成或处于AT模式
            {
                if (s_uart1_rx_line[0] == '{') // JSON模式结束
                {
                    frame_end = true;
                }
                else if (ch == '\n') // AT指令模式结束
                {
                    frame_end = true;
                }
            }

            if (frame_end)
            {
                uint16_t data_len = s_uart1_rx_len;
                s_uart1_rx_line[data_len] = '\0'; // 确保字符串终止

                // 去除AT指令的尾部回车换行
                if (s_uart1_rx_line[0] != '{')
                {
                    if (data_len >= 2 && s_uart1_rx_line[data_len - 2] == '\r')
                    {
                        data_len -= 2;
                        s_uart1_rx_line[data_len] = '\0';
                    }
                    else if (data_len >= 1)
                    {
                        data_len -= 1;
                        s_uart1_rx_line[data_len] = '\0';
                    }
                }

                if (data_len > 0)
                {
                    APP_LOG_INFO("UART1 RX Frame: [%d bytes] %s", data_len, s_uart1_rx_line);
                    ble_protocol_handle_4g_data(s_uart1_rx_line, data_len);
                }

                // 重置缓冲区和状态
                s_uart1_rx_len = 0;
                s_json_brace_level = 0;
            }
        }
        app_uart_receive_async(APP_UART_ID_1, s_uart1_rx_buffer, UART1_RX_BUFFER_SIZE);
    }
    else if (p_evt->type == APP_UART_EVT_ERROR)
    {
        // 错误处理：复位行缓冲并重启接收
        s_uart1_rx_len = 0;
        s_json_brace_level = 0;
        app_uart_receive_async(APP_UART_ID_1, s_uart1_rx_buffer, UART1_RX_BUFFER_SIZE);
    }
}

/**
 *****************************************************************************************
 * @brief Initialize UART1 for 4G module communication (Interrupt mode)
 *****************************************************************************************
 */
void uart1_init(uint32_t baud_rate)
{
    s_uart1_buffer.tx_buf       = s_uart1_tx_buffer;
    s_uart1_buffer.tx_buf_size  = UART1_TX_BUFFER_SIZE;

    s_uart1_param.id                   = APP_UART_ID_1;
    s_uart1_param.init.baud_rate       = baud_rate;
    s_uart1_param.init.data_bits       = UART_DATABITS_8;
    s_uart1_param.init.stop_bits       = UART_STOPBITS_1;
    s_uart1_param.init.parity          = UART_PARITY_NONE;
    s_uart1_param.init.hw_flow_ctrl    = UART_HWCONTROL_NONE;
    s_uart1_param.init.rx_timeout_mode = UART_RECEIVER_TIMEOUT_ENABLE;
    
    // 配置UART1的GPIO引脚 - 根据引脚复用表配置
    // UART1使用GPIO7(TX)和GPIO6(RX)，MUX_3
    s_uart1_param.pin_cfg.rx.type      = APP_UART1_RX_IO_TYPE;
    s_uart1_param.pin_cfg.rx.pin       = APP_UART1_RX_PIN;  // GPIO7 (根据board_SK.h定义)
    s_uart1_param.pin_cfg.rx.mux       = APP_UART1_RX_PINMUX; // MUX_3
    s_uart1_param.pin_cfg.rx.pull      = APP_IO_PULLUP;
    s_uart1_param.pin_cfg.tx.type      = APP_UART1_TX_IO_TYPE;
    s_uart1_param.pin_cfg.tx.pin       = APP_UART1_TX_PIN;  // GPIO6 (根据board_SK.h定义)
    s_uart1_param.pin_cfg.tx.mux       = APP_UART1_TX_PINMUX; // MUX_3
    s_uart1_param.pin_cfg.tx.pull      = APP_IO_PULLUP;

    // 先反初始化，确保干净配置
    app_uart_deinit(APP_UART_ID_1);

    // 初始化UART1（使用中断模式，不使用DMA）
    app_uart_init(&s_uart1_param, app_uart1_evt_handler, &s_uart1_buffer);

    // 启动首次中断接收
    app_uart_receive_async(APP_UART_ID_1, s_uart1_rx_buffer, UART1_RX_BUFFER_SIZE);
    


}

void uart_init(uint32_t baud_rate)
{
    s_uart_buffer.tx_buf       = s_uart_tx_buffer;
    s_uart_buffer.tx_buf_size  = UART_TX_BUFFER_SIZE;

    s_uart_param.id                   = APP_UART_ID;
    s_uart_param.init.baud_rate       = baud_rate;
    s_uart_param.init.data_bits       = UART_DATABITS_8;
    s_uart_param.init.stop_bits       = UART_STOPBITS_1;
    s_uart_param.init.parity          = UART_PARITY_NONE;
    s_uart_param.init.hw_flow_ctrl    = UART_HWCONTROL_NONE;
    s_uart_param.init.rx_timeout_mode = UART_RECEIVER_TIMEOUT_ENABLE;
    s_uart_param.pin_cfg.rx.type      = APP_UART_RX_IO_TYPE;
    s_uart_param.pin_cfg.rx.pin       = APP_UART_RX_PIN;
    s_uart_param.pin_cfg.rx.mux       = APP_UART_RX_PINMUX;
    s_uart_param.pin_cfg.rx.pull      = APP_UART_RX_PULL;
    s_uart_param.pin_cfg.tx.type      = APP_UART_TX_IO_TYPE;
    s_uart_param.pin_cfg.tx.pin       = APP_UART_TX_PIN;
    s_uart_param.pin_cfg.tx.mux       = APP_UART_TX_PINMUX;
    s_uart_param.pin_cfg.tx.pull      = APP_UART_TX_PULL;

    // 先反初始化，确保干净配置
    app_uart_deinit(APP_UART_ID);

    // 初始化UART（使用中断模式，与水位传感器保持一致，不使用DMA）
    app_uart_init(&s_uart_param, app_uart_evt_handler, &s_uart_buffer);
    
    // 启动异步接收（使用已有的接收缓冲区）
    app_uart_receive_async(APP_UART_ID, s_uart_dma_rx_buf, UART_RX_BUFFER_SIZE);
}

uint32_t app_uart_baud_get(void)
{
    return s_uart_param.init.baud_rate;
}

void uart_tx_data_send(uint8_t *p_data, uint16_t length)
{
    // Polling/blocking transmit
    app_uart_transmit_sync(APP_UART_ID, p_data, length, 1000);
}

// UART1发送函数，用于4G模块通信（同步发送，确保发出）
void uart1_tx_data_send(uint8_t *p_data, uint16_t length)
{
    app_uart_transmit_sync(APP_UART_ID_1, p_data, length, 1000);
}

void sensor_uart_open(void)
{
    if (!s_sensor_uart_opened)
    {
        uart_init(APP_UART_BAUDRATE);
        s_sensor_uart_opened = true;
    }
}

void sensor_uart_close(void)
{
    if (s_sensor_uart_opened)
    {
        app_uart_deinit(APP_UART_ID);
        s_sensor_uart_opened = false;
    }
}

void fourg_uart_open(void)
{
    if (!s_fourg_uart_opened)
    {
        uart1_init(APP_UART1_BAUDRATE);
        s_fourg_uart_opened = true;
    }
}

void fourg_uart_close(void)
{
    if (s_fourg_uart_opened)
    {
        app_uart_deinit(APP_UART_ID_1);
        s_fourg_uart_opened = false;
    }
}

// AT命令接收和解析任务
void uart_polling_task(void)
{
    // DMA接收模式下，不再进行同步轮询接收。
    // 保留空实现以保持接口兼容，实际接收在app_uart_evt_handler回调中完成。
}

void app_periph_init(void)
{
    SYS_SET_BD_ADDR(s_bd_addr);
    app_assert_init();
    // 注意：UART0不在启动时初始化，由水位传感器按需使用（参考备份1.01）
    uart1_init(APP_UART1_BAUDRATE); // 参考2.0：启动时初始化UART1，上传后关闭省电
    s_fourg_uart_opened = true;    // 同步状态标志

    // Configure GPIO25 (S_EN) as output, initial state OFF (low)
    {
        app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
        io_init.mode = APP_IO_MODE_OUTPUT;
        io_init.pull = APP_IO_NOPULL;
        io_init.mux  = APP_IO_MUX_7; // GPIO function
        io_init.pin  = APP_IO_PIN_25; // GPIO25
        app_io_init(APP_IO_TYPE_NORMAL, &io_init);
        // Set initial state to OFF (low)
        app_io_write_pin(APP_IO_TYPE_NORMAL, APP_IO_PIN_25, APP_IO_PIN_RESET);
    }

    // Configure AON_GPIO_2 (4G_POWER_EN) as output, initial state ON (high) for 4G module power
    {
        app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
        io_init.mode = APP_IO_MODE_OUTPUT;
        io_init.pull = APP_IO_NOPULL;
        io_init.mux  = APP_IO_MUX_7; // GPIO function
        io_init.pin  = AON_GPIO_PIN_2; // AON GPIO2
        app_io_init(APP_IO_TYPE_AON, &io_init);
        // Set to high for 4G module power enable (external circuit handles power)
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_2, APP_IO_PIN_RESET);
    }

    // Configure AON_GPIO_6 (P_M_EN) as output, initial state OFF (low)
    {
        app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
        io_init.mode = APP_IO_MODE_OUTPUT;
        io_init.pull = APP_IO_NOPULL;
        io_init.mux  = APP_IO_MUX_7; // AON GPIO function
        io_init.pin  = AON_GPIO_PIN_6; // AON GPIO6
        app_io_init(APP_IO_TYPE_AON, &io_init);
        // Set initial state to OFF (low)
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_6, APP_IO_PIN_RESET);
    }

    // 初始化BM8563 RTC模块
    if (bm8563_init()) {
        APP_LOG_INFO("BM8563 RTC initialized successfully");
    } else {
        APP_LOG_ERROR("BM8563 RTC initialization failed");
    }

    pwr_mgmt_mode_set(PMR_MGMT_SLEEP_MODE);
}

// -----------------------------------------------------------------------------
// Compatibility shims for at_cmd_handler expected sensor_uart0_* symbols.
// In this polling-based implementation, AT命令在uart_polling_task中直接解析，
// 这里返回“无数据”，仅用于满足链接符号依赖。
uint16_t sensor_uart0_last_len(void)
{
    return 0;
}

bool sensor_uart0_has_data(void)
{
    return sensor_data_is_available();
}

void sensor_uart0_clear_flag(void)
{
    sensor_data_clear_flag();
}

// GPIO control functions for S_EN and P_M_EN
void gpio_s_en_set(bool enable)
{
    if (enable) {
        app_io_write_pin(APP_IO_TYPE_NORMAL, APP_IO_PIN_25, APP_IO_PIN_SET);
    } else {
        app_io_write_pin(APP_IO_TYPE_NORMAL, APP_IO_PIN_25, APP_IO_PIN_RESET);
    }
}

void gpio_p_m_en_set(bool enable)
{
    if (enable) {
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_6, APP_IO_PIN_SET);
    } else {
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_6, APP_IO_PIN_RESET);
    }
}

bool gpio_s_en_get(void)
{
    return (app_io_read_pin(APP_IO_TYPE_NORMAL, APP_IO_PIN_25) == APP_IO_PIN_SET);
}

bool gpio_p_m_en_get(void)
{
    return (app_io_read_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_6) == APP_IO_PIN_SET);
}

// 4G module power control functions
void gpio_4g_power_en_set(bool enable)
{
    if (enable) {
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_2, APP_IO_PIN_SET);
        // Add stabilization delay for 4G module power up
        sys_delay_ms(50);
    } else {
        app_io_write_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_2, APP_IO_PIN_RESET);
    }
}

bool gpio_4g_power_en_get(void)
{
    return (app_io_read_pin(APP_IO_TYPE_AON, AON_GPIO_PIN_2) == APP_IO_PIN_SET);
}

/*
 * WATCHDOG FUNCTIONS
 *****************************************************************************************
 */

/**
 * @brief 低功耗睡眠前回调 - 禁用看门狗
 * 
 * AON_WDT在睡眠期间也会继续计数，但CPU不执行代码无法喂狗。
 * 因此在进入睡眠前需要禁用看门狗，避免睡眠期间看门狗超时导致复位。
 * 
 * @return true 允许进入睡眠
 */
static bool wdt_prepare_for_sleep(void)
{
    if (s_wdt_initialized) {
        // 禁用看门狗，防止睡眠期间超时
        app_aon_wdt_deinit();
        APP_LOG_DEBUG("Watchdog disabled before sleep");
    }
    return true;  // 允许进入睡眠
}

/**
 * @brief 唤醒后回调 - 重新启用看门狗
 * 
 * 系统从低功耗模式唤醒后，重新初始化看门狗以恢复保护功能。
 */
static void wdt_wake_up_ind(void)
{
    if (s_wdt_initialized) {
        // 重新初始化看门狗
        uint16_t ret = app_aon_wdt_init(&s_wdt_params, wdt_timeout_callback);
        if (ret == APP_DRV_SUCCESS) {
            APP_LOG_DEBUG("Watchdog re-enabled after wakeup");
        } else {
            APP_LOG_ERROR("Failed to re-enable watchdog: 0x%04X", ret);
        }
    }
}

// 看门狗睡眠回调结构体
static const app_sleep_callbacks_t s_wdt_sleep_cb = {
    .app_prepare_for_sleep = wdt_prepare_for_sleep,
    .app_wake_up_ind = wdt_wake_up_ind,
};

/**
 * @brief 初始化看门狗（30秒超时）
 * @return true 初始化成功，false 初始化失败
 */
bool watchdog_init(void)
{
    if (s_wdt_initialized) {
        return true;
    }
    
    // 配置看门狗参数
    memset(&s_wdt_params, 0, sizeof(s_wdt_params));
    s_wdt_params.init.counter = WDT_COUNTER_VALUE;       // 30秒超时
    s_wdt_params.init.alarm_counter = WDT_ALARM_VALUE;   // 复位前预警
    
    uint16_t ret = app_aon_wdt_init(&s_wdt_params, wdt_timeout_callback);
    if (ret != APP_DRV_SUCCESS) {
        APP_LOG_ERROR("Watchdog init failed: 0x%04X", ret);
        return false;
    }
    
    // 注册睡眠回调：进入睡眠前禁用看门狗，唤醒后重新启用
    // 使用 PWR_ID_MAX 表示自定义ID（不与系统外设冲突）
    pwr_register_sleep_cb(&s_wdt_sleep_cb, WAKEUP_PRIORITY_LOW, PWR_ID_MAX);
    
    s_wdt_initialized = true;
    APP_LOG_INFO("Watchdog initialized: %d seconds timeout (with sleep callback)", WDT_TIMEOUT_SECONDS);
    return true;
}

/**
 * @brief 喂狗（刷新看门狗计数器）
 * @note 必须在超时前调用，否则系统会复位
 */
void watchdog_feed(void)
{
    if (s_wdt_initialized) {
        app_aon_wdt_refresh();
    }
}

/**
 * @brief 检查看门狗是否已初始化
 */
bool watchdog_is_initialized(void)
{
    return s_wdt_initialized;
}

