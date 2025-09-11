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
#include "app_uart_dma.h"
#include "app_log.h"
#include "app_assert.h"
#include "sensor_data_parser.h"
#include <stdbool.h>

/*
 * DEFINES
 *****************************************************************************************
 */
#define UART_TX_BUFFER_SIZE      0x2000
#define UART_RX_BUFFER_SIZE      244

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

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
static void log_flush(void)
{
    app_uart_flush(APP_UART_ID);
}

static void app_log_assert_init(void)
{
    app_log_init_t log_init;

    log_init.filter.level                 = APP_LOG_LVL_DEBUG;
    log_init.fmt_set[APP_LOG_LVL_ERROR]   = APP_LOG_FMT_ALL & (~APP_LOG_FMT_TAG);
    log_init.fmt_set[APP_LOG_LVL_WARNING] = APP_LOG_FMT_LVL;
    log_init.fmt_set[APP_LOG_LVL_INFO]    = APP_LOG_FMT_LVL;
    log_init.fmt_set[APP_LOG_LVL_DEBUG]   = APP_LOG_FMT_LVL;

    app_log_init(&log_init, uart_tx_data_send,  log_flush);
    app_assert_init();
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
                    // 完整一帧到达，判断是否为传感器固定长度数据
                    if (s_uart_rx_len == 29)
                    {
                        sensor_data_t sensor_data;
                        sensor_parse_result_t parse_result = sensor_data_parse(s_uart_rx_line, s_uart_rx_len, &sensor_data);
                        if (parse_result == SENSOR_PARSE_SUCCESS)
                        {
                            char resp[128];
                            int n = snprintf(resp, sizeof(resp),
                                             "Concentration: %.2f %%vol\r\nTemperature: %.1f C\r\nReserved: %lu\r\nStatus: %02X\r\nChecksum: %02X\r\n",
                                             sensor_data.concentration,
                                             sensor_data.temperature,
                                             (unsigned long)sensor_data.reserved_field,
                                             sensor_data.status_code,
                                             sensor_data.checksum);
                            if (n > 0)
                            {
                                uart_tx_data_send((uint8_t *)resp, (uint16_t)n);
                            }
                        }
                        else
                        {
                            char err[64];
                            int n = snprintf(err, sizeof(err), "Parse failed, error: %d\r\n", parse_result);
                            if (n > 0)
                            {
                                uart_tx_data_send((uint8_t *)err, (uint16_t)n);
                            }
                        }
                    }
                    else
                    {
                        // 非固定长度，原样回显
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

    APP_LOG_INFO("The baud rate update value=%d.", s_uart_param.init.baud_rate);

    // 初始化UART（中断/事件回调用于DMA接收完成通知）
    app_uart_init(&s_uart_param, app_uart_evt_handler, &s_uart_buffer);

    // 仅启用DMA接收（TX仍采用原有同步发送方式）
    memset(&s_uart_param.dma_cfg, 0, sizeof(s_uart_param.dma_cfg));
    s_uart_param.dma_cfg.rx_dma_instance = DMA0;
    s_uart_param.dma_cfg.rx_dma_channel  = DMA_Channel0; // 如有冲突可调整为其它空闲通道

    // 配置UART的DMA功能并启动首次DMA接收
    app_uart_dma_init(&s_uart_param);
    app_uart_dma_receive_async(APP_UART_ID, s_uart_dma_rx_buf, UART_RX_BUFFER_SIZE);
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

// AT命令接收和解析任务
void uart_polling_task(void)
{
    // DMA接收模式下，不再进行同步轮询接收。
    // 保留空实现以保持接口兼容，实际接收在app_uart_evt_handler回调中完成。
}

void app_periph_init(void)
{
    SYS_SET_BD_ADDR(s_bd_addr);
    app_log_assert_init();
    uart_init(APP_UART_BAUDRATE);

    // Configure GPIO25 (S_EN) as input with pull-up
    {
        app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
        io_init.mode = APP_IO_MODE_INPUT;
        io_init.pull = APP_IO_PULLUP;
        io_init.mux  = APP_IO_MUX_0; // GPIO function
        io_init.pin  = APP_IO_PIN_25; // GPIO25
        app_io_init(APP_IO_TYPE_NORMAL, &io_init);
    }

    // Configure AON_GPIO_6 (P_M_EN) as input with pull-up
    {
        app_io_init_t io_init = APP_IO_DEFAULT_CONFIG;
        io_init.mode = APP_IO_MODE_INPUT;
        io_init.pull = APP_IO_PULLUP;
        io_init.mux  = APP_IO_MUX_7; // AON GPIO function
        io_init.pin  = APP_IO_PIN_6; // AON GPIO6
        app_io_init(APP_IO_TYPE_AON, &io_init);
    }

    pwr_mgmt_mode_set(PMR_MGMT_ACTIVE_MODE);
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
