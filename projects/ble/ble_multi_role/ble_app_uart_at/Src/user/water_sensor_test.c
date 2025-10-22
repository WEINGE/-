/**
 *****************************************************************************************
 *
 * @file water_sensor_test.c
 *
 * @brief 水浸传感器测试代码
 *        用于验证水浸传感器功能是否正常
 *
 * @details 使用方法：
 *          在main函数或初始化完成后调用 water_sensor_run_basic_test()
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "water_sensor.h"
#include "shared_params.h"
#include "app_log.h"
#include "grx_sys.h"

/*
 * TEST FUNCTIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief 基础功能测试
 *****************************************************************************************
 */
void water_sensor_run_basic_test(void)
{
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Water Sensor Basic Test Start");
    APP_LOG_INFO("========================================");
    
    // 测试1：检查初始化状态
    APP_LOG_INFO("Test 1: Check initialization status");
    if (water_sensor_is_working()) {
        APP_LOG_INFO("  [OK] Water sensor is working");
    } else {
        APP_LOG_ERROR("  [FAIL] Water sensor is NOT working!");
        return;
    }
    
    // 测试2：读取当前状态
    APP_LOG_INFO("Test 2: Read current status");
    uint8_t status = water_sensor_get_status();
    APP_LOG_INFO("  Current status: %s (%d)", 
                 status == 0 ? "DRY (Not Flooded)" : "WET (Flooded)", 
                 status);
    
    // 测试3：检查共享参数同步
    APP_LOG_INFO("Test 3: Check shared params sync");
    APP_LOG_INFO("  shared_params.device_water = %d", g_shared_params.device_water);
    if (g_shared_params.device_water == status) {
        APP_LOG_INFO("  [OK] Shared params synchronized");
    } else {
        APP_LOG_WARNING("  [FAIL] Shared params NOT synchronized!");
    }
    
    // 测试4：连续读取测试（10次）
    APP_LOG_INFO("Test 4: Continuous reading test (10 times)");
    for (int i = 0; i < 10; i++) {
        uint8_t current_status = water_sensor_get_status();
        APP_LOG_INFO("  Reading %d: %s", i, 
                     current_status == 0 ? "DRY" : "WET");
        sys_delay_ms(100);
    }
    
    // 测试5：完整数据读取
    APP_LOG_INFO("Test 5: Full data reading");
    water_sensor_data_t sensor_data;
    if (water_sensor_read_status(&sensor_data)) {
        water_sensor_print_status(&sensor_data);
    } else {
        APP_LOG_ERROR("  [FAIL] Failed to read sensor data");
    }
    
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Water Sensor Basic Test Complete");
    APP_LOG_INFO("========================================");
}

/**
 *****************************************************************************************
 * @brief 状态变化检测测试
 * 
 * @details 此函数应在主循环中周期性调用，用于检测水浸状态变化
 *****************************************************************************************
 */
void water_sensor_monitor_status_change(void)
{
    static uint8_t last_status = 0xFF;  // 初始值设为无效值
    static bool first_run = true;
    
    uint8_t current_status = water_sensor_get_status();
    
    if (first_run) {
        last_status = current_status;
        first_run = false;
        APP_LOG_INFO("[WATER_MONITOR] Initial status: %s", 
                     current_status == 0 ? "DRY" : "WET");
        return;
    }
    
    // 检测状态变化
    if (current_status != last_status) {
        APP_LOG_WARNING("========================================");
        APP_LOG_WARNING("  WATER SENSOR STATUS CHANGED!");
        APP_LOG_WARNING("  %s -> %s",
                       last_status == 0 ? "DRY" : "WET",
                       current_status == 0 ? "DRY" : "WET");
        APP_LOG_WARNING("========================================");
        
        // 更新共享参数
        shared_params_set_device_water(current_status);
        
        // 如果检测到浸水，可以触发报警
        if (current_status == WATER_SENSOR_STATUS_WET) {
            APP_LOG_ERROR("!!! WATER FLOODING DETECTED !!!");
            // TODO: 触发立即上报
            // ble_4g_protocol_trigger_immediate_upload();
        } else {
            APP_LOG_INFO("Water status back to normal");
        }
        
        last_status = current_status;
    }
}

/**
 *****************************************************************************************
 * @brief 硬件验证测试
 * 
 * @details 此测试用于验证硬件连接是否正确
 *          测试步骤：
 *          1. 正常状态下应显示 DRY
 *          2. 将 AON_GPIO_7 短接到 GND，应显示 WET
 *          3. 断开短接，应恢复到 DRY
 *****************************************************************************************
 */
void water_sensor_hardware_validation_test(void)
{
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Water Sensor Hardware Validation");
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("");
    APP_LOG_INFO("Test Instructions:");
    APP_LOG_INFO("1. Observe current status (should be DRY)");
    APP_LOG_INFO("2. Short AON_GPIO_7 to GND");
    APP_LOG_INFO("3. Observe status change to WET");
    APP_LOG_INFO("4. Remove short circuit");
    APP_LOG_INFO("5. Observe status back to DRY");
    APP_LOG_INFO("");
    APP_LOG_INFO("Starting continuous monitoring...");
    APP_LOG_INFO("(Press reset to stop)");
    APP_LOG_INFO("========================================");
    
    uint8_t last_status = 0xFF;
    
    while (1) {
        uint8_t current_status = water_sensor_get_status();
        
        if (current_status != last_status) {
            APP_LOG_INFO(">>> Status: %s (%d) <<<", 
                         current_status == 0 ? "DRY" : "WET",
                         current_status);
            last_status = current_status;
        }
        
        sys_delay_ms(200);
    }
}

/**
 *****************************************************************************************
 * @brief 电源状态检查测试
 *****************************************************************************************
 */
void water_sensor_power_status_test(void)
{
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Water Sensor Power Status Test");
    APP_LOG_INFO("========================================");
    
    bool power_on = water_sensor_get_power_status();
    APP_LOG_INFO("Power status: %s", power_on ? "ON" : "OFF");
    
    if (power_on) {
        APP_LOG_INFO("[OK] Power is ON (as expected for always-on mode)");
    } else {
        APP_LOG_ERROR("[FAIL] Power is OFF (unexpected!)");
    }
    
    APP_LOG_INFO("========================================");
}

/**
 *****************************************************************************************
 * @brief 共享参数同步测试
 *****************************************************************************************
 */
void water_sensor_shared_params_sync_test(void)
{
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Shared Params Sync Test");
    APP_LOG_INFO("========================================");
    
    // 读取传感器状态
    uint8_t sensor_status = water_sensor_get_status();
    APP_LOG_INFO("Sensor reading: %d (%s)", 
                 sensor_status,
                 sensor_status == 0 ? "DRY" : "WET");
    
    // 更新到共享参数
    shared_params_set_device_water(sensor_status);
    
    // 读取共享参数
    uint8_t shared_status = g_shared_params.device_water;
    APP_LOG_INFO("Shared params: %d (%s)", 
                 shared_status,
                 shared_status == 0 ? "DRY" : "WET");
    
    // 验证同步
    if (sensor_status == shared_status) {
        APP_LOG_INFO("[OK] Synchronization successful");
    } else {
        APP_LOG_ERROR("[FAIL] Synchronization failed!");
    }
    
    APP_LOG_INFO("========================================");
}

/**
 *****************************************************************************************
 * @brief 运行所有测试
 *****************************************************************************************
 */
void water_sensor_run_all_tests(void)
{
    APP_LOG_INFO("\n\n");
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  Water Sensor Complete Test Suite");
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("\n");
    
    // 延时确保系统稳定
    sys_delay_ms(1000);
    
    // 运行各项测试
    water_sensor_run_basic_test();
    sys_delay_ms(500);
    
    water_sensor_power_status_test();
    sys_delay_ms(500);
    
    water_sensor_shared_params_sync_test();
    sys_delay_ms(500);
    
    APP_LOG_INFO("\n");
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("  All Tests Completed");
    APP_LOG_INFO("========================================");
    APP_LOG_INFO("\n\n");
}

