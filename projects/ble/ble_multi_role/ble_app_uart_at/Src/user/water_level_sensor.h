/**
 *****************************************************************************************
 *
 * @file water_level_sensor.h
 *
 * @brief MER-MCP1081-22-150 电子水尺液位传感模组驱动头文件
 *
 * @details 技术规格：
 *          - 供电电压：2.3V~5.5V
 *          - 感应距离：0mm~12mm非金属介质
 *          - 液位测量范围：0~125mm
 *          - 液位精度：±3mm
 *          - 液位分辨率：1mm
 *          - 档位：0~7档
 *          - 工作温度范围：-40℃~+85℃
 *          - 输出方式：UART (9600bps, 8N1)
 *          - 通信协议：Modbus-RTU
 *
 * @attention
 *  Copyright (c) 2025 GOODIX
 *  All rights reserved.
 *
 *****************************************************************************************
 */

#ifndef __WATER_LEVEL_SENSOR_H__
#define __WATER_LEVEL_SENSOR_H__

#include <stdint.h>
#include <stdbool.h>

/*
 * DEFINES - Modbus协议参数
 *****************************************************************************************
 */
#define WLS_MODBUS_SLAVE_ADDR           0x01    /**< 从机地址（出厂默认0x01） */
#define WLS_MODBUS_FUNC_READ            0x03    /**< 功能码：读取寄存器数据 */
#define WLS_MODBUS_FUNC_WRITE           0x06    /**< 功能码：写单个寄存器 */

/**@brief Modbus寄存器地址定义 */
#define WLS_REG_AVG_SAMPLES             0x0003  /**< 采集平均次数 (R/W, 1~20) */
#define WLS_REG_LEVEL_GRADE             0x0004  /**< 液位档位 (R, 0~6) */
#define WLS_REG_CALIBRATION             0x0006  /**< 校准指令 (R/W, 0~1) */
#define WLS_REG_TEMPERATURE             0x0007  /**< 温度 (R, *10, ℃) */
#define WLS_REG_C0                      0x0008  /**< 电容C0 (R, *1000, pF) */
#define WLS_REG_C1                      0x0009  /**< 电容C1 */
#define WLS_REG_C2                      0x000A  /**< 电容C2 */
#define WLS_REG_C3                      0x000B  /**< 电容C3 */
#define WLS_REG_C4                      0x000C  /**< 电容C4 */
#define WLS_REG_C5                      0x000D  /**< 电容C5 */
#define WLS_REG_C6                      0x000E  /**< 电容C6 */
#define WLS_REG_FRE                     0x000F  /**< 参比频率FRE (R, *1000, MHz) */
#define WLS_REG_F0                      0x0010  /**< 频率F0 */
#define WLS_REG_F1                      0x0011  /**< 频率F1 */
#define WLS_REG_F2                      0x0012  /**< 频率F2 */
#define WLS_REG_F3                      0x0013  /**< 频率F3 */
#define WLS_REG_F4                      0x0014  /**< 频率F4 */
#define WLS_REG_F5                      0x0015  /**< 频率F5 */
#define WLS_REG_F6                      0x0016  /**< 频率F6 */
#define WLS_REG_COUNT10                 0x0017  /**< COUNT10 (内部参比通道原始值) */
#define WLS_REG_COUNT0                  0x0018  /**< COUNT0 */
#define WLS_REG_COUNT1                  0x0019  /**< COUNT1 */
#define WLS_REG_COUNT2                  0x001A  /**< COUNT2 */
#define WLS_REG_COUNT3                  0x001B  /**< COUNT3 */
#define WLS_REG_COUNT4                  0x001C  /**< COUNT4 */
#define WLS_REG_COUNT5                  0x001D  /**< COUNT5 */
#define WLS_REG_COUNT6                  0x001E  /**< COUNT6 */

/**@brief 通信参数 */
#define WLS_UART_BAUD_RATE              9600    /**< UART波特率 */
#define WLS_UART_DATA_BITS              8       /**< 数据位 */
#define WLS_UART_STOP_BITS              1       /**< 停止位 */
#define WLS_UART_PARITY                 0       /**< 无校验位 */

/**@brief 超时参数 */
#define WLS_TX_TIMEOUT_MS               100     /**< 发送超时(ms) */
#define WLS_RX_TIMEOUT_MS               500     /**< 接收超时(ms) */
#define WLS_RESPONSE_DELAY_MS           300     /**< 发送后等待响应延时(ms) */

/**@brief 缓冲区大小 */
#define WLS_TX_BUFFER_SIZE              16      /**< 发送缓冲区大小 */
#define WLS_RX_BUFFER_SIZE              64      /**< 接收缓冲区大小 */

/**@brief 液位档位定义 */
#define WLS_LEVEL_GRADE_0               0       /**< 档位0 (最低) */
#define WLS_LEVEL_GRADE_1               1       /**< 档位1 */
#define WLS_LEVEL_GRADE_2               2       /**< 档位2 */
#define WLS_LEVEL_GRADE_3               3       /**< 档位3 */
#define WLS_LEVEL_GRADE_4               4       /**< 档位4 */
#define WLS_LEVEL_GRADE_5               5       /**< 档位5 */
#define WLS_LEVEL_GRADE_6               6       /**< 档位6 (最高) */

/**@brief 档位转换常量 */
#define WLS_MM_PER_GRADE                18.0f   /**< 每档对应18mm水位 */
#define WLS_CM_PER_GRADE                1.8f    /**< 每档对应1.8cm水位 */
#define WLS_GRADE_TO_MM(grade)          ((float)(grade) * WLS_MM_PER_GRADE)  /**< 档位转mm */
#define WLS_GRADE_TO_CM(grade)          ((float)(grade) * WLS_CM_PER_GRADE)  /**< 档位转cm */
#define WLS_MAX_HEIGHT_MM               126.0f  /**< 最大水位高度 (7档 * 18mm) */
#define WLS_MAX_HEIGHT_CM               12.6f   /**< 最大水位高度 (7档 * 1.8cm) */

/**@brief 错误码定义 */
#define WLS_ERR_NONE                    0       /**< 无错误 */
#define WLS_ERR_NOT_INIT                1       /**< 未初始化 */
#define WLS_ERR_INVALID_PARAM           2       /**< 参数无效 */
#define WLS_ERR_TX_FAILED               3       /**< 发送失败 */
#define WLS_ERR_RX_TIMEOUT              4       /**< 接收超时 */
#define WLS_ERR_CRC_FAILED              5       /**< CRC校验失败 */
#define WLS_ERR_INVALID_RESPONSE        6       /**< 无效响应 */

/*
 * STRUCTURES
 *****************************************************************************************
 */

/**@brief 水位传感器基础数据结构 */
typedef struct
{
    uint8_t     level_grade;            /**< 液位档位 (0~6) */
    int16_t     temperature_raw;        /**< 原始温度值 (*10) */
    float       temperature_c;          /**< 温度 (℃) */
    bool        is_valid;               /**< 数据有效标志 */
    uint32_t    timestamp;              /**< 时间戳 */
} water_level_data_t;

/**@brief 水位传感器电容数据结构 */
typedef struct
{
    uint16_t    c[7];                   /**< 电容值C0~C6 (原始值, *1000 pF) */
    float       c_pf[7];                /**< 电容值C0~C6 (pF) */
    bool        is_valid;               /**< 数据有效标志 */
} water_level_cap_data_t;

/**@brief 水位传感器频率数据结构 */
typedef struct
{
    uint16_t    fre;                    /**< 参比频率FRE (原始值, *1000 MHz) */
    uint16_t    f[7];                   /**< 频率F0~F6 (原始值, *1000 MHz) */
    float       fre_mhz;                /**< 参比频率 (MHz) */
    float       f_mhz[7];               /**< 频率F0~F6 (MHz) */
} water_level_freq_data_t;

/**@brief 水位传感器计数数据结构 */
typedef struct
{
    uint16_t    count10;                /**< COUNT10 (内部参比通道原始值) */
    uint16_t    count[7];               /**< COUNT0~COUNT6 */
} water_level_count_data_t;

/**@brief 水位传感器完整数据结构 */
typedef struct
{
    water_level_data_t      basic;      /**< 基础数据 */
    water_level_cap_data_t  cap;        /**< 电容数据 */
    water_level_freq_data_t freq;       /**< 频率数据 */
    water_level_count_data_t count;     /**< 计数数据 */
    uint8_t                 error_code; /**< 错误码 */
} water_level_full_data_t;

/*
 * FUNCTION DECLARATIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief 初始化水位传感器模块
 *
 * @details 初始化UART0用于与水位传感器通信
 *          配置参数：9600bps, 8N1, Modbus-RTU协议
 *
 * @return true: 初始化成功
 *         false: 初始化失败
 *****************************************************************************************
 */
bool water_level_sensor_init(void);

/**
 *****************************************************************************************
 * @brief 反初始化水位传感器模块
 *****************************************************************************************
 */
void water_level_sensor_deinit(void);

/**
 *****************************************************************************************
 * @brief 读取水位传感器基础数据
 *
 * @param[out] p_data: 指向基础数据结构的指针
 *
 * @return true: 读取成功
 *         false: 读取失败
 *
 * @note 读取液位档位和温度数据
 *****************************************************************************************
 */
bool water_level_sensor_read_basic(water_level_data_t *p_data);

/**
 *****************************************************************************************
 * @brief 读取液位档位
 *
 * @return 液位档位值 (0~6), 失败返回0xFF
 *****************************************************************************************
 */
uint8_t water_level_sensor_get_level_grade(void);

/**
 *****************************************************************************************
 * @brief 读取温度
 *
 * @return 温度值 (℃), 失败返回-999.0f
 *****************************************************************************************
 */
float water_level_sensor_get_temperature(void);

/**
 *****************************************************************************************
 * @brief 读取电容数据
 *
 * @param[out] p_cap: 指向电容数据结构的指针
 *
 * @return true: 读取成功
 *         false: 读取失败
 *****************************************************************************************
 */
bool water_level_sensor_read_capacitance(water_level_cap_data_t *p_cap);

/**
 *****************************************************************************************
 * @brief 读取频率数据
 *
 * @param[out] p_freq: 指向频率数据结构的指针
 *
 * @return true: 读取成功
 *         false: 读取失败
 *****************************************************************************************
 */
bool water_level_sensor_read_frequency(water_level_freq_data_t *p_freq);

/**
 *****************************************************************************************
 * @brief 读取计数数据
 *
 * @param[out] p_count: 指向计数数据结构的指针
 *
 * @return true: 读取成功
 *         false: 读取失败
 *****************************************************************************************
 */
bool water_level_sensor_read_count(water_level_count_data_t *p_count);

/**
 *****************************************************************************************
 * @brief 读取完整传感器数据
 *
 * @param[out] p_full: 指向完整数据结构的指针
 *
 * @return true: 读取成功
 *         false: 读取失败
 *****************************************************************************************
 */
bool water_level_sensor_read_full(water_level_full_data_t *p_full);

/**
 *****************************************************************************************
 * @brief 设置采集平均次数
 *
 * @param[in] avg_count: 平均次数 (1~20)
 *
 * @return true: 设置成功
 *         false: 设置失败
 *****************************************************************************************
 */
bool water_level_sensor_set_avg_samples(uint8_t avg_count);

/**
 *****************************************************************************************
 * @brief 获取采集平均次数
 *
 * @return 平均次数 (1~20), 失败返回0
 *****************************************************************************************
 */
uint8_t water_level_sensor_get_avg_samples(void);

/**
 *****************************************************************************************
 * @brief 执行空载校准
 *
 * @details 将传感器紧贴外壳后调用此函数进行空载电容值校准
 *
 * @return true: 校准成功
 *         false: 校准失败
 *****************************************************************************************
 */
bool water_level_sensor_calibrate(void);

/**
 *****************************************************************************************
 * @brief 检查传感器是否已初始化并正常工作
 *
 * @return true: 传感器正常
 *         false: 传感器异常或未初始化
 *****************************************************************************************
 */
bool water_level_sensor_is_ready(void);

/**
 *****************************************************************************************
 * @brief 打印传感器数据到日志
 *
 * @param[in] p_data: 指向基础数据结构的指针
 *****************************************************************************************
 */
void water_level_sensor_print_data(const water_level_data_t *p_data);

/**
 *****************************************************************************************
 * @brief 计算CRC-16/MODBUS校验码
 *
 * @param[in] p_data: 数据指针
 * @param[in] length: 数据长度
 *
 * @return CRC-16校验码 (低字节在前)
 *****************************************************************************************
 */
uint16_t water_level_sensor_calc_crc16(const uint8_t *p_data, uint16_t length);

#endif /* __WATER_LEVEL_SENSOR_H__ */
