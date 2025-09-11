/**
 *****************************************************************************************
 *
 * @file uart0_init.h
 *
 * @brief UART0 initialization header file.
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

#ifndef __UART0_INIT_H__
#define __UART0_INIT_H__

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "app_uart.h"

/*
 * DEFINES
 *****************************************************************************************
 */
#define UART0_ID                    APP_UART_ID_0
#define UART0_DATA_LEN              (512)

/*
 * GLOBAL FUNCTION DECLARATIONS
 ****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief UART0初始化函数
 *
 * @return 初始化结果，APP_DRV_SUCCESS表示成功
 *****************************************************************************************
 */
uint16_t uart0_init(void);

/**
 *****************************************************************************************
 * @brief UART0发送数据函数
 *
 * @param[in] data: 要发送的数据指针
 * @param[in] length: 数据长度
 *
 * @return 发送结果，APP_DRV_SUCCESS表示成功
 *****************************************************************************************
 */
uint16_t uart0_send_data(uint8_t *data, uint16_t length);

/**
 *****************************************************************************************
 * @brief UART0接收数据函数
 *
 * @param[in] buffer: 接收缓冲区指针
 * @param[in] length: 缓冲区长度
 *
 * @return 接收结果，APP_DRV_SUCCESS表示成功
 *****************************************************************************************
 */
uint16_t uart0_receive_data(uint8_t *buffer, uint16_t length);

/**
 *****************************************************************************************
 * @brief 查询UART0是否有接收到数据
 *
 * @return true表示有数据，false表示无数据
 *****************************************************************************************
 */
bool uart0_has_received_data(void);

/**
 *****************************************************************************************
 * @brief 获取UART0接收到的数据长度
 *
 * @return 接收到的数据长度
 *****************************************************************************************
 */
uint16_t uart0_get_received_data_length(void);

/**
 *****************************************************************************************
 * @brief 清除UART0接收数据标志
 *****************************************************************************************
 */
void uart0_clear_received_flag(void);

#endif /* __UART0_INIT_H__ */
