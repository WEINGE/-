# BLE协议v1.2实现使用说明 (cJSON版本)

## 概述
本实现基于您提供的蓝牙通信协议v1.2规范，使用**cJSON库**实现了以下核心功能：

### ✅ 已实现功能
- **查询指令 (命令代码101)** - 支持4种查询类型
- **蓝牙数据上报 (命令代码105)** - 自动传感器数据上报
- **cJSON格式支持** - 使用标准cJSON库进行JSON处理
- **甲烷浓度转换** - 5%vol ↔ 100%LEL 自动转换
- **AT命令集成** - 通过AT命令测试协议功能
- **内存管理** - 自动处理JSON内存分配和释放

### 🔄 预留功能
- 电池电压检测 (预留接口)
- 电池电量百分比 (预留接口)

## 🚀 使用方法

### 1. AT命令测试

#### 查询指令测试
```bash
# 查询设备信息 (type=1)
AT:BLE_QUERY=1

# 查询状态信息 (type=2) 
AT:BLE_QUERY=2

# 查询当前监测数据 (type=3)
AT:BLE_QUERY=3

# 查询当前设置参数 (type=4)
AT:BLE_QUERY=4
```

#### 数据上报测试
```bash
# 发送当前传感器数据
AT:BLE_REPORT
```

### 2. JSON协议通信

#### 查询指令 (命令代码101)
**请求格式：**
```json
{
  "header":{
    "code":101
  },
  "body":{
    "type":4
  }
}
```

**响应格式：**
```json
{
  "header":{
    "code":101
  },
  "body":{
    "sampling_interval":1000,
    "alarm_threshold":20,
    "auto_report":true
  },
  "result":1
}
```

#### 数据上报 (命令代码105)
**响应格式：**
```json
{
  "header":{
    "code":105
  },
  "body":{
    "sensor_methane":"1.25%vol,25.0%LEL",
    "sensor_TEMP":24,
    "sensor_battery":"3.6V,75%"
  },
  "result":0
}
```

### 3. 查询类型说明

| Type | 功能 | 返回内容 |
|------|------|----------|
| 1 | 设备信息 | 设备名称、固件版本、硬件版本 |
| 2 | 状态信息 | 设备状态、连接状态、传感器状态 |
| 3 | 当前监测数据 | 甲烷浓度、温度、电池信息 |
| 4 | 当前设置参数 | 采样间隔、报警阈值、自动上报设置 |

## 📁 文件结构

```
Src/user/
├── ble_protocol.h          # 协议处理头文件
├── ble_protocol.c          # 协议处理实现
├── ble_protocol_test.h     # 测试模块头文件
├── ble_protocol_test.c     # 测试模块实现
├── user_app.c             # 用户应用 (已修改)
├── at_cmd_handler.h       # AT命令处理 (已修改)
└── at_cmd_handler.c       # AT命令处理 (已修改)
```

## 🔧 集成说明

### 1. 初始化
协议模块在 `ble_app_init()` 中自动初始化：
```c
ble_protocol_init();
```

### 2. 数据处理
BLE接收到的JSON数据会自动路由到协议处理模块：
```c
// 在 gus_service_process_event() 中
else if (p_evt->p_data[0] == '{')
{
    ble_protocol_data_process(p_evt->p_data, p_evt->length);
}
```

### 3. 甲烷浓度转换
```c
float lel_value = ble_protocol_vol_to_lel(vol_value);
// 5.0%vol → 100.0%LEL
// 2.5%vol → 50.0%LEL
```

## 🧪 测试验证

### 编译测试
确保以下文件包含在编译中：
- `ble_protocol.c`
- `ble_protocol_test.c` (可选)

### 运行时测试
1. 连接BLE设备
2. 发送AT命令测试基本功能
3. 通过BLE发送JSON命令测试协议
4. 观察日志输出验证响应

### 示例日志输出
```
[INFO] BLE Protocol initialized
[INFO] Handling query type: 4
[INFO] JSON response sent, length: 156
[INFO] Data report sent
```

## 📊 数据格式

### 传感器数据结构
```c
typedef struct {
    float methane_vol;      // 甲烷浓度 %vol
    float methane_lel;      // 甲烷浓度 %LEL  
    float temperature;      // 温度 ℃
    float battery_voltage;  // 电池电压 V (预留)
    uint8_t battery_percent; // 电池电量 % (预留)
    bool is_valid;          // 数据有效性
} sensor_data_t;
```

### JSON字段说明
- `sensor_methane`: "X.XX%vol,XX.X%LEL" 格式
- `sensor_TEMP`: 整数温度值 (℃)
- `sensor_battery`: "X.XV,XX%" 格式 (预留)

## 🔮 后续扩展

### 1. 实际传感器集成
修改 `ble_protocol_get_sensor_data()` 函数，从真实传感器读取数据。

### 2. 电池监测
实现电池电压和电量检测功能。

### 3. 更多命令
根据协议规范添加其他命令代码支持。

### 4. 数据存储
添加历史数据存储和查询功能。

## ⚠️ 注意事项

1. **内存管理**: JSON字符串使用静态缓冲区，注意长度限制
2. **线程安全**: 在多线程环境中注意数据同步
3. **错误处理**: 协议解析失败时会记录警告日志
4. **性能优化**: 大量数据传输时考虑分包处理

## 📞 技术支持

如需添加更多协议功能或遇到问题，请参考：
- `ble_protocol.h` 中的接口定义
- `ble_protocol_test.c` 中的测试用例
- 系统日志输出的调试信息
