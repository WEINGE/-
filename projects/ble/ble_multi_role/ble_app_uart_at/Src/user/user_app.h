/**
 ********************************************************************************
 *
 * @file user_app.h
 *
 * @brief Header file - User Function
 *
 ********************************************************************************
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
#ifndef _USER_APP_H_
#define _USER_APP_H_

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "gr_includes.h"
#include "gus.h"
#include "gus_c.h"

/*
 * GLOBAL FUNCTION DECLARATION
 *****************************************************************************************
 */
/**
 *****************************************************************************************
 * @brief Function for user ble event handler.
 *****************************************************************************************
 */
void ble_evt_handler(const ble_evt_t *p_evt);

/**
 *****************************************************************************************
 * @brief Function for ble stack init complete
 *****************************************************************************************
 */
void ble_app_init(void);

/**
 *****************************************************************************************
 * @brief Function for sending JSON data to 4G module via UART1.
 *****************************************************************************************
 */
void uart1_send_json_to_4g(const char* json_data);

/**
 *****************************************************************************************
 * @brief Update sensor data from sensor parser.
 *****************************************************************************************
 */
void update_sensor_data_from_parser(void);

/**
 *****************************************************************************************
 * @brief Update sensor data with optional force read from sensor.
 *
 * @param[in] force_read: If true, actively read fresh data from sensor (for BLE queries).
 *                        If false, use cached data (for timed uploads).
 *****************************************************************************************
 */
void update_sensor_data_from_parser_ex(bool force_read);

/**
 *****************************************************************************************
 * @brief 鍔ㄦ€佹洿鏂拌摑鐗欒澶囧悕绉帮紙鍩轰簬IMEI鍚庡洓浣嶏級
 * 
 * 姝ゅ嚱鏁版鏌ュ綋鍓岻MEI锛屽鏋淚MEI鍚庡洓浣嶄笌褰撳墠钃濈墮鍚嶇О涓嶇锛屽垯鏇存柊钃濈墮鍚嶇О骞堕噸鍚箍鎾€?
 * 璋冪敤鏃舵満锛氬湪IMEI鎴愬姛鑾峰彇鍚庤皟鐢紝渚嬪鍦?G妯″潡鍒濆鍖栧畬鎴愬悗銆?
 *****************************************************************************************
 */
void update_ble_name_with_imei(void);

#endif

