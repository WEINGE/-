# 4G协议处理功能测试说明

## 功能概述

本系统实现了智能的4G模块通信协议，支持：
1. **动态分析JSON请求**：根据蓝牙接收到的JSON请求内容，智能判断需要什么数据
2. **超级指令优先**：优先使用超级指令查询4G模块，避免进入AT指令模式
3. **AT指令回退**：当超级指令无法处理时，自动回退到标准AT指令模式
4. **完整响应解析**：支持解析 `+TYPE:VALUE` 格式的4G模块响应

## 测试场景

### 1. 设备信息查询测试

**输入JSON请求：**
```json
{
  "header": {
    "code": 101
  },
  "body": {
    "type": 1
  }
}
```

**期望处理流程：**
1. 系统分析JSON请求，识别为设备信息查询
2. 优先发送超级指令：`adminAT+IMEI？ 响应` +IMEI:86433******2457
3. 如果超级指令失败，回退到AT指令：
   - `AT+IMEI` → 响应：`+IMEI:86433******2457`
   - `AT+ICCID` → 响应：`+ICCID:89860***********1314`
   - `AT+SN` → 响应：`+SN:2022020287653698`
   - `AT+VER` → 响应：`+VER:V1.0.0`

**期望JSON响应：**
```json
{
  "header": {
    "code": 102
  },
  "body": {
    "IMEI": "86433******2457",
    "SIM_ID": "89860***********1314",
    "device_ID": "DEVICE_001",
    "device_ver": "V1.0.0",
    "device_location": "113.74380613775224,34.84325572266224"
  },
  "result": 1
}
```

### 2. 状态信息查询测试

**输入JSON请求：**
```json
{
  "header": {
    "code": 101
  },
  "body": {
    "type": 2
  }
}
```

**期望处理流程：**
1. 系统分析JSON请求，识别为状态信息查询
2. 优先发送超级指令：`admin<指令>？`
3. 超级指令格式；admin<指令>？；如
   - `adminAT+CSQ` → 响应：`+CSQ:27`
   - `adminAT+CREG` → 响应：`+CREG:1`
   - `adminAT+RUNST` → 响应：`+RUNST:FS@CREG READY`
   - `adminAT+LBS` → 响应：`+LBS:333e,3357906`
   - `adminAT+CCLK` → 响应：`+CCLK:2022/06/19,20:05:19`
4. 如果超级指令失败，回退到AT指令：
   - `AT+CSQ` → 响应：`+CSQ:27`
   - `AT+CREG` → 响应：`+CREG:1`
   - `AT+RUNST` → 响应：`+RUNST:FS@CREG READY`
   - `AT+LBS` → 响应：`+LBS:333e,3357906`
   - `AT+CCLK` → 响应：`+CCLK:2022/06/19,20:05:19`

**期望JSON响应：**
```json
{
  "header": {
    "code": 103
  },
  "body": {
    "device_water": 0,
    "sensor_status": 0,
    "device_move": 0,
    "device_LTE_signal": 27,
    "device_GPS_status": 0
  },
  "result": 1
}
```

### 3. SIM卡未插入测试

**4G模块响应：**
```
+ICCID:SIM not inserted
```

**期望解析结果：**
```json
{
  "iccid": "SIM not inserted"
}
```

## 测试步骤

### 1. 编译和烧录
```bash
# 编译项目
cd projects/ble/ble_multi_role/ble_app_uart_at
make

# 烧录到GR5515设备
# 使用相应的烧录工具
```

### 2. 硬件连接
- 确保UART0连接到传感器模块
- 确保UART1连接到4G模块
- 确保蓝牙模块正常工作

### 3. 测试流程
1. **初始化测试**：
   - 上电后检查UART0和UART1是否正常初始化
   - 检查4G模块是否响应基本AT指令

2. **蓝牙连接测试**：
   - 使用手机或PC连接到GR5515的蓝牙
   - 发送测试JSON请求

3. **协议处理测试**：
   - 发送设备信息查询JSON
   - 观察系统是否优先尝试超级指令
   - 观察AT指令回退是否正常工作
   - 检查JSON响应格式是否正确

4. **错误处理测试**：
   - 测试4G模块断开连接的情况
   - 测试SIM卡未插入的情况
   - 测试无效JSON请求的处理

## 调试信息

系统会输出详细的调试日志：
```
[BLE_4G] Processing JSON data: xxx bytes
[BLE_4G] Received JSON: {...}
[BLE_4G] Analyzing query type: x
[BLE_4G] Sending super command: SUPER_GET_DEVICE_INFO
[BLE_4G] Falling back to AT command mode for query type: x
[BLE_4G] AT response: +IMEI:86433******2457
[BLE_4G] Parsed IMEI: 86433******2457
```

## 注意事项

1. **GPIO配置**：UART1的GPIO引脚配置需要根据实际硬件原理图调整
2. **波特率匹配**：确保UART1的波特率与4G模块匹配
3. **超时处理**：AT指令响应超时时间可能需要根据4G模块特性调整
4. **缓冲区大小**：如果响应数据较大，可能需要调整缓冲区大小

## 预期效果

实现后的系统将能够：
- ✅ 智能分析JSON请求，按需查询数据
- ✅ 优先使用高效的超级指令
- ✅ 在超级指令失败时无缝回退到AT指令
- ✅ 正确解析 `+TYPE:VALUE` 格式的4G模块响应
- ✅ 构造标准化的JSON响应返回给蓝牙客户端

这样的设计避免了死板的数据转换，实现了真正的智能按需查询。 