/**
 *****************************************************************************************
 *
 * @file main.c
 *
 * @brief BLE UART AT命令项目主程序实现
 *        这是一个基于汇顶科技(GOODIX)芯片的蓝牙低功耗(BLE)项目，
 *        实现了通过UART接口处理AT命令的功能，支持多角色BLE通信。
 *
 * @details 项目功能概述：
 *          - 支持BLE多角色功能（主设备/从设备）
 *          - 通过UART接口接收和处理AT命令
 *          - 集成传感器数据解析和传输调度
 *          - 实现低功耗管理
 *          - 支持数据校验和完整性检查
 *
 */

/*
 * 头文件包含
 *****************************************************************************************
 */
#include "user_app.h"              // 用户应用层接口，包含BLE事件处理函数
#include "at_cmd.h"                // AT命令处理模块，实现串口AT命令解析和执行
#include "user_periph_setup.h"     // 用户外设初始化配置，包含GPIO、UART等外设设置
#include "sensor_data_parser.h"    // 传感器数据解析模块，处理传感器数据格式转换
#include "transport_scheduler.h"   // 传输调度器，管理数据传输的时序和优先级
#include "ble_protocol.h"          // BLE协议处理模块，包含协议初始化和数据处理函数
#include "gr_includes.h"           // GR系列芯片的通用头文件，包含基础定义
#include "scatter_common.h"        // 内存分散加载通用定义
#include "flash_scatter_config.h"  // Flash内存分散配置，定义代码和数据在Flash中的布局
#include "patch.h"                 // 补丁管理模块，用于运行时代码修复
#include "app_log.h"               // 应用日志模块，提供调试和运行时信息输出
#include "ble_4g_protocol.h"      // 4G协议处理模块，包含4G协议的初始化和数据处理
#include "bm8563_rtc.h"           // RTC时间管理模块，用于时间同步功能
#include "gr55xx_delay.h"         // 延时函数，用于时间同步等待
#include "user_periph_setup.h"    // 外设设置，包含UART发送函数

/*
 * 本地变量定义
 ****************************************************************************************
 */
/**@brief 蓝牙协议栈的堆栈全局变量
 * 
 * STACK_HEAP_INIT宏用于初始化BLE协议栈所需的内存堆表。
 * 这个堆表定义了协议栈运行时所需的各种内存区域，包括：
 * - 协议栈内核内存
 * - 连接管理内存
 * - GATT服务内存
 * - 广播和扫描缓冲区
 * 
 * heaps_table是一个全局的内存堆配置表，在ble_stack_init()中会被传递给协议栈。
 */
STACK_HEAP_INIT(heaps_table);

/**
 * @brief 主函数 - BLE UART AT命令项目的程序入口点
 * 
 * 程序执行流程：
 * 1. 初始化用户外设（GPIO、UART、定时器等）
 * 2. 初始化BLE协议栈和事件处理机制
 * 3. 执行传感器数据校验测试
 * 4. 进入主循环，处理各种任务调度
 * 
 * @return int 程序退出码（实际上程序永远不会退出主循环）
 */
int main(void)
{
    // 第一步：初始化用户外设
			// 配置GPIO引脚、UART通信接口、定时器、中断等硬件资源
    app_periph_init();
    

    // 第二步：初始化BLE协议栈
    // 传入BLE事件处理函数和内存堆配置表，启动蓝牙功能
    // ble_evt_handler: BLE事件回调函数，处理连接、断开、数据收发等事件
    // &heaps_table: 协议栈内存配置，定义各种缓冲区大小
    ble_stack_init(ble_evt_handler, &heaps_table);

    // 第三步：初始化BLE协议处理
    // 初始化协议处理模块，准备接收和处理JSON命令
    ble_protocol_init();
    APP_LOG_INFO("BLE protocol initialized");

    // 第3.5步：时间同步 - 向DTU发送超级指令获取网络时间并同步到RTC
    // 首先初始化RTC芯片
    if (!bm8563_init()) {
        APP_LOG_ERROR("Failed to initialize RTC chip");
    } else {
        APP_LOG_INFO("RTC chip initialized successfully");
    }
    
    // 等待DTU完全初始化完成
    delay_ms(3000);
    APP_LOG_INFO("Starting time synchronization with DTU...");
    
    // 多次尝试时间同步，确保成功
    bool time_sync_success = false;
    for (int retry = 0; retry < 3 && !time_sync_success; retry++) {
        APP_LOG_INFO("Time sync attempt %d/3", retry + 1);
        
        // 向DTU发送获取网络时间的超级指令
        const char* time_sync_cmd = "adminAT+CCLK?\r\n";
        uart1_tx_data_send((uint8_t*)time_sync_cmd, strlen(time_sync_cmd));
        APP_LOG_INFO("Sent time sync command to DTU: %s", time_sync_cmd);
        
        // 等待DTU响应并处理时间同步（响应将在UART接收中断中处理）
        delay_ms(10000);  // 增加等待时间
        
        // 检查时间同步是否成功
        char rtc_time_check[RTC_TIME_STRING_LEN];
        if (bm8563_get_time_string(rtc_time_check)) {
            // 检查是否不再是默认的2000年时间
            if (strncmp(rtc_time_check, "2000", 4) != 0) {
                time_sync_success = true;
                APP_LOG_INFO("Time synchronization successful! RTC time: %s", rtc_time_check);
                break;
            } else {
                APP_LOG_WARNING("Time sync attempt %d failed, RTC still shows default time: %s", retry + 1, rtc_time_check);
            }
        } else {
            APP_LOG_WARNING("Time sync attempt %d failed, cannot read RTC time", retry + 1);
        }
        
        if (retry < 2) {
            delay_ms(2000);  // 重试前等待
        }
    }
    
    if (!time_sync_success) {
        APP_LOG_ERROR("Time synchronization failed after 3 attempts, continuing with default time");
    }

    // 第四步：启动时运行传感器数据校验测试
    // 验证传感器数据的完整性和校验和算法的正确性
    APP_LOG_INFO("Running sensor checksum validation test...");
    sensor_data_test_checksum();

    // 初始化4G协议 
     ble_4g_protocol_init();

    // 启动定时器 
     ble_4g_protocol_start_collect_timer();  // 启动采集定时器
     ble_4g_protocol_start_report_timer();   // 启动上报定时器

    // 第四步：进入主循环 - 系统核心调度循环
    // 这是一个无限循环，系统将在这里处理所有的任务调度
    while (1)
    {
        // 任务1：刷新应用日志缓冲区
        // 将缓存的日志信息输出到调试接口，避免日志丢失
        app_log_flush();
        
        // 任务2：AT命令调度处理
        // 检查UART接收缓冲区，解析并执行AT命令
        // 支持的AT命令包括：连接控制、参数设置、状态查询等
        at_cmd_schedule();
        
        // 任务3：传输调度管理
        // 管理BLE数据传输的时序，处理发送队列和重传机制
        // 确保数据传输的可靠性和效率
        transport_schedule();
        
        // 任务4：UART轮询任务
        // 处理UART数据的回显功能，实现串口通信的双向确认
        uart_polling_task(); // Polling UART for echo
        
        // 任务5：电源管理调度
        // 根据系统状态进入相应的低功耗模式，延长电池续航
        // 在无活动时自动进入睡眠模式，有事件时快速唤醒
        pwr_mgmt_schedule();
    }
}
