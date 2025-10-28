/**
 *****************************************************************************************
 *
 * @file user_app.c
 *
 * @brief BLE用户应用层实现 - 核心业务逻辑处理模块
 *        
 * @details 功能概述：
 *          - BLE事件处理和状态管理
 *          - GAP参数配置和连接管理
 *          - GUS服务和客户端事件处理
 *          - 数据传输调度和缓冲区管理
 *          - AT命令与BLE协议的桥接
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
 * 头文件包含
 *****************************************************************************************
 */
#include "user_app.h"           // 用户应用层接口定义
#include "at_cmd_handler.h"     // AT命令处理器，解析和执行串口AT命令
#include "user_periph_setup.h"  // 用户外设配置，GPIO、UART等硬件初始化
#include "transport_scheduler.h" // 传输调度器，管理BLE和UART之间的数据传输
#include "app_log.h"            // 应用日志系统，提供调试信息输出
#include "at_cmd_utils.h"       // AT命令工具函数，格式化和解析工具
#include "utility.h"            // 通用工具函数库
#include "ring_buffer.h"        // 环形缓冲区实现，用于数据缓存
#include "ble_protocol.h"       // BLE协议处理模块，处理JSON格式的协议数据
#include "bm8563_rtc.h"         // RTC时间管理模块，用于获取实时时间戳
#include <stdarg.h>             // 可变参数列表支持
#include <stdio.h>              // 标准输入输出函数
#include "ble_4g_protocol.h"  // 为了使用 ble_4g_sensor_data_t 类型
#include "app_uart.h"         // 为了使用 app_uart_transmit_async 函数
#include "sensor_data_parser.h"  // 传感器数据解析模块
#include "gr55xx_delay.h"     // 系统延迟函数
#include "shared_params.h"    // 共享参数管理模块
#include "battery_voltage_reader.h"  // 电池电压读取模块
/*
 * 宏定义配置
 *****************************************************************************************
 */
/**@brief BLE GAP参数配置 - 定义设备的蓝牙行为参数 */
#define DEVICE_NAME                         "GAS0000"   /**< 默认设备名称，将在获取IMEI后动态更新 */

/** 广播参数配置 - 控制设备的可发现性 */
#define APP_ADV_INTERVAL_MIN                160                /**< 广播最小间隔 (单位: 0.625ms) = 100ms，影响功耗和发现速度 */
#define APP_ADV_INTERVAL_MAX                160                /**< 广播最大间隔 (单位: 0.625ms) = 100ms，与最小值相同保证稳定间隔 */

/** 扫描参数配置 - 控制设备搜索其他BLE设备的行为 */
#define APP_SCAN_INTERVAL                   15                 /**< 扫描间隔 (单位: 0.625ms) = 9.375ms，扫描频率 */
#define APP_SCAN_WINDOW                     15                 /**< 扫描窗口 (单位: 0.625ms) = 9.375ms，每个间隔内的活跃扫描时间 */
#define APP_SCAN_DURATION                   0                  /**< 扫描持续时间 (单位: 10ms)，0表示持续扫描直到手动停止 */

/** 连接参数配置 - 定义BLE连接的通信特性 */
#define APP_CONN_INTERVAL_MIN               36                 /**< 连接最小间隔 (单位: 1.25ms) = 45ms，影响数据传输频率和功耗 */
#define APP_CONN_INTERVAL_MAX               36                 /**< 连接最大间隔 (单位: 1.25ms) = 45ms，与最小值相同保证稳定传输 */
#define APP_CONN_SLAVE_LATENCY              0                  /**< 从设备延迟，0表示每个连接事件都响应，确保低延迟 */
#define APP_CONN_SUP_TIMEOUT                400                /**< 连接监督超时 (单位: 10ms) = 4s，连接丢失检测时间 */
#define APP_CONN_TIMEOUT                    400                /**< 连接超时 (单位: 10ms) = 4s，建立连接的最大等待时间 */

/** L2CAP和数据传输参数配置 - 控制数据包大小和传输能力 */
#define MAX_MTU_DEFUALT                     247                /**< 默认最大传输单元，单次可传输的最大数据长度 */
#define MAX_MPS_DEFUALT                     247                /**< 默认最大包大小，L2CAP层的最大包长度 */
#define MAX_NB_LECB_DEFUALT                 1                  /**< 默认LE信用连接最大数量，并发连接数限制 */
#define MAX_TX_OCTET_DEFUALT                251                /**< 默认最大发送字节数，物理层单次传输的最大数据量 */
#define MAX_TX_TIME_DEFUALT                 2120               /**< 默认最大包传输时间 (单位: μs)，数据包传输的最大时间限制 */

/*
 * GLOBAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
ble_gap_adv_param_t      g_gap_adv_param;        /**< Advertising parameters for legay advertising. */
ble_gap_adv_time_param_t g_gap_adv_time_param;
ble_gap_scan_param_t     g_gap_scan_param;       /**< Scanning parameters. */
ble_gap_init_param_t     g_gap_connect_param;
bool                     g_master_set_cccd_flag;
static bool is_connected;
extern ring_buffer_t     s_uart_to_ble_buffer;
extern ring_buffer_t     s_ble_to_uart_buffer;

uint8_t g_adv_data_set[28] =
{
    0x11,
    BLE_GAP_AD_TYPE_COMPLETE_LIST_128_BIT_UUID,
    GUS_SERVICE_UUID,

    // Manufacturer specific adv data type
    0x05,
    BLE_GAP_AD_TYPE_MANU_SPECIFIC_DATA,
    // Goodix SIG Company Identifier: 0x04F7
    0xF7,
    0x04,
    // Goodix specific adv data
    0x02,
    0x03,
};

uint8_t g_adv_rsp_data_set[28] =            /**< Scan responce data. */
{
    0x08,
    BLE_GAP_AD_TYPE_COMPLETE_NAME,
    'G', 'A', 'S', '0', '0', '0', '0'
};

/*
 * LOCAL FUNCTION DEFINITIONS
 *****************************************************************************************
 */
static void gap_params_init(void)
{
    // 初始化时使用默认名称 GAS0000
    ble_gap_pair_enable(false);
    ble_gap_device_name_set(BLE_GAP_WRITE_PERM_DISABLE, (uint8_t *)DEVICE_NAME, strlen(DEVICE_NAME));
    ble_gap_l2cap_params_set(MAX_MTU_DEFUALT, MAX_MPS_DEFUALT, MAX_NB_LECB_DEFUALT);
    ble_gap_data_length_set(MAX_TX_OCTET_DEFUALT, MAX_TX_TIME_DEFUALT);
    ble_gap_pref_phy_set(BLE_GAP_PHY_ANY, BLE_GAP_PHY_ANY);

    // Default GAP Advertising Parameter Init
    g_gap_adv_param.adv_intv_max = APP_ADV_INTERVAL_MAX;
    g_gap_adv_param.adv_intv_min = APP_ADV_INTERVAL_MIN;
    g_gap_adv_param.adv_mode     = BLE_GAP_ADV_TYPE_ADV_IND;
    g_gap_adv_param.chnl_map     = BLE_GAP_ADV_CHANNEL_37_38_39;
    g_gap_adv_param.disc_mode    = BLE_GAP_DISC_MODE_GEN_DISCOVERABLE;
    g_gap_adv_param.filter_pol   = BLE_GAP_ADV_ALLOW_SCAN_ANY_CON_ANY;
    ble_gap_adv_param_set(0, BLE_GAP_OWN_ADDR_STATIC, &g_gap_adv_param);
    ble_gap_adv_data_set(0, BLE_GAP_ADV_DATA_TYPE_DATA, g_adv_data_set, sizeof(g_adv_data_set));
    
    // 使用默认名称设置广播响应数据
    uint8_t adv_rsp_data[28] = {0};
    uint8_t name_len = strlen(DEVICE_NAME);
    adv_rsp_data[0] = name_len + 1;
    adv_rsp_data[1] = BLE_GAP_AD_TYPE_COMPLETE_NAME;
    memcpy(&adv_rsp_data[2], DEVICE_NAME, name_len);
    
    ble_gap_adv_data_set(0, BLE_GAP_ADV_DATA_TYPE_SCAN_RSP, adv_rsp_data, name_len + 2);
    
    APP_LOG_INFO("BLE initialized with default name: %s", DEVICE_NAME);

    g_gap_adv_time_param.duration    = 0;
    g_gap_adv_time_param.max_adv_evt = 0;

    // Default GAP Scan Parameter Init
    g_gap_scan_param.scan_type     = BLE_GAP_SCAN_ACTIVE;
    g_gap_scan_param.scan_mode     = BLE_GAP_SCAN_OBSERVER_MODE;
    g_gap_scan_param.scan_dup_filt = BLE_GAP_SCAN_FILT_DUPLIC_EN;
    g_gap_scan_param.use_whitelist = false;
    g_gap_scan_param.interval      = APP_SCAN_INTERVAL;
    g_gap_scan_param.window        = APP_SCAN_WINDOW;
    g_gap_scan_param.timeout       = APP_SCAN_DURATION;

    // Default GAP Connect Parameter Init
    g_gap_connect_param.type          = BLE_GAP_INIT_TYPE_DIRECT_CONN_EST;
    g_gap_connect_param.interval_min  = APP_CONN_INTERVAL_MIN;
    g_gap_connect_param.interval_max  = APP_CONN_INTERVAL_MAX;
    g_gap_connect_param.slave_latency = APP_CONN_SLAVE_LATENCY;
    g_gap_connect_param.sup_timeout   = APP_CONN_SUP_TIMEOUT;
    g_gap_connect_param.conn_timeout  = APP_CONN_TIMEOUT;
}


/**
 *****************************************************************************************
 * @brief Process gus event.
 *
 * @param[in] p_evt: Pointer to gus even strcture.
 *****************************************************************************************
 */
static void gus_service_process_event(gus_evt_t *p_evt)
{
    uint8_t ble_rx_data[AT_CMD_BUFFER_SIZE_MAX];

    switch (p_evt->evt_type)
    {
        case GUS_EVT_TX_PORT_OPENED:
            transport_flag_set(GUS_TX_NTF_ENABLE, true);
            break;

        case GUS_EVT_TX_PORT_CLOSED:
            transport_flag_set(GUS_TX_NTF_ENABLE, false);
            break;

        case GUS_EVT_RX_DATA_RECEIVED:
            if (0 == memcmp(p_evt->p_data, "AT:", 3))
            {
                memcpy(ble_rx_data, p_evt->p_data, p_evt->length);

                if ((0x0d != p_evt->p_data[p_evt->length - 2]) ||\
                    (0x0a != p_evt->p_data[p_evt->length - 1]))
                {
                    ble_rx_data[p_evt->length]     = 0x0d;
                    ble_rx_data[p_evt->length + 1] = 0x0a;
                }

                at_cmd_parse(AT_CMD_SRC_BLE, ble_rx_data, p_evt->length + 2);
            }
            else if (p_evt->p_data[0] == '{')
            {
                // 处理JSON格式的协议数据
                ble_protocol_data_process(p_evt->p_data, p_evt->length);
            }
            else
            {
                ble_to_uart_buff_data_push(p_evt->p_data, p_evt->length);
            }

            break;

        case GUS_EVT_TX_DATA_SENT:
            transport_flag_set(BLE_TX_CPLT, true);
            break;

        case GUS_EVT_FLOW_CTRL_ENABLE:
            transport_flag_set(BLE_FLOW_CTRL_ENABLE, true);
            break;

        case GUS_EVT_FLOW_CTRL_DISABLE:
            transport_flag_set(BLE_FLOW_CTRL_ENABLE, false);
            break;

        case GUS_EVT_TX_FLOW_OFF:
            transport_flag_set(BLE_TX_FLOW_ON, false);
            break;

        case GUS_EVT_TX_FLOW_ON:
            transport_flag_set(BLE_TX_FLOW_ON, true);
            break;

        default:
            break;
    }
}

/**
 *****************************************************************************************
 * @brief Process gus client event.
 *
 * @param[in] p_evt: Pointer to gus client even strcture.
 *****************************************************************************************
 */
static void gus_client_process_event(gus_c_evt_t *p_evt)
{
    switch (p_evt->evt_type)
    {
        case GUS_C_EVT_DISCOVERY_COMPLETE:
            APP_LOG_INFO("Goodix Uart Service discovery completely.");
            g_master_set_cccd_flag = true;
            gus_c_tx_notify_set(p_evt->conn_idx, g_master_set_cccd_flag);
            break;

        case GUS_C_EVT_TX_NTF_SET_SUCCESS:
            APP_LOG_INFO("Enabled TX Notification.");
            transport_flag_set(GUS_TX_NTF_ENABLE, g_master_set_cccd_flag);
            gus_c_flow_ctrl_notify_set(p_evt->conn_idx, true);
            break;

        case GUS_C_EVT_FLOW_CTRL_NTF_SET_SUCCESS:
            APP_LOG_INFO("Enabled Flow Control Notification.");
            transport_flag_set(BLE_FLOW_CTRL_ENABLE, true);
            break;

        case GUS_C_EVT_PEER_DATA_RECEIVE:
            ble_to_uart_buff_data_push(p_evt->p_data, p_evt->length);
            break;

        case GUS_C_EVT_TX_FLOW_OFF:
            transport_flag_set(BLE_TX_FLOW_ON, false);
            break;

        case GUS_C_EVT_TX_FLOW_ON:
            transport_flag_set(BLE_TX_FLOW_ON, true);
            break;

        case GUS_C_EVT_TX_CPLT:
            transport_flag_set(BLE_TX_CPLT, true);
            break;

        default:
            break;
    }
}

static void services_init(void)
{
    gus_init_t gus_init;
    gus_init.evt_handler = gus_service_process_event;
    gus_service_init(&gus_init);
}

/*
 * GLOBAL FUNCTION DEFINITIONS
 ********************************************************************************
 */
void ble_evt_handler(const ble_evt_t *p_evt)
{
    AT_CMD_RSP_DEF(cmd_rsp);

    switch(p_evt->evt_id)
    {
        case BLE_COMMON_EVT_STACK_INIT:
            ble_app_init();
            break;

        case BLE_GAPM_EVT_ADV_START:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                uart_at_dev_state_set(ADVERTISING);
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }
            at_cmd_execute_cplt(&cmd_rsp);
            break;

        case BLE_GAPM_EVT_ADV_STOP:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                if (!is_connected)
                {
                    uart_at_dev_state_set(STANDBY);
                }
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }
            at_cmd_execute_cplt(&cmd_rsp);
            break;
            
        case BLE_GAPM_EVT_SCAN_START:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                uart_at_dev_state_set(SCANNING);
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }
            at_cmd_execute_cplt(&cmd_rsp);
            break;

        case BLE_GAPM_EVT_SCAN_STOP:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                uart_at_dev_state_set(STANDBY);
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }

            at_cmd_execute_cplt(&cmd_rsp);
            break;

        case BLE_GAPM_EVT_ADV_REPORT:
            uart_at_adv_report_task(p_evt->evt.gapm_evt.params.adv_report.data,
                                    p_evt->evt.gapm_evt.params.adv_report.length,
                                    &(p_evt->evt.gapm_evt.params.adv_report.broadcaster_addr));
            break;

        case BLE_GAPC_EVT_CONNECTED:
            if (BLE_SUCCESS != p_evt->evt_status)
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }
            else
            {
                uart_at_conn_task(p_evt->evt.gapc_evt.params.connected.ll_role);
                uart_at_dev_state_set(CONNECTED);
                is_connected = true;

                if (BLE_GAP_LL_ROLE_MASTER == p_evt->evt.gapc_evt.params.connected.ll_role)
                {
                    gus_c_disc_srvc_start(p_evt->evt.gapc_evt.index);
                }
                APP_LOG_INFO("Connected with the peer %02X:%02X:%02X:%02X:%02X:%02X.",
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[5],
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[4],
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[3],
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[2],
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[1],
                                p_evt->evt.gapc_evt.params.connected.peer_addr.addr[0]);
            }
            at_cmd_execute_cplt(&cmd_rsp);
            GLOBAL_EXCEPTION_DISABLE();
            memset(s_uart_to_ble_buffer.p_buffer, 0, sizeof(s_uart_to_ble_buffer.buffer_size));
            memset(s_ble_to_uart_buffer.p_buffer, 0, sizeof(s_ble_to_uart_buffer.buffer_size));
            s_uart_to_ble_buffer.write_index = 0;
            s_uart_to_ble_buffer.read_index  = 0;
            s_ble_to_uart_buffer.write_index = 0;
            s_ble_to_uart_buffer.read_index  = 0;
            transport_flag_set(BLE_TX_CPLT, true);
            transport_flag_set(GUS_TX_NTF_ENABLE, false);
            transport_flag_set(BLE_FLOW_CTRL_ENABLE, false);
            transport_flag_set(BLE_TX_FLOW_ON, true);
            transport_flag_set(BLE_RX_FLOW_ON, true);
            GLOBAL_EXCEPTION_ENABLE();
            break; 

        case BLE_GAPC_EVT_DISCONNECTED:
            if (BLE_SUCCESS != p_evt->evt_status)
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }
            else
            {
                uart_at_dev_state_set(STANDBY);
                APP_LOG_INFO("Disconnected (0x%02X)", p_evt->evt.gapc_evt.params.disconnected.reason);
                
                // 重置连接状态标志
                is_connected = false;
                
                // 清理传输缓冲区
                GLOBAL_EXCEPTION_DISABLE();
                memset(s_uart_to_ble_buffer.p_buffer, 0, sizeof(s_uart_to_ble_buffer.buffer_size));
                memset(s_ble_to_uart_buffer.p_buffer, 0, sizeof(s_ble_to_uart_buffer.buffer_size));
                s_uart_to_ble_buffer.write_index = 0;
                s_uart_to_ble_buffer.read_index  = 0;
                s_ble_to_uart_buffer.write_index = 0;
                s_ble_to_uart_buffer.read_index  = 0;
                
                // 重置传输标志
                transport_flag_set(BLE_TX_CPLT, true);
                transport_flag_set(GUS_TX_NTF_ENABLE, false);
                transport_flag_set(BLE_FLOW_CTRL_ENABLE, false);
                transport_flag_set(BLE_TX_FLOW_ON, true);
                transport_flag_set(BLE_RX_FLOW_ON, true);
                GLOBAL_EXCEPTION_ENABLE();
                
                APP_LOG_INFO("Connection resources cleaned up");
                
                // 延迟重新启动广播以确保完全断开
                sys_delay_ms(100);
                
                // 重新启动广播使设备可以再次被发现和连接
                sdk_err_t err_code = ble_gap_adv_start(0, &g_gap_adv_time_param);
                if (BLE_SUCCESS == err_code)
                {
                    APP_LOG_INFO("Advertising restarted after disconnection");
                    uart_at_dev_state_set(ADVERTISING);
                }
                else
                {
                    APP_LOG_ERROR("Failed to restart advertising: 0x%02X", err_code);
                }
            }
            at_cmd_execute_cplt(&cmd_rsp);
            break;

        case BLE_GAPC_EVT_CONNECT_CANCLE:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                cmd_rsp.length = at_cmd_printf_bush(cmd_rsp.data, "OK");
                uart_at_dev_state_set(STANDBY);
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }

            at_cmd_execute_cplt(&cmd_rsp);
            break;

        case BLE_GAPC_EVT_CONN_PARAM_UPDATE_REQ:
            ble_gap_conn_param_update_reply(p_evt->evt.gapc_evt.index, true);
            break;
        
        case BLE_GATT_COMMON_EVT_MTU_EXCHANGE:
            if (BLE_SUCCESS == p_evt->evt_status)
            {
                update_mtu_size(p_evt->evt.gatt_common_evt.params.mtu_exchange.mtu);
                cmd_rsp.length = at_cmd_printf_bush(cmd_rsp.data, "MTU:%d", p_evt->evt.gatt_common_evt.params.mtu_exchange.mtu);
            }
            else
            {
                cmd_rsp.error_code = at_cmd_ble_err_convert(p_evt->evt_status);
            }

            at_cmd_execute_cplt(&cmd_rsp);
            break;
    }
}

void ble_app_init(void)
{
    ble_gap_bdaddr_t  bd_addr;
    sdk_version_t     version;

    sys_sdk_verison_get(&version);
    APP_LOG_INFO("Goodix BLE SDK V%d.%d.%d (commit %x)",
                 version.major, version.minor, version.build, version.commit_id);

    ble_gap_addr_get(&bd_addr);
    APP_LOG_INFO("Local Board %02X:%02X:%02X:%02X:%02X:%02X.",
                 bd_addr.gap_addr.addr[5],
                 bd_addr.gap_addr.addr[4],
                 bd_addr.gap_addr.addr[3],
                 bd_addr.gap_addr.addr[2],
                 bd_addr.gap_addr.addr[1],
                 bd_addr.gap_addr.addr[0]);
    APP_LOG_INFO("Goodix UART(AT) example start.");

    gap_params_init();
    transport_ble_init();
    transport_uart_init();
    services_init();
    gus_client_init(gus_client_process_event);
    uart_at_init(BLE_GAP_ROLE_PERIPHERAL);
    
    // 初始化BLE协议处理模块
    ble_protocol_init();

    ble_gap_adv_start(0, &g_gap_adv_time_param);
}

/**
 *****************************************************************************************
 * @brief Function for sending JSON data to 4G module via UART1.
 *****************************************************************************************
 */
void uart1_send_json_to_4g(const char* json_data)
{
    if (json_data == NULL)
    {
        APP_LOG_ERROR("Invalid JSON data");
        return;
    }
    
    uint16_t data_len = strlen(json_data);
    APP_LOG_INFO("Sending JSON to 4G module via UART1: %s", json_data);
    
    // Send JSON data via UART1 to 4G module using synchronous transmission
    uart1_tx_data_send((uint8_t*)json_data, data_len);
}

/**
 *****************************************************************************************
 * @brief Update sensor data from sensor parser.
 * 
 * This function updates sensor data in both BLE and 4G protocol modules.
 * It reads the latest sensor data from the parser and updates the corresponding
 * data structures in both protocol handlers.
 *****************************************************************************************
 */
/**
 * @brief 检查传感器数据是否超出阈值，如果超出则立即触发上传
 */
static void check_threshold_and_trigger_upload(const ble_4g_sensor_data_t *p_data)
{
    if (!p_data || !p_data->is_valid) {
        return;
    }
    
    bool threshold_exceeded = false;
    
    // 检查甲烷阈值
    float methane_threshold = shared_params_get_methane_threshold();
    if (p_data->methane_vol >= methane_threshold) {
        APP_LOG_WARNING("Methane threshold exceeded: %.2f >= %.2f %%vol", 
                       p_data->methane_vol, methane_threshold);
        threshold_exceeded = true;
    }
    
    // 检查温度阈值
    int16_t temp_high = shared_params_get_temp_high_threshold();
    int16_t temp_low = shared_params_get_temp_low_threshold();
    
    if (p_data->temperature >= temp_high) {
        APP_LOG_WARNING("High temperature threshold exceeded: %d >= %d °C", 
                       p_data->temperature, temp_high);
        threshold_exceeded = true;
    } else if (p_data->temperature <= temp_low) {
        APP_LOG_WARNING("Low temperature threshold exceeded: %d <= %d °C", 
                       p_data->temperature, temp_low);
        threshold_exceeded = true;
    }
    
    // 如果超出阈值，立即触发数据上传
    if (threshold_exceeded) {
        APP_LOG_INFO("Threshold exceeded - triggering immediate upload");
        
        // 调用专门的立即上传函数，复用现有的上传逻辑
        extern void ble_4g_protocol_trigger_immediate_upload(const ble_4g_sensor_data_t *p_sensor_data);
        ble_4g_protocol_trigger_immediate_upload(p_data);
    }
}

void update_sensor_data_from_parser(void)
{
    sensor_data_t raw_data = {0};
    
    if (sensor_data_get_latest(&raw_data))
    {
        // 读取实际电池电压和电量
        battery_voltage_data_t battery_data = {0};
        float battery_voltage = 3.3f;  // 默认值
        uint8_t battery_percent = 100; // 默认值
        
        if (battery_voltage_reader_get_voltage(&battery_data) && battery_data.is_valid)
        {
            battery_voltage = battery_data.battery_voltage;
            battery_percent = battery_data.battery_percent;
            APP_LOG_DEBUG("Battery data updated: %.3fV, %d%%", battery_voltage, battery_percent);
        }
        else
        {
            APP_LOG_WARNING("Failed to read battery voltage, using default values");
        }
        
        // Update BLE protocol sensor data
        ble_sensor_data_t ble_sensor_data = {0};
        ble_sensor_data.methane_vol = raw_data.concentration;
        ble_sensor_data.methane_lel = ble_protocol_vol_to_lel(raw_data.concentration);
        ble_sensor_data.temperature = raw_data.temperature;
        ble_sensor_data.battery_voltage = battery_voltage;
        ble_sensor_data.battery_percent = battery_percent;
        ble_sensor_data.is_valid = raw_data.data_valid;
        
        // 使用接口函数更新BLE协议数据
        ble_protocol_update_sensor_data(&ble_sensor_data);
        
        // Update 4G protocol sensor data
        ble_4g_sensor_data_t ble_4g_sensor_data = {0};
        ble_4g_sensor_data.methane_vol = raw_data.concentration;
        ble_4g_sensor_data.methane_lel = ble_4g_protocol_vol_to_lel(raw_data.concentration);
        ble_4g_sensor_data.temperature = (int16_t)raw_data.temperature;
        ble_4g_sensor_data.battery_voltage = battery_voltage;
        ble_4g_sensor_data.battery_percent = battery_percent;
        ble_4g_sensor_data.is_valid = raw_data.data_valid;
        
        // 生成收集时间字符串 (格式: YYYYMMDDHHMMSS)
        char timestamp[RTC_TIME_STRING_LEN];
        extern bool get_collection_timestamp_for_4g(char *timestamp_buffer);
        if (get_collection_timestamp_for_4g(timestamp)) {
            strncpy(ble_4g_sensor_data.collect_time, timestamp, sizeof(ble_4g_sensor_data.collect_time) - 1);
            ble_4g_sensor_data.collect_time[sizeof(ble_4g_sensor_data.collect_time) - 1] = '\0';
        } else {
            // 如果RTC获取失败，使用默认时间戳
            strcpy(ble_4g_sensor_data.collect_time, "20000101000000");
        }
        
        // 使用接口函数更新4G协议数据
        ble_4g_protocol_update_sensor_data(&ble_4g_sensor_data);
        
        // 检查是否超出阈值，如果超出则立即触发上传
        check_threshold_and_trigger_upload(&ble_4g_sensor_data);
        
        APP_LOG_INFO("Updated sensor data: CH4=%.2f%%vol/%.2f%%LEL, TEMP=%.1fC", 
                     ble_sensor_data.methane_vol, 
                     ble_sensor_data.methane_lel, 
                     ble_sensor_data.temperature);
    }
}

/**
 *****************************************************************************************
 * @brief 动态更新蓝牙设备名称（基于IMEI后四位）
 * 
 * 此函数检查当前IMEI，如果IMEI后四位与当前蓝牙名称不符，则更新蓝牙名称并重启广播。
 * 调用时机：在IMEI成功获取后调用，例如在4G模块初始化完成后。
 *****************************************************************************************
 */
void update_ble_name_with_imei(void)
{
    static char s_current_ble_name[32] = DEVICE_NAME;  // 保存当前蓝牙名称
    char imei_buffer[32] = {0};
    char new_ble_name[32] = {0};
    
    // 尝试获取IMEI
    if (!ble_protocol_get_imei(imei_buffer, sizeof(imei_buffer)) || strlen(imei_buffer) < 4)
    {
        APP_LOG_DEBUG("IMEI not available yet, keeping current BLE name: %s", s_current_ble_name);
        return;
    }
    
    // 获取IMEI的后四位
    size_t imei_len = strlen(imei_buffer);
    const char *last_four = &imei_buffer[imei_len - 4];
    
    // 构建新的蓝牙名称
    snprintf(new_ble_name, sizeof(new_ble_name), "GAS%s", last_four);
    
    // 检查是否需要更新（名称是否改变）
    if (strcmp(s_current_ble_name, new_ble_name) == 0)
    {
        APP_LOG_DEBUG("BLE name already up-to-date: %s", s_current_ble_name);
        return;
    }
    
    APP_LOG_INFO("Updating BLE name from '%s' to '%s' (IMEI: %s)", 
                 s_current_ble_name, new_ble_name, imei_buffer);
    
    // 更新保存的当前名称
    strncpy(s_current_ble_name, new_ble_name, sizeof(s_current_ble_name) - 1);
    s_current_ble_name[sizeof(s_current_ble_name) - 1] = '\0';
    
    // 如果正在广播，先停止广播
    bool was_advertising = false;
    if (uart_at_dev_state_get() == ADVERTISING)
    {
        was_advertising = true;
        ble_gap_adv_stop(0);
        APP_LOG_INFO("Stopped advertising to update BLE name");
        sys_delay_ms(50);  // 短暂延迟确保广播完全停止
    }
    
    // 更新设备名称
    ble_gap_device_name_set(BLE_GAP_WRITE_PERM_DISABLE, 
                           (uint8_t *)new_ble_name, 
                           strlen(new_ble_name));
    
    // 更新广播响应数据
    uint8_t adv_rsp_data[28] = {0};
    uint8_t name_len = strlen(new_ble_name);
    adv_rsp_data[0] = name_len + 1;
    adv_rsp_data[1] = BLE_GAP_AD_TYPE_COMPLETE_NAME;
    memcpy(&adv_rsp_data[2], new_ble_name, name_len);
    
    ble_gap_adv_data_set(0, BLE_GAP_ADV_DATA_TYPE_SCAN_RSP, adv_rsp_data, name_len + 2);
    
    // 如果之前在广播，重新启动广播
    if (was_advertising)
    {
        sdk_err_t err_code = ble_gap_adv_start(0, &g_gap_adv_time_param);
        if (BLE_SUCCESS == err_code)
        {
            APP_LOG_INFO("Advertising restarted with new BLE name: %s", new_ble_name);
        }
        else
        {
            APP_LOG_ERROR("Failed to restart advertising: 0x%02X", err_code);
        }
    }
    else
    {
        APP_LOG_INFO("BLE name updated to: %s (not advertising)", new_ble_name);
    }
}
