/********************************************************************************
 * @file    	yundtu.c
 * @function   	YunDTU处理函数
 *
 * @company	    深圳市飞思创电子科技有限公司
 * @website		www.freestrong.com
 * @tel	        		0755-86528386
 * @Author			Taro
 * @date				2024/12/25
 ********************************************************************************/
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "gpio.h"
#include "lwrb.h"
#include "main.h"
#include "tim.h"
#include "usart.h"


#define YUNDTU_PARAMETER_VERSION "50"   // YunDTU参数版本号

#define YUNDTU_CSQ_QUERY_TIME_INTERVAL (600 * 1000)   // YunDTU信号强度查询时间间隔（单位：毫秒）设置10分钟查询一次

#define YUNDTU_RESET_GPIO_Port GPIOC
#define YUNDTU_RESET_Pin GPIO_PIN_9

#if 1
#    define yundtu_debug(fmt, ...) printf("[D]" fmt, ##__VA_ARGS__)

#else
#    define yundtu_debug(fmt, ...)
#endif

enum   // 定义各种操作的枚举类型
{
    YUNDTU_HW_RESET,                 // 硬件复位
    YUNDTU_READ_RESET_INFO,          // 读取复位信息
    YUNDTU_READ_PARAMETER_VERSION,   // 读取参数版本
    YUNDTU_WRITE_CONFIG_PARAMETER,   // 写入配置参数
    YUNDTU_TRANSMISSION,             // 数据传输
    YUNDTU_QUERY_CSQ,                // 查询信号强度
};

static uint8_t uart1_rx_ch;                  // 定义串口1接收字符变量
static uint8_t uart2_rx_ch;                  // 定义串口2接收字符变量
static lwrb_t  uart2_fifo_hdl;               // 定义串口2的先进先出队列句柄
static uint8_t uart2_recv_buff_data[4096];   // 定义串口2接收缓冲区数据数组，YunDTU一包数据最大为4096
static uint8_t public_buff[4096];            // 定义公共缓冲区

uint32_t uart2_recv_idle_cnt        = 0;   // 串口2接收空闲计数
uint8_t  yundtu_command_send_flag   = 0;   // YunDTU命令发送标志
uint32_t yundtu_command_timeout_cnt = 0;   // YunDTU命令超时计数
uint32_t yundtu_csq_interval_cnt    = 0;   // YunDTU信号强度查询间隔计数
uint8_t  yundtu_csq_err_cnt         = 0;   // YunDTU信号强度查询错误计数
uint32_t yundtu_tick_cnt            = 0;   // YunDTU复位计数
uint8_t  yundtu_link_ready_flag     = 0;   // YunDTU连接准备好标志


/**
 * @brief  STM32定时回调函数
 *
 * @param  htim  TIM定时器句柄
 *
 * @note   当TIMx定时器产生中断时，会调用此函数
 */

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    if (htim == &htim4)
    {
        uart2_recv_idle_cnt++;          // 串口2接收空闲计数增加
        yundtu_command_timeout_cnt++;   // YunDTU命令超时计数增加
        yundtu_csq_interval_cnt++;      // YunDTU信号强度查询间隔计数增加
        yundtu_tick_cnt++;              // YunDTU计数增加
    }
}

/**
 * @brief UART接收传输完成回调函数
 *
 * @param  huart  UART串口句柄
 *
 * @note   当UART处于接收模式且接收完成时，会调用此函数
 */

void HAL_UART_RxCpltCallback(UART_HandleTypeDef* huart)
{
    if (huart == &huart1)
    {
        if (yundtu_link_ready_flag)
        {
            HAL_UART_Transmit(&huart2, &uart1_rx_ch, 1, 0);   // 如果连接准备好，将串口1接收到的字符通过串口2发送出去
        }
        HAL_UART_Receive_IT(&huart1, &uart1_rx_ch, 1);   // 重新启动串口1的中断接收
    }
    else if (huart == &huart2)
    {
        lwrb_write(&uart2_fifo_hdl, &uart2_rx_ch, 1);    // 将接收到的字符写入串口2的先进先出队列
        uart2_recv_idle_cnt = 0;                         // 重置串口2接收空闲计数
        HAL_UART_Receive_IT(&huart2, &uart2_rx_ch, 1);   // 重新启动串口2的中断接收
    }
}

/**
 * @brief 从UART2接收缓冲区读取数据到指定缓冲区
 *
 * @param buff 指向存储读取数据的缓冲区的指针
 * @return 读取到缓冲区的字节数，如果没有数据可用或空闲计数不大于20，则返回0
 */
int yundtu_read_buff_data(void* buff)
{
    if (lwrb_get_full(&uart2_fifo_hdl) > 0 && uart2_recv_idle_cnt > 20)
    {
        return lwrb_read(&uart2_fifo_hdl, buff, 2048);   // 如果队列中有数据且空闲计数大于20，从队列中读取数据
    }
    return 0;
}

/**
 * @brief 向YunDTU发送命令并检查响应
 *
 * @param cmd 要发送到YunDTU的命令字符串
 * @param response 用于存储YunDTU响应的缓冲区
 * @param match_str 要在响应中匹配的字符串
 * @param timeout 等待响应的超时时间（单位：毫秒）
 *
 * @return
 *      0: 匹配成功。
 *     -1: 匹配超时。
 *     -2: 匹配失败。
 */
int yundtu_send_command(const char* cmd, char* response, const char* match_str, uint32_t timeout)
{
    int      err    = 0;
    uint32_t length = 0;
    if (!yundtu_command_send_flag)
    {
        HAL_UART_Transmit(&huart2, (uint8_t*)cmd, strlen(cmd), 1000);
        yundtu_command_timeout_cnt = 0;
        yundtu_command_send_flag   = 1;
    }
    else
    {
        if (yundtu_command_timeout_cnt >= timeout)
        {
            err = -1;
        }
        else
        {
            length = yundtu_read_buff_data(response);
            if (length > 0)
            {
                response[length] = '\0';   // 在读取到的数据末尾添加字符串结束符
                if (strstr((char*)response, match_str) == NULL)
                {
                    err = -2;
                }
                else
                {
                    err = 1;
                }
            }
        }
    }
    if (err != 0)
    {
        yundtu_command_send_flag = 0;   // 如果有错误，清除命令发送标志
    }
    return err;
}

/**
 * @brief 分析接收到的消息并更新连接状态和错误计数
 *
 * @param buff 指向包含接收到消息的缓冲区的指针
 * @param length 指向接收到消息长度的指针
 *
 * @note 当从UART2接收到消息时，由lwrb_read调用此函数
 */
void yundtu_report_message(void* buff, uint32_t* length)
{
    char* p = NULL;
    char* q = NULL;

    if ((p = strstr(buff, "FS@TCP CONNECTED")) != NULL)
    {
        yundtu_debug("FS@TCP CONNECTED\r\n");   // 如果接收到连接成功的消息
        yundtu_link_ready_flag  = 1;            // 设置连接准备好标志
        yundtu_csq_interval_cnt = 0;            // 重置信号强度查询间隔计数
        yundtu_csq_err_cnt      = 0;            // 重置信号强度查询错误计数
    }
    else if ((p = strstr(buff, "FS@TCP CONNECT FAIL")) != NULL)
    {
        yundtu_debug("FS@TCP CONNECT FAIL\r\n");   // 如果接收到连接失败的消息
        yundtu_link_ready_flag = 0;                // 清除连接准备好标志
    }
    else if ((p = strstr(buff, "FS@TCP DISCONNECT")) != NULL)
    {
        yundtu_debug("FS@TCP DISCONNECT\r\n");   // 如果接收到断开连接的消
        yundtu_link_ready_flag = 0;              // 清除连接准备好标志
    }
    if (p != NULL)
    {
        q = strstr(p, "\r\n");                               // 查找消息中的换行符
        memcpy(p, q + 2, (char*)buff + *length - (q + 2));   // 移动消息内容，去掉已处理的部分
        *length = *length - (q - p) - 2;                     // 更新消息长度
    }
}

/**
 * @brief 命令处理结构
 *
 * @note 命令字符串必须是一个以空字符结尾的字符串
 */
typedef struct
{
    const char* command;     // 命令字符串
    const char* match_str;   // 命令响应匹配字符串
    uint16_t    timeout;     // 命令响应超时时间（单位：毫秒）
} at_command_handler_t;

// 定义命令初始化表
const at_command_handler_t at_command_init_table[] = {
    {"+++", "OK", 1000},                                            // 进入AT指令模式
    {"AT+E=OFF\r\n", "OK", 1000},                                   // 关闭回显
    {"AT+WKMOD1=NET\r\n", "OK", 1000},                              // 设置通道1为网路透传模式
    {"AT+SOCK1=TCP,112.125.89.8,4336\r\n", "OK", 1000},            // 设置通道1的服务器IP地址/域名、端口号，请修改为自己的服务器地址
    {"AT+SOCKSL1=LONG\r\n", "OK", 1000},                            // 设置通道1的连接类型为长连接
    {"AT+SOCKRSTIM1=5\r\n", "OK", 1000},                            // 设置通道1的重连时间间隔为5秒
    {"AT+SOCKRSNUM1=10\r\n", "OK", 1000},                           // 设置通道1的最大重连次数为10次
    {"AT+PARMSVER=" YUNDTU_PARAMETER_VERSION "\r\n", "OK", 1000},   // 设置YunDTU参数版本
    {"AT+S\r\n", "OK", 1000},                                       // 保存并重启
    {NULL},
};

/**
 * @brief 设置TCP参数，如代理地址、端口和客户端ID
 *
 * 此函数将反复调用，直到所有参数都设置完成。
 * 如果一个参数设置成功，函数将返回0并继续设置下一个参数。
 * 如果一个参数设置失败，函数将返回-1并将指针重置为第一个参数。
 * 如果所有参数都设置成功，函数将返回1。
 *
 * @return
 *      0: TCP参数设置流程还未结束。
 *     -1: 设置失败并将指针重置为第一个参数。
 *      1: 所有参数都设置成功。
 */
int yundtu_TCP_parameter_setting(void)
{
    int                                ret;
    static const at_command_handler_t* start = at_command_init_table;   // 定义静态指针，指向命令初始化表的起始位置
    if (start->command == NULL)
    {
        return 1;   // 如果指针指向空，说明所有参数已设置完成
    }
    ret = yundtu_send_command(start->command, (char*)public_buff, start->match_str, start->timeout);   // 发送命令并检查响应
    if (ret > 0)
    {
        start++;   // 如果设置成功，移动到下一个命令
    }
    else if (ret < 0)
    {
        start = at_command_init_table;   // 如果设置失败，将指针重置为命令初始化表的起始位置
        return -1;
    }
    return 0;
}

/**
 * @brief 对YunDTU进行硬件复位
 *
 * 此函数通过将YUNDTU_RESET_Pin引脚拉低3秒来复位YunDTU。
 * 复位过程分为两个步骤：
 * 1. 将YUNDTU_RESET_Pin引脚拉低并等待3秒；
 * 2. 将YUNDTU_RESET_Pin引脚拉高并重置YunDTU复位计数。
 *
 * @return
 * 0：复位过程未完成，
 * 1：复位过程完成。
 */
int yundtu_hw_reset(void)
{
    static uint8_t reset_state = 0;
    if (reset_state == 0)
    {
        HAL_GPIO_WritePin(YUNDTU_RESET_GPIO_Port, YUNDTU_RESET_Pin, GPIO_PIN_RESET);   // 将复位引脚拉低
        yundtu_tick_cnt = 0;                                                           // 重置YunDTU复位计数
        reset_state     = 1;                                                           // 进入下一个状态
    }
    else if (reset_state == 1 && yundtu_tick_cnt >= 3000)
    {
        HAL_GPIO_WritePin(YUNDTU_RESET_GPIO_Port, YUNDTU_RESET_Pin, GPIO_PIN_SET);   // 将复位引脚拉高
        yundtu_tick_cnt = 0;                                                         // 重置YunDTU复位计数
        reset_state     = 0;                                                         // 复位状态重置为0
        return 1;                                                                    // 复位完成
    }
    return 0;
}


/**
 * @brief 初始化UART1和UART2并启动中断接收过程
 *
 * 此函数初始化UART1和UART2，并启动中断接收过程。
 */
void yundtu_init(void)
{
    lwrb_init(&uart2_fifo_hdl, uart2_recv_buff_data, sizeof(uart2_recv_buff_data));   // 初始化串口2的先进先出队列
    HAL_TIM_Base_Start_IT(&htim4);                                                    // 启动定时器4的中断
    HAL_UART_Receive_IT(&huart1, &uart1_rx_ch, 1);                                    // 启动串口1的中断接收
    HAL_UART_Receive_IT(&huart2, &uart2_rx_ch, 1);                                    // 启动串口2的中断接收
}

/**
 * @brief YunDTU的主处理函数
 *
 * 此函数是YunDTU的主处理函数，它将对YunDTU进行复位、读取复位信息、读取参数版本、写入配置参数、传输数据并定期查询信号强度。
 * 该过程分为几个步骤，每个步骤将根据YunDTU的状态依次执行。
 * @note 此函数在程序的主循环中调用。
 */
void yundtu_process(void)
{
    static uint8_t expression = YUNDTU_HW_RESET;
    int            ret        = 0;
    uint32_t       length     = 0;
    switch (expression)
    {
    case YUNDTU_HW_RESET:
        if (yundtu_hw_reset())
        {
            yundtu_debug("yundtu reset successed\r\n");   // 如果硬件复位成功
            lwrb_reset(&uart2_fifo_hdl);                  // 重置串口2的缓存
            expression = YUNDTU_READ_RESET_INFO;          // 进入读取复位信息状态
        }
        break;
    case YUNDTU_READ_RESET_INFO:
        length = yundtu_read_buff_data(public_buff);   // 从接收缓冲区读取数据
        if (length > 0)
        {
            if (strstr((char*)public_buff, "freestrong") != NULL)
            {
                yundtu_debug("read reset infomation: freestrong\r\n");   // 如果读取到包含"freestrong"的复位信息
                expression = YUNDTU_READ_PARAMETER_VERSION;              // 进入读取参数版本状态
            }
        }
        else
        {
            if (yundtu_tick_cnt >= 30000)   // 超过30秒每读到复位信息，复位设备
            {
                yundtu_debug("30 seconds without reading reset information, reset device\r\n");
                yundtu_tick_cnt = 0;
                expression      = YUNDTU_HW_RESET;
            }
        }
        break;
    case YUNDTU_READ_PARAMETER_VERSION:
        ret = yundtu_send_command("adminAT+PARMSVER?\r\n", (char*)public_buff, "+PARMSVER:" YUNDTU_PARAMETER_VERSION, 1000);
        if (ret > 0)
        {
            yundtu_debug("read parameter version success, no need to update configuration parameters\r\n");
            yundtu_debug("enter data transmission\r\n");
            lwrb_reset(&uart2_fifo_hdl);
            expression = YUNDTU_TRANSMISSION;
        }
        else if (ret < 0)
        {
            if (ret == -1)
            {
                expression = YUNDTU_HW_RESET;
            }
            else
            {
                expression = YUNDTU_WRITE_CONFIG_PARAMETER;
            }
        }
        break;
    case YUNDTU_WRITE_CONFIG_PARAMETER:
        ret = yundtu_TCP_parameter_setting();
        if (ret > 0)
        {
            printf("write config parameter success\r\n");
            lwrb_reset(&uart2_fifo_hdl);
            expression = YUNDTU_READ_RESET_INFO;
        }
        else if (ret < 0)
        {
            printf("write config parameter fail\r\n");
            expression = YUNDTU_HW_RESET;
        }
        break;
    case YUNDTU_TRANSMISSION:
        length = yundtu_read_buff_data(public_buff);   // 从接收缓冲区读取数据
        if (length > 0)
        {
            yundtu_report_message(public_buff, &length);   // 如果读取到的数据长度大于0，分析接收到的消息并更新相关状态和计数
            if (yundtu_link_ready_flag)
            {
                if (length > 0)
                {
                    HAL_UART_Transmit(&huart1, public_buff, length, HAL_MAX_DELAY);   // 将读取到的数据通过串口1发送出去
                }
            }
        }


        if (yundtu_link_ready_flag && yundtu_csq_interval_cnt >= YUNDTU_CSQ_QUERY_TIME_INTERVAL)   // 如果连接准备好，且信号强度查询间隔计数达到设定的查询时间间隔
        {
            printf("regularly query signal strength\r\n");
            expression = YUNDTU_QUERY_CSQ;   // 进入查询信号强度状态
        }
        break;
    case YUNDTU_QUERY_CSQ:
        ret = yundtu_send_command("adminAT+CSQ?\r\n", (char*)public_buff, "+CSQ:", 1000);   // 发送查询信号强度的命令
        if (ret > 0)
        {
            char* p = strstr((char*)public_buff, "+CSQ:");        // 如果命令发送成功且接收到正确响应
            char* q = strstr((char*)public_buff, "\r\n\r\nOK");   // 将响应中结束标志后的内容截断
            *q      = '\0';
            yundtu_debug("signal value = %s\r\n", p + 5);
            yundtu_csq_interval_cnt = 0;   // 重置信号强度查询间隔计数和错误计数
            yundtu_csq_err_cnt      = 0;
            expression              = YUNDTU_TRANSMISSION;   // 回到数据传输状态
        }
        else if (ret < 0)
        {
            yundtu_csq_interval_cnt = 0;   // 如果命令发送失败
            if (++yundtu_csq_err_cnt >= 3)
            {
                expression = YUNDTU_HW_RESET;   // 如果错误计数达到3次，进行硬件复位
            }
            else
            {
                expression = YUNDTU_TRANSMISSION;   // 否则回到数据传输状态
            }
        }
        break;
    default:
        break;
    }
}
