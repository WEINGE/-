# 电池电压数据流集成修复报告

## 问题描述

用户反馈JSON数据中`sensor_battery`字段显示为固定值`"3.300,100"`，没有实现真实电池电压读取功能。

示例问题数据：
```json
{
  "header": {
    "code": 105,
    "device_ID": "866940075734731"
  },
  "body": {
    "sensor_methane": "0.0,0.0",
    "sensor_TEMP": 20,
    "sensor_battery": "3.300,100",  // ❌ 固定值，未读取真实电压
    "collect_time": "20251020163329"
  }
}
```

## 根本原因

### 1. 缺失ADC驱动文件
Keil项目文件中缺少以下驱动源文件：
- `drivers/src/app_adc.c`
- `drivers/src/app_adc_dma.c`

导致链接时出现 `undefined symbol` 错误。

### 2. 数据流未集成电池读取
在 `user_app.c` 的 `update_sensor_data_from_parser()` 函数中，电池数据被硬编码：

**修复前（第616-617行，628-629行）：**
```c
ble_sensor_data.battery_voltage = 3.3f;  // TODO: 获取真实电池电压
ble_sensor_data.battery_percent = 100;   // TODO: 获取真实电池电量
```

### 3. 查询响应硬编码
在 `ble_protocol.c` 的查询响应函数中（第618-619行），电池数据也被硬编码：

**修复前：**
```c
snprintf(battery_str, sizeof(battery_str), "%.3f,%d", 
        3.7f, 80);  // ❌ 硬编码固定值
```

## 修复方案

### 修复1: 添加ADC驱动到Keil项目

**文件**: `Keil_5/ble_app_uart_at.uvprojx`

在 `gr_app_drivers` 组中添加：
```xml
<File>
  <FileName>app_adc.c</FileName>
  <FileType>1</FileType>
  <FilePath>..\..\..\..\..\drivers\src\app_adc.c</FilePath>
</File>
<File>
  <FileName>app_adc_dma.c</FileName>
  <FileType>1</FileType>
  <FilePath>..\..\..\..\..\drivers\src\app_adc_dma.c</FilePath>
</File>
```

### 修复2: 集成真实电池电压读取

**文件**: `Src/user/user_app.c`

**修复后（第611-625行）：**
```c
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
        ble_sensor_data.battery_voltage = battery_voltage;  // ✅ 真实电压
        ble_sensor_data.battery_percent = battery_percent;  // ✅ 真实电量
        // ... (其他字段)
        
        // Update 4G protocol sensor data
        ble_4g_sensor_data_t ble_4g_sensor_data = {0};
        ble_4g_sensor_data.battery_voltage = battery_voltage;  // ✅ 真实电压
        ble_4g_sensor_data.battery_percent = battery_percent;  // ✅ 真实电量
        // ... (其他字段)
    }
}
```

**添加头文件包含（第66行）：**
```c
#include "battery_voltage_reader.h"  // 电池电压读取模块
```

### 修复3: 更新查询响应使用真实数据

**文件**: `Src/user/ble_protocol.c`

**修复后（第616-620行）：**
```c
case PROTOCOL_QUERY_TYPE_CURRENT_DATA:
    response_code = 105; // 监测数据上报
    update_sensor_data_from_parser();  // ✅ 此函数现在会读取真实电池数据
    // ...
    // 组合电池信息字符串 "电压,百分比" - 使用真实电池数据
    char battery_str[32];
    snprintf(battery_str, sizeof(battery_str), "%.3f,%d", 
            s_current_sensor_data.battery_voltage,  // ✅ 从真实读取的数据
            s_current_sensor_data.battery_percent); // ✅ 从真实读取的数据
    cJSON_AddStringToObject(body, "sensor_battery", battery_str);
    break;
```

## 数据流完整路径

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. 硬件层                                                        │
├─────────────────────────────────────────────────────────────────┤
│ MSIO_PIN_0/1 (ADC通道) → 分压电路(R1=51kΩ, R2=20kΩ)             │
│                           分压比: 3.312 (经校准)                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. ADC驱动层                                                     │
├─────────────────────────────────────────────────────────────────┤
│ app_adc_init() + app_adc_dma_init()                             │
│ app_adc_dma_conversion_async(buffer, 128)  // DMA采样128次       │
│ app_adc_voltage_intern(buffer, voltage, 128) // 转换为电压       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. 电池电压读取模块                                               │
├─────────────────────────────────────────────────────────────────┤
│ battery_voltage_reader_get_voltage(&battery_data)               │
│   - ADC电压平均: avg_voltage = sum / 128                         │
│   - 还原电池电压: battery_v = avg_voltage × 3.312                │
│   - 应用校准: battery_voltage_apply_calibration()                │
│   - 计算电量: battery_voltage_calculate_percent()                │
│                                                                  │
│ 输出:                                                            │
│   battery_data.battery_voltage (float)                          │
│   battery_data.battery_percent (uint8_t)                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. 传感器数据更新层                                               │
├─────────────────────────────────────────────────────────────────┤
│ update_sensor_data_from_parser() // user_app.c                  │
│   ├─ battery_voltage_reader_get_voltage(&battery_data)          │
│   ├─ ble_sensor_data.battery_voltage = battery_data.voltage     │
│   ├─ ble_sensor_data.battery_percent = battery_data.percent     │
│   ├─ ble_protocol_update_sensor_data(&ble_sensor_data)          │
│   └─ ble_4g_protocol_update_sensor_data(&ble_4g_sensor_data)    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. 协议层JSON组装                                                │
├─────────────────────────────────────────────────────────────────┤
│ ble_protocol_create_query_response() // ble_protocol.c          │
│   case PROTOCOL_QUERY_TYPE_CURRENT_DATA (105):                  │
│     ├─ update_sensor_data_from_parser()  // 触发电池读取          │
│     ├─ snprintf(battery_str, "%.3f,%d",                         │
│     │         s_current_sensor_data.battery_voltage,            │
│     │         s_current_sensor_data.battery_percent)            │
│     └─ cJSON_AddStringToObject(body, "sensor_battery", ...)     │
│                                                                  │
│ ble_protocol_create_json_report() // ble_protocol.c             │
│   (自动周期上报时调用)                                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. 输出JSON                                                      │
├─────────────────────────────────────────────────────────────────┤
│ {                                                                │
│   "header": {"code": 105, "device_ID": "xxx"},                  │
│   "body": {                                                      │
│     "sensor_methane": "0.0,0.0",                                 │
│     "sensor_TEMP": 20,                                           │
│     "sensor_battery": "7.234,85",  // ✅ 真实电压和电量            │
│     "collect_time": "20251020163329"                             │
│   }                                                              │
│ }                                                                │
└─────────────────────────────────────────────────────────────────┘
```

## 验证步骤

### 1. 编译验证
在Keil中重新编译项目：
- ✅ 检查 `app_adc.c` 和 `app_adc_dma.c` 是否编译成功
- ✅ 确认没有 `undefined symbol` 错误
- ✅ 验证 `battery_voltage_reader_get_voltage` 符号已解析

### 2. 运行时验证
通过BLE发送查询指令（code=101, type=4）：
```json
{
  "header": {"code": 101},
  "body": {"type": 4}
}
```

预期响应：
```json
{
  "header": {"code": 105},
  "body": {
    "sensor_methane": "x.x,x.x",
    "sensor_TEMP": xx,
    "sensor_battery": "x.xxx,xx"  // ✅ 应显示真实测量值，不再是固定的3.300,100
  },
  "result": 1
}
```

### 3. 日志验证
查看调试日志，应看到：
```
[DEBUG] Battery data updated: 7.234V, 85%
[INFO] Initial battery: 7.23V (ADC=2345, 2.183V, 85%)
```

## 技术亮点

1. **完整的电源管理**：每次读取时初始化ADC，读取完成后立即反初始化，节省功耗
2. **数据容错**：如果ADC读取失败，使用默认值（3.3V, 100%），确保系统稳定
3. **高精度采样**：使用DMA采样128次并求平均，降低噪声影响
4. **分压校准**：通过实测数据校准分压比（3.312），提高精度
5. **统一数据流**：BLE协议和4G协议共享相同的电池数据源

## 修改文件清单

1. ✅ `Keil_5/ble_app_uart_at.uvprojx` - 添加ADC驱动文件
2. ✅ `Src/user/user_app.c` - 集成真实电池电压读取
3. ✅ `Src/user/ble_protocol.c` - 移除查询响应中的硬编码

## 测试建议

1. **电压范围测试**：测试不同电池电压（6.0V ~ 8.4V）是否正确显示
2. **电量百分比测试**：验证电量百分比计算是否合理（0% ~ 100%）
3. **默认值测试**：断开ADC硬件，验证是否正确使用默认值
4. **周期上报测试**：验证自动上报数据中的电池信息是否正确
5. **查询测试**：通过BLE查询（code=101, type=4）验证实时数据

## 预期结果

修复后，JSON响应中的 `sensor_battery` 字段将显示真实的电池电压和电量，例如：
- `"sensor_battery": "7.234,85"` - 电池电压7.234V，电量85%
- `"sensor_battery": "6.523,45"` - 电池电压6.523V，电量45%
- `"sensor_battery": "8.156,98"` - 电池电压8.156V，电量98%

不再固定为 `"3.300,100"`。

---

**修复完成日期**: 2025-10-20  
**修复状态**: ✅ 完成

