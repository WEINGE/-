/**
 * @file battery_voltage_reader.c
 * @brief 电池电压读取实现（APP层ADC驱动）
 */

#include "battery_voltage_reader.h"
#include "app_io.h"
#include "app_log.h"
#include "app_adc.h"
#include "app_adc_dma.h"
#include "gr55xx_hal_msio.h"
#include <string.h>

/*==============================================================================
 *                              宏定义
 *============================================================================*/
#define ADC_SAMPLE_COUNT    128

/*==============================================================================
 *                              局部变量
 *============================================================================*/
static bool s_initialized = false;
static uint16_t s_adc_buffer[ADC_SAMPLE_COUNT];
static double   s_voltage_buffer[ADC_SAMPLE_COUNT];
static volatile uint16_t s_adc_done = 0;

/*==============================================================================
 *                              局部函数声明
 *============================================================================*/
static float  apply_calibration(float raw_voltage);
static uint8_t calc_percent(float voltage);

/*==============================================================================
 *                              ADC回调
 *============================================================================*/
static void adc_evt_handler(app_adc_evt_t *p_evt)
{
    if (p_evt->type == APP_ADC_EVT_CONV_CPLT) {
        s_adc_done = 1;
    }
}

/*==============================================================================
 *                              初始化/反初始化
 *============================================================================*/
bool battery_voltage_reader_init(void)
{
    if (s_initialized) return true;
    s_initialized = true;
    return true;
}

void battery_voltage_reader_deinit(void)
{
    if (!s_initialized) return;
    app_adc_deinit();
    s_initialized = false;
}

/*==============================================================================
 *                              电压读取
 *============================================================================*/
bool battery_voltage_reader_get_voltage(battery_voltage_data_t *p_data)
{
    if (!s_initialized || !p_data) return false;
    
    memset(p_data, 0, sizeof(battery_voltage_data_t));

    // ADC配置
    app_adc_params_t params = {
        .pin_cfg = {
            .channel_p = {APP_IO_TYPE_MSIO, APP_IO_MUX_7, MSIO_PIN_0},
            .channel_n = {APP_IO_TYPE_MSIO, APP_IO_MUX_7, MSIO_PIN_1},
        },
        .dma_cfg = {DMA0, DMA_Channel1},
        .init = {
            .channel_p  = ADC_INPUT_SRC_IO0,
            .channel_n  = ADC_INPUT_SRC_IO1,
            .input_mode = ADC_INPUT_SINGLE,
            .ref_source = ADC_REF_SRC_BUF_INT,
            .ref_value  = ADC_REF_VALUE_1P6,
            .clock      = ADC_CLK_1M,
        },
    };
    
    // 初始化ADC
    if (app_adc_init(&params, adc_evt_handler) != APP_DRV_SUCCESS) return false;
    if (app_adc_dma_init(&params) != APP_DRV_SUCCESS) {
        app_adc_deinit();
        return false;
    }
    
    // DMA采样
    memset(s_adc_buffer, 0, sizeof(s_adc_buffer));
    s_adc_done = 0;
    app_adc_dma_conversion_async(s_adc_buffer, ADC_SAMPLE_COUNT);
    while (!s_adc_done);
    
    // 转换为电压并计算平均值
    app_adc_voltage_intern(s_adc_buffer, s_voltage_buffer, ADC_SAMPLE_COUNT);
    double sum = 0.0;
    for (uint16_t i = 0; i < ADC_SAMPLE_COUNT; i++) {
        sum += s_voltage_buffer[i];
    }
    float adc_avg = (float)(sum / ADC_SAMPLE_COUNT);
    
    // 计算电池电压
    float raw_voltage = adc_avg * VOLTAGE_DIVIDER_RATIO;
    p_data->battery_voltage = apply_calibration(raw_voltage);
    p_data->battery_percent = calc_percent(p_data->battery_voltage);
    p_data->raw_voltage = adc_avg;
    p_data->is_valid = true;
    
    app_adc_dma_deinit();
    app_adc_deinit();
    return true;
}

/*==============================================================================
 *                              校准与计算
 *============================================================================*/
static float apply_calibration(float raw)
{
#if ENABLE_PIECEWISE_CALIBRATION
    float slope;
    if (raw <= CALIB_POINT2_MEAS) {
        slope = (CALIB_POINT2_REAL - CALIB_POINT1_REAL) / (CALIB_POINT2_MEAS - CALIB_POINT1_MEAS);
        return CALIB_POINT1_REAL + slope * (raw - CALIB_POINT1_MEAS);
    } else {
        slope = (CALIB_POINT3_REAL - CALIB_POINT2_REAL) / (CALIB_POINT3_MEAS - CALIB_POINT2_MEAS);
        return CALIB_POINT2_REAL + slope * (raw - CALIB_POINT2_MEAS);
    }
#else
    return raw;
#endif
}

static uint8_t calc_percent(float voltage)
{
    if (voltage <= BATTERY_VOLTAGE_MIN) return 0;
    if (voltage >= BATTERY_VOLTAGE_MAX) return 100;
    return (uint8_t)(((voltage - BATTERY_VOLTAGE_MIN) / 
                      (BATTERY_VOLTAGE_MAX - BATTERY_VOLTAGE_MIN)) * 100.0f);
}

/*==============================================================================
 *                              日志输出
 *============================================================================*/
void battery_voltage_send_ble_log(const battery_voltage_data_t *p_data)
{
    if (!p_data || !p_data->is_valid) return;
    APP_LOG_INFO("[BAT] %.2fV %u%%", p_data->battery_voltage, p_data->battery_percent);
}


