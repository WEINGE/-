/**
 *****************************************************************************************
 *
 * @file uart0_init.c
 *
 * @brief UART0 initialization implementation.
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
#include <stdio.h>
#include <string.h>
#include "uart0_init.h"
#include "app_uart.h"
#include "board_SK.h"
#include "app_io.h"
#include "grx_hal.h"

/*
 * GLOBAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static uint8_t g_uart0_tx_buffer[UART0_DATA_LEN] = {0};
static uint8_t g_uart0_rx_buffer[UART0_DATA_LEN] = {0};
static uint8_t g_uart0_ring_buffer[UART0_DATA_LEN] = {0};
static volatile uint8_t g_uart0_tx_done = 0;
static volatile uint8_t g_uart0_rx_done = 0;
static volatile uint16_t g_uart0_rx_len = 0;
static volatile bool g_uart0_data_received = false;

// UART0参数配置
static app_uart_params_t uart0_params = {
    .id      = APP_UART_ID,
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
        .baud_rate = 9600,
        .data_bits = UART_DATABITS_8,
        .stop_bits = UART_STOPBITS_1,
        .parity    = UART_PARITY_NONE,
        .hw_flow_ctrl    = UART_HWCONTROL_NONE,
        .rx_timeout_mode = UART_RECEIVER_TIMEOUT_ENABLE,
    },
};

/*
 * LOCAL FUNCTION DEFINITIONS
 ****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief UART0事件回调函数
 *
 * @param[in] p_evt: UART事件指针
 *****************************************************************************************
 */
static void uart0_callback(app_uart_evt_t *p_evt)
{
    if (p_evt->type == APP_UART_EVT_TX_CPLT)
    {
        g_uart0_tx_done = 1;
    }
    
    if (p_evt->type == APP_UART_EVT_RX_DATA)
    {
        g_uart0_rx_done = 1;
        g_uart0_rx_len = p_evt->data.size;
        g_uart0_data_received = true;
        memcpy(g_uart0_tx_buffer, g_uart0_rx_buffer, g_uart0_rx_len);
    }
    
    if (p_evt->type == APP_UART_EVT_ERROR)
    {
        g_uart0_tx_done = 1;
        g_uart0_rx_done = 1;
    }
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 ****************************************************************************************
 */

uint16_t uart0_init(void)
{
    uint16_t ret = 0;
    app_uart_tx_buf_t uart_buffer = {0};

    // 初始化GPIO25并拉高
    app_io_init_t gpio25_config = {
        .pin = 25,
        .mode = APP_IO_MODE_OUTPUT,
        .pull = APP_IO_PULLUP,
        .mux = APP_IO_MUX_7,
    };
    
    ret = app_io_init(APP_IO_TYPE_NORMAL, &gpio25_config);
    if (ret == APP_DRV_SUCCESS)
    {
        app_io_write_pin(APP_IO_TYPE_NORMAL, 25, APP_IO_PIN_SET);
    }
    
    // 初始化AON_GPIO_6并拉高
    app_io_init_t aon_gpio6_config = {
        .pin = 6,
        .mode = APP_IO_MODE_OUTPUT,
        .pull = APP_IO_PULLUP,
        .mux = APP_IO_MUX_7,
    };
    
    ret = app_io_init(APP_IO_TYPE_AON, &aon_gpio6_config);
    if (ret == APP_DRV_SUCCESS)
    {
        app_io_write_pin(APP_IO_TYPE_AON, 6, APP_IO_PIN_SET);
    }

    // 配置环形缓冲区
    uart_buffer.tx_buf = g_uart0_ring_buffer;
    uart_buffer.tx_buf_size = sizeof(g_uart0_ring_buffer);
    
    // 初始化UART0
    ret = app_uart_init(&uart0_params, uart0_callback, &uart_buffer);
    if (ret != APP_DRV_SUCCESS)
    {
        return ret;
    }
    
    // 发送初始化完成消息
    uint8_t init_msg[] = "UART0 initialized successfully.\r\n";
    app_uart_transmit_sync(UART0_ID, init_msg, sizeof(init_msg) - 1, 5000);
    
    return APP_DRV_SUCCESS;
}

uint16_t uart0_send_data(uint8_t *data, uint16_t length)
{
    if (data == NULL || length == 0)
    {
        return APP_DRV_ERR_INVALID_PARAM;
    }
    
    g_uart0_tx_done = 0;
    uint16_t ret = app_uart_transmit_async(UART0_ID, data, length);
    
    if (ret == APP_DRV_SUCCESS)
    {
        // 等待发送完成
        while (g_uart0_tx_done == 0);
    }
    
    return ret;
}

bool uart0_has_received_data(void)
{
    return g_uart0_data_received;
}

uint16_t uart0_get_received_data_length(void)
{
    return g_uart0_rx_len;
}

void uart0_clear_received_flag(void)
{
    g_uart0_data_received = false;
    g_uart0_rx_len = 0;
}

uint16_t uart0_receive_data(uint8_t *buffer, uint16_t length)
{
    if (buffer == NULL || length == 0)
    {
        return APP_DRV_ERR_INVALID_PARAM;
    }
    
    g_uart0_rx_done = 0;
    uint16_t ret = app_uart_receive_async(UART0_ID, g_uart0_rx_buffer, 
                                         (length > UART0_DATA_LEN) ? UART0_DATA_LEN : length);
    
    if (ret == APP_DRV_SUCCESS)
    {
        // 等待接收完成
        while (g_uart0_rx_done == 0);
        
        // 复制接收到的数据
        uint16_t copy_len = (g_uart0_rx_len > length) ? length : g_uart0_rx_len;
        memcpy(buffer, g_uart0_rx_buffer, copy_len);
        
        return copy_len;
    }
    
    return ret;
}
