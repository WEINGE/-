# MER-MCP1081-22-150 电子水尺液位传感模组 集成文档

## 一、概述

本文档描述了 MER-MCP1081-22-150 电子水尺液位传感模组在 GR5515 BLE 项目中的集成方案。

### 1.1 传感器规格

| 参数 | 规格 |
|------|------|
| **型号** | MER-MCP1081-22-150 |
| **测量原理** | 电容感应式（非接触） |
| **测量范围** | 0~126mm (0~12.6cm) |
| **档位数** | 7档 (0~6) |
| **每档分辨率** | 18mm (1.8cm) |
| **工作电压** | 3.3V~5V DC |
| **工作电流** | <10mA |
| **通信协议** | Modbus-RTU |
| **通信接口** | UART (9600bps, 8N1) |
| **工作温度** | -40℃ ~ +85℃ |

### 1.2 档位与水位对照表

| 档位 | 水位高度 (cm) | 水位高度 (mm) | 状态描述 |
|------|---------------|---------------|----------|
| 0 | 0.0 | 0 | 空/极低 |
| 1 | 1.8 | 18 | 低 |
| 2 | 3.6 | 36 | 较低 |
| 3 | 5.4 | 54 | 中等 |
| 4 | 7.2 | 72 | 较高 |
| 5 | 9.0 | 90 | 高 |
| 6 | 10.8 | 108 | 满/最高 |

---

## 二、硬件连接

### 2.1 接口定义

```
传感器模组 (4pin)          MCU (GR5515)
├── VDD (3.3V) ─────────── 3.3V 电源
├── GND ────────────────── GND
├── TX ─────────────────── UART0_RX (GPIO)
└── RX ─────────────────── UART0_TX (GPIO)
```

### 2.2 安装要求

1. **贴附位置**: 垂直贴附在非金属容器(塑料/玻璃)外壁
2. **容器壁厚**: 应 ≤12mm，否则影响测量精度
3. **传感器方向**: 感应面朝向容器内部，标识箭头指向液面上升方向
4. **固定方式**: 使用双面胶或硅胶固定，确保紧密贴合

---

## 三、软件架构

### 3.1 文件结构

```
Src/user/
├── water_level_sensor.h        # 驱动头文件 - API声明和常量定义
├── water_level_sensor.c        # 驱动实现 - Modbus-RTU通信
├── ble_4g_protocol.h           # 4G协议头文件 - 数据结构定义
├── ble_4g_protocol.c           # 4G协议实现 - 数据采集和上报
├── ble_protocol.h              # 蓝牙协议头文件 - 数据结构定义
├── ble_protocol.c              # 蓝牙协议实现 - 数据查询和上报
├── user_app.c                  # 用户应用 - 数据更新逻辑
├── main.c                      # 主程序 - 初始化入口
└── water_level_sensor_README.md # 本文档
```

### 3.2 数据流图

```
┌─────────────────────────────────────────────────────────────────┐
│                         系统启动                                  │
│  - main.c: gpio_p_m_en_set(true)  开启外设电源域                 │
│  - UART0不在启动时初始化，由水位传感器按需使用                     │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┴───────────────────┐
          ▼                                       ▼
┌─────────────────────┐               ┌─────────────────────┐
│   蓝牙查询 (BLE)     │               │   定时采集 (4G)      │
│   code=101, type=3  │               │   定时器触发          │
└─────────────────────┘               └─────────────────────┘
          │                                       │
          ▼                                       ▼
┌─────────────────────┐               ┌─────────────────────┐
│  user_app.c:        │               │  ble_4g_protocol.c: │
│  update_sensor_     │               │  read_sensor_with_  │
│  data_from_parser_ex│               │  power_mgmt()       │
└─────────────────────┘               └─────────────────────┘
          │                                       │
          └───────────────────┬───────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  water_level_sensor.c:                                          │
│  - water_level_sensor_read_basic()     读取档位+温度            │
│  - water_level_sensor_read_capacitance() 读取C0-C6电容          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  JSON 上报 (code=105)                                           │
│  - water_level: "档位,高度cm,温度"                               │
│  - water_level_cap: "C0,C1,C2,C3,C4,C5,C6"                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 四、Modbus-RTU 协议

### 4.1 通信参数

**UART配置 (物理层)**
| 参数 | 值 | 说明 |
|------|------|------|
| 波特率 | 9600 bps | |
| 数据位 | 8 | |
| 停止位 | 1 | |
| 奇偶校验位 | 无 (None) | UART层无奇偶校验 |
| 从机地址 | 0x01 | 出厂默认 |

**Modbus-RTU帧格式 (协议层)**
| 字段 | 长度 | 说明 |
|------|------|------|
| 地址码 | 1字节 | 传感器地址，网络中唯一 |
| 功能码 | 1字节 | 0x03读/0x06写 |
| 数据区 | N字节 | 16位数据高字节在前 |
| CRC校验 | 2字节 | CRC-16，**低字节在前** |

> **注意**: "奇偶校验位=无"是指UART串口层面的Parity bit，与Modbus协议层的CRC-16校验码是两个不同概念，互不冲突。

### 4.2 功能码

| 功能码 | 说明 |
|--------|------|
| 0x03 | 读保持寄存器 |
| 0x06 | 写单个寄存器 |

### 4.3 寄存器地址

| 地址 | 名称 | 读写 | 说明 |
|------|------|------|------|
| 0x0004 | LEVEL_GRADE | R | 液位档位 (0~6) |
| 0x0007 | TEMPERATURE | R | 温度 (×10, ℃) |
| 0x0008 | CAP_C0 | R | 电容C0 (×1000, pF) |
| 0x0009 | CAP_C1 | R | 电容C1 (×1000, pF) |
| 0x000A | CAP_C2 | R | 电容C2 (×1000, pF) |
| 0x000B | CAP_C3 | R | 电容C3 (×1000, pF) |
| 0x000C | CAP_C4 | R | 电容C4 (×1000, pF) |
| 0x000D | CAP_C5 | R | 电容C5 (×1000, pF) |
| 0x000E | CAP_C6 | R | 电容C6 (×1000, pF) |
| 0x0001 | CALIBRATE | W | 空载校准 (写1触发) |

### 4.4 通信示例

**读取液位档位 (地址0x0004)**
```
发送: 01 03 00 04 00 01 C5 CB
      │  │  ├────┤ ├────┤ ├────┤
      │  │  地址    数量    CRC16
      │  功能码
      从机地址

响应: 01 03 02 00 03 F8 45
      │  │  │  ├────┤ ├────┤
      │  │  │  数据    CRC16
      │  │  字节数(2)
      │  功能码
      从机地址
      
数据解析: 0x0003 = 3 (档位3)
```

---

## 五、API 参考

### 5.1 初始化与反初始化

```c
/**
 * @brief 初始化水位传感器
 * @return true: 成功, false: 失败
 */
bool water_level_sensor_init(void);

/**
 * @brief 反初始化水位传感器
 * @return true: 成功, false: 失败
 */
bool water_level_sensor_deinit(void);
```

### 5.2 数据读取

```c
/**
 * @brief 读取基础数据（档位+温度）
 * @param[out] p_data 数据输出指针
 * @return true: 成功, false: 失败
 */
bool water_level_sensor_read_basic(water_level_data_t *p_data);

/**
 * @brief 快速获取档位
 * @return 档位值(0~6), 失败返回0xFF
 */
uint8_t water_level_sensor_get_level_grade(void);

/**
 * @brief 读取7通道电容值
 * @param[out] p_cap 电容数据输出指针
 * @return true: 成功, false: 失败
 */
bool water_level_sensor_read_capacitance(water_level_cap_data_t *p_cap);
```

### 5.3 校准

```c
/**
 * @brief 执行空载校准
 * @note 需在容器内无液体时执行
 * @return true: 成功, false: 失败
 */
bool water_level_sensor_calibrate(void);
```

### 5.4 辅助宏

```c
// 每档对应的水位高度
#define WLS_CM_PER_GRADE    1.8f    // 1.8cm/档
#define WLS_MM_PER_GRADE    18.0f   // 18mm/档

// 档位转水位高度
#define WLS_GRADE_TO_CM(grade)  ((float)(grade) * WLS_CM_PER_GRADE)
#define WLS_GRADE_TO_MM(grade)  ((float)(grade) * WLS_MM_PER_GRADE)

// 最大水位
#define WLS_MAX_HEIGHT_CM   12.6f   // 12.6cm
#define WLS_MAX_HEIGHT_MM   126.0f  // 126mm
```

---

## 六、数据结构

### 6.1 基础数据结构

```c
typedef struct {
    uint8_t  level_grade;      // 液位档位 (0~6)
    float    temperature_c;    // 温度 (℃)
    bool     is_valid;         // 数据有效性
} water_level_data_t;
```

### 6.2 电容数据结构

```c
typedef struct {
    uint16_t c[7];             // 原始电容值 (×1000 pF)
    float    c_pf[7];          // 电容值 (pF)
    bool     is_valid;         // 数据有效性
} water_level_cap_data_t;
```

### 6.3 协议数据结构

```c
// 4G协议传感器数据
typedef struct {
    float pressure_hpa;
    float water_depth_cm;
    float temperature_c;
    float altitude_m;
    float battery_voltage;
    uint8_t battery_percent;
    uint8_t water_level_grade;      // 水位档位 (0~6)
    float water_level_temp_c;       // 水位传感器温度
    float water_level_height_cm;    // 水位高度 (cm)
    float water_level_cap[7];       // C0-C6电容值 (pF)
    char collect_time[16];
    bool is_valid;
} ble_4g_sensor_data_t;
```

---

## 七、JSON 上报格式

### 7.1 监测数据上报 (code=105)

```json
{
    "header": {
        "code": 105,
        "device_ID": "860123456789012"
    },
    "body": {
        "sensor_pressure": "1013.25,50.0",
        "sensor_TEMP": 25,
        "sensor_battery": "3.85,85",
        "collect_time": "20241204105400",
        "water_level": "3,5.4,21.5",
        "water_level_cap": "12.35,15.28,18.92,22.15,25.67,28.34,30.12"
    }
}
```

### 7.2 字段说明

| 字段 | 格式 | 说明 |
|------|------|------|
| `water_level` | `"档位,高度cm,温度"` | 水位基础数据 |
| `water_level_cap` | `"C0,C1,C2,C3,C4,C5,C6"` | 7通道电容值(pF) |

**water_level 详解:**
| 位置 | 含义 | 类型 | 范围 | 示例 |
|------|------|------|------|------|
| 第1位 | 液位档位 | 整数 | 0~6 | 3 |
| 第2位 | 水位高度 | 浮点 | 0~10.8 cm | 5.4 |
| 第3位 | 传感器温度 | 浮点 | -40~85 ℃ | 21.5 |

---

## 八、蓝牙查询

### 8.1 查询命令

```json
{"header":{"code":101},"body":{"type":3}}
```

### 8.2 查询类型

| type | 说明 | 响应code |
|------|------|----------|
| 1 | 设备信息 | 102 |
| 2 | 状态信息 | 103 |
| **3** | **当前监测数据** | **105** |
| 4 | 当前设置参数 | 104 |

### 8.3 响应示例

```json
{
    "header": {"code": 105},
    "body": {
        "sensor_pressure": "1013.25,50.0",
        "sensor_TEMP": 25,
        "sensor_battery": "3.85,85",
        "water_level": "3,5.4,21.5",
        "water_level_cap": "12.35,15.28,18.92,22.15,25.67,28.34,30.12"
    },
    "result": 1
}
```

---

## 九、使用示例

### 9.1 简单读取

```c
#include "water_level_sensor.h"

// 快速获取当前水位
uint8_t grade = water_level_sensor_get_level_grade();
if (grade != 0xFF) {
    float height_cm = WLS_GRADE_TO_CM(grade);
    printf("当前水位: 第%d档, 约%.1fcm\n", grade, height_cm);
}
```

### 9.2 完整数据读取

```c
water_level_data_t data;
if (water_level_sensor_read_basic(&data) && data.is_valid) {
    printf("档位: %d\n", data.level_grade);
    printf("水位: %.1f cm\n", WLS_GRADE_TO_CM(data.level_grade));
    printf("温度: %.1f ℃\n", data.temperature_c);
}
```

### 9.3 读取电容值

```c
water_level_cap_data_t cap;
if (water_level_sensor_read_capacitance(&cap) && cap.is_valid) {
    for (int i = 0; i < 7; i++) {
        printf("C%d = %.2f pF\n", i, cap.c_pf[i]);
    }
}
```

### 9.4 水位报警判断

```c
water_level_data_t data;
if (water_level_sensor_read_basic(&data) && data.is_valid) {
    if (data.level_grade >= 5) {
        APP_LOG_WARNING("水位过高! 档位=%d", data.level_grade);
        // 触发高水位报警
    } else if (data.level_grade <= 1) {
        APP_LOG_WARNING("水位过低! 档位=%d", data.level_grade);
        // 触发低水位报警
    }
}
```

---

## 十、系统集成

### 10.1 启动流程

系统启动时执行以下步骤：

1. **开启外设电源域**: `gpio_p_m_en_set(true)` - P_M_EN保持常开
2. **UART0按需初始化**: 启动时不初始化UART0，由水位传感器按需使用
3. **传感器电源控制**: S_EN(GPIO25)按需开关，控制具体传感器供电

> **注意**: 参考备份1.01版本，UART0不在系统启动时初始化，避免与水位传感器UART冲突。

### 10.2 数据采集流程

| 触发方式 | 函数入口 | 说明 |
|----------|----------|------|
| 蓝牙查询 | `update_sensor_data_from_parser_ex(true)` | 实时读取 |
| 定时采集 | `ble_4g_protocol_read_sensor_with_power_mgmt()` | 带电源管理 |

### 10.3 电源管理

**电源引脚说明:**
| 引脚 | 名称 | 功能 | 控制方式 |
|------|------|------|----------|
| GPIO25 | S_EN | 传感器使能 | 按需开关 |
| AON_GPIO_6 | P_M_EN | 外设电源域总开关 | main.c启动时开启，保持常开 |

**定时采集流程 (4G上传):**
```
1. 上电传感器 → ble_4g_protocol_sensor_power_control(true)  // 只控制S_EN
2. 等待稳定 → delay_with_watchdog_feed(5000)  // 5秒
3. 初始化UART0 → water_level_sensor_init()  // 按需初始化
4. 读取数据 → water_level_sensor_read_basic() + read_capacitance()
5. 反初始化UART0 → water_level_sensor_deinit()  // 释放UART0
6. 断电传感器 → ble_4g_protocol_sensor_power_control(false)  // 只控制S_EN
```

**蓝牙查询流程:**
```
1. 上电传感器 → ble_4g_protocol_sensor_power_control(true)
2. 等待稳定 → sys_delay_ms(500)
3. 初始化UART0 → water_level_sensor_init()
4. 等待通信稳定 → sys_delay_ms(200)
5. 读取数据 → water_level_sensor_read_basic() + read_capacitance()
6. 反初始化UART0 → water_level_sensor_deinit()
7. 断电传感器 → ble_4g_protocol_sensor_power_control(false)
```

> **重要**: P_M_EN是外设电源域总开关，不应在传感器读取后关闭，否则会影响4G模块。

---

## 十一、注意事项

### 11.1 硬件注意事项

1. **电源稳定**: 确保3.3V电源稳定，纹波<50mV
2. **接线长度**: UART线长建议<1m，过长需考虑信号衰减
3. **电磁干扰**: 远离强电磁干扰源，必要时加屏蔽

### 11.2 软件注意事项

1. **通信超时**: 默认100ms，可在头文件中调整 `WLS_RX_TIMEOUT_MS`
2. **校准时机**: 首次安装或更换容器后需重新校准
3. **数据有效性**: 使用数据前务必检查 `is_valid` 字段
4. **档位无效值**: `0xFF` 表示读取失败或传感器未连接

### 11.3 校准注意事项

1. 校准时容器内**必须无液体**
2. 校准后立即生效，无需重启
3. 校准数据掉电不丢失（存储在传感器内部）

---

## 十二、故障排除

| 现象 | 可能原因 | 解决方法 |
|------|----------|----------|
| 初始化失败 | UART未正确配置 | 检查GPIO和波特率配置 |
| 读取超时 | 接线问题 | 检查TX/RX是否交叉连接 |
| 档位始终为0 | 未校准 | 执行空载校准 |
| 档位不变化 | 贴附不紧密 | 重新贴附传感器 |
| 电容值异常 | 容器壁过厚 | 更换薄壁容器 |

---

## 十三、版本历史

| 版本 | 日期 | 修改内容 |
|------|------|----------|
| 1.0 | 2024-12-04 | 初始版本，完成基础驱动和协议集成 |
| 1.1 | 2024-12-05 | 修复UART0初始化：参考备份1.01，启动时不初始化UART0，由水位传感器按需使用；明确P_M_EN和S_EN电源控制职责 |

---

## 十四、联系方式

如有技术问题，请联系项目负责人。

---

*文档生成日期: 2024年12月4日*
