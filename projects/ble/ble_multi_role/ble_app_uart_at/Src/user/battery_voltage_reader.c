/**
 *****************************************************************************************
 *
 * @file battery_voltage_reader_app.c
 *
 * @brief 电池电压读取实现（使用APP层ADC驱动）
 *        使用SDK提供的app_adc驱动，避免手动计算电压
 *
 *****************************************************************************************
 */

/*
 * INCLUDE FILES
 *****************************************************************************************
 */
#include "battery_voltage_reader.h"
#include "app_io.h"
#include "app_log.h"

#include <string.h>

// ADC相关头文件包含
#include "app_adc.h"
#include "app_adc_dma.h"
#include "gr55xx_hal_msio.h"    // MSIO_PIN_0/1定义

/*
 * DEFINES
 *****************************************************************************************
 */
#define ADC_SAMPLE_COUNT        128     /**< ADC采样次数（与官方示例一致） */
#define ADC_TIMEOUT_MS          1000    /**< ADC超时时间(ms) */

/*
 * LOCAL VARIABLE DEFINITIONS
 *****************************************************************************************
 */
static bool s_voltage_reader_initialized = false;
uint16_t s_adc_buffer[ADC_SAMPLE_COUNT];
double s_voltage_buffer[ADC_SAMPLE_COUNT];
volatile uint16_t s_adc_conv_done = 0;

/*
 * LOCAL FUNCTION DECLARATIONS
 *****************************************************************************************
 */
static float battery_voltage_apply_calibration(float raw_voltage);
static uint8_t battery_voltage_calculate_percent(float voltage);
static void battery_adc_evt_handler(app_adc_evt_t *p_evt);

/*
 * FUNCTION DEFINITIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief ADC事件处理回调
 *****************************************************************************************
 */
static void battery_adc_evt_handler(app_adc_evt_t *p_evt)
{
    if (p_evt->type == APP_ADC_EVT_CONV_CPLT)
    {
        s_adc_conv_done = 1;
    }
}

/**
 *****************************************************************************************
 * @brief 初始化电池电压读取模块
 *
 * @return true  初始化成功
 * @return false 初始化失败
 *****************************************************************************************
 */
bool battery_voltage_reader_init(void)
{
    if (s_voltage_reader_initialized)
    {
        return true;
    }
    
    s_voltage_reader_initialized = true;
    return true;
}

/**
 *****************************************************************************************
 * @brief 反初始化电池电压读取模块
 *****************************************************************************************
 */
void battery_voltage_reader_deinit(void)
{
    if (!s_voltage_reader_initialized)
    {
        return;
    }
    
    app_adc_deinit();
    s_voltage_reader_initialized = false;
}

/**
 *****************************************************************************************
 * @brief 读取电池电压
 *
 * @param[out] p_voltage_data 电压数据结构体指针
 *
 * @return true  读取成功
 * @return false 读取失败
 *****************************************************************************************
 */
bool battery_voltage_reader_get_voltage(battery_voltage_data_t *p_voltage_data)
{
    if (!s_voltage_reader_initialized || p_voltage_data == NULL)
    {
        return false;
    }
    
    memset(p_voltage_data, 0, sizeof(battery_voltage_data_t));

    
    // 配置ADC参数（严格按照SDK示例配置）
    app_adc_params_t adc_params = {
        .pin_cfg = {
            .channel_p = {
                .type = APP_IO_TYPE_MSIO,
                .mux  = APP_IO_MUX_7,
                .pin  = MSIO_PIN_0,     // 使用MSIO_PIN_0而不是APP_IO_PIN_0
            },
            .channel_n = {
                .type = APP_IO_TYPE_MSIO,
                .mux  = APP_IO_MUX_7,
                .pin  = MSIO_PIN_1,     // 使用MSIO_PIN_1而不是APP_IO_PIN_1
            },
        },
        .dma_cfg = {
            .dma_instance = DMA0,
            .dma_channel  = DMA_Channel1,
        },
        .init = {
            .channel_p  = ADC_INPUT_SRC_IO0,
            .channel_n  = ADC_INPUT_SRC_IO1,
            .input_mode = ADC_INPUT_SINGLE,
            .ref_source = ADC_REF_SRC_BUF_INT,
            .ref_value  = ADC_REF_VALUE_1P6,
            .clock      = ADC_CLK_1M,
        },
    };
    
    uint16_t ret = app_adc_init(&adc_params, battery_adc_evt_handler);
    if (ret != APP_DRV_SUCCESS)
    {
        return false;
    }
    ret = app_adc_dma_init(&adc_params);
    if (ret != APP_DRV_SUCCESS)
    {
        app_adc_deinit();
        return false;
    }
    
    memset(s_adc_buffer, 0, sizeof(s_adc_buffer));
    
    s_adc_conv_done = 0;
    app_adc_dma_conversion_async(s_adc_buffer, ADC_SAMPLE_COUNT);
    while(s_adc_conv_done == 0);
    
    app_adc_voltage_intern(s_adc_buffer, s_voltage_buffer, ADC_SAMPLE_COUNT);
    
    // 计算平均电压
    double adc_voltage_sum = 0.0;
    for (uint16_t i = 0; i < ADC_SAMPLE_COUNT; i++)
    {
        adc_voltage_sum += s_voltage_buffer[i];
    }
    float adc_voltage_avg = (float)(adc_voltage_sum / ADC_SAMPLE_COUNT);
    
    // 通过分压比还原电池电压
    float battery_voltage_raw = adc_voltage_avg * VOLTAGE_DIVIDER_RATIO;
    float battery_voltage = battery_voltage_apply_calibration(battery_voltage_raw);
    uint8_t battery_percent = battery_voltage_calculate_percent(battery_voltage);
    
    p_voltage_data->battery_voltage = battery_voltage;
    p_voltage_data->battery_percent = battery_percent;
    p_voltage_data->adc_raw_value = 0;
    p_voltage_data->raw_voltage = adc_voltage_avg;
    p_voltage_data->is_valid = true;
    
    app_adc_dma_deinit();
    app_adc_deinit();

    
    return true;
}

/**
 *****************************************************************************************
 * @brief 应用电压校准
 *
 * @param[in] raw_voltage 原始电压值
 *
 * @return 校准后的电压值
 *****************************************************************************************
 */
static float battery_voltage_apply_calibration(float raw_voltage)
{
#if ENABLE_PIECEWISE_CALIBRATION
    // 三点分段线性校准
    if (raw_voltage <= CALIB_POINT1_MEAS)
    {
        // 低于第一个校准点，使用第一段斜率
        float slope = (CALIB_POINT2_REAL - CALIB_POINT1_REAL) / 
                      (CALIB_POINT2_MEAS - CALIB_POINT1_MEAS);
        return CALIB_POINT1_REAL + slope * (raw_voltage - CALIB_POINT1_MEAS);
    }
    else if (raw_voltage <= CALIB_POINT2_MEAS)
    {
        // 第一段：6.0V ~ 7.2V
        float slope = (CALIB_POINT2_REAL - CALIB_POINT1_REAL) / 
                      (CALIB_POINT2_MEAS - CALIB_POINT1_MEAS);
        return CALIB_POINT1_REAL + slope * (raw_voltage - CALIB_POINT1_MEAS);
    }
    else if (raw_voltage <= CALIB_POINT3_MEAS)
    {
        // 第二段：7.2V ~ 8.4V
        float slope = (CALIB_POINT3_REAL - CALIB_POINT2_REAL) / 
                      (CALIB_POINT3_MEAS - CALIB_POINT2_MEAS);
        return CALIB_POINT2_REAL + slope * (raw_voltage - CALIB_POINT2_MEAS);
    }
    else
    {
        // 高于第三个校准点，使用第二段斜率外推
        float slope = (CALIB_POINT3_REAL - CALIB_POINT2_REAL) / 
                      (CALIB_POINT3_MEAS - CALIB_POINT2_MEAS);
        return CALIB_POINT3_REAL + slope * (raw_voltage - CALIB_POINT3_MEAS);
    }
#else
    // 不使用校准，直接返回原始值
    return raw_voltage;
#endif
}

/**
 *****************************************************************************************
 * @brief 计算电池电量百分比
 *
 * @param[in] voltage 电池电压
 *
 * @return 电量百分比 (0-100)
 *****************************************************************************************
 */
static uint8_t battery_voltage_calculate_percent(float voltage)
{
    if (voltage <= BATTERY_VOLTAGE_MIN)
    {
        return 0;
    }
    else if (voltage >= BATTERY_VOLTAGE_MAX)
    {
        return 100;
    }
    else
    {
        float percent = ((voltage - BATTERY_VOLTAGE_MIN) / 
                        (BATTERY_VOLTAGE_MAX - BATTERY_VOLTAGE_MIN)) * 100.0f;
        return (uint8_t)percent;
    }
}

/**
 *****************************************************************************************
 * @brief 通过BLE发送电池电压日志
 *
 * @param[in] p_voltage_data 电池电压数据结构指针
 *****************************************************************************************
 */
void battery_voltage_send_ble_log(const battery_voltage_data_t *p_voltage_data)
{
    if (p_voltage_data == NULL || !p_voltage_data->is_valid)
    {
        APP_LOG_INFO("[BATTERY] Invalid voltage data");
        return;
    }
    
    // 通过BLE日志发送电池电压信息
    APP_LOG_INFO("[BATTERY] Voltage: %.2fV, Percent: %u%%, ADC: %u (%.3fV)",
                 p_voltage_data->battery_voltage,
                 p_voltage_data->battery_percent,
                 p_voltage_data->adc_raw_value,
                 p_voltage_data->raw_voltage);
}


