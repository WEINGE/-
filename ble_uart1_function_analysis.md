# BLE-4G 数据流与 UART1 函数解析

## 总体总结
- `user_periph_setup.c`：负责底层外设初始化
  - `app_periph_init()`：启动时调用，依次初始化 UART0（传感器，DMA 接收）、UART1（4G 模块，中断接收）、必要的电源控制 GPIO，并设置设备地址与断言。
  - `uart_init()`：配置 UART0 的 GPIO/波特率，启用 DMA 接收并注册 `app_uart_evt_handler()`，用于持续接收传感器帧。
  - `app_uart_evt_handler()`：DMA 回调里解析 29 字节的传感器数据帧，推送到解析器，同时将普通数据写入 BLE→UART 缓冲。
  - `uart1_init()`：按中断模式初始化 UART1，GPIO7/6 复用 3，启动 `app_uart1_evt_handler()`。
  - `app_uart1_evt_handler()`：逐字节拼装 UART1 返回的 CRLF 文本，完整一行后调用 `ble_protocol_handle_4g_data()` 交给协议层解析。
  - `uart1_tx_data_send()`：同步阻塞方式向 UART1 发送缓冲区，确保每条超级指令可靠发出。

- `user_app.c`：负责 BLE 侧逻辑
  - `gap_params_init()` 等函数设置广播、扫描、连接参数。
  - `gus_service_process_event()`：BLE 透传服务回调核心，如果收到普通文本 JSON，调用 `ble_protocol_data_process()` 做协议解析；若是 `AT:`，则走 AT 解释器；其它数据压入 UART 发射缓冲。
  - 文件还维护连接状态、传输标志，与 `transport_scheduler` 协同完成 BLE↔UART 的数据搬运。

- `ble_protocol.c`：实现蓝牙 JSON 协议与 4G 超级指令交互
  - `ble_protocol_data_process()`：BLE 侧收到 JSON 后入口，负责字符串拷贝与日志，然后调用 `ble_protocol_parse_json_command()`。
  - `ble_protocol_parse_json_command()`：解析 `header.code`、`body` 等字段；`code=101` 时读取 `type` 并调用 `ble_protocol_handle_query()`。
  - `ble_protocol_handle_query()`：校验初始化状态后交给 `analyze_and_send_super_command()`；对于设备信息/状态查询，会清空采集缓存并依次发送 `adminAT+IMEI?` 等超级指令，通过 `uart1_tx_data_send()` 下发。
  - `ble_protocol_handle_4g_data()`：UART1 回传进入这里，封装成字符串交给 `handle_4g_response()`（当前统一走 AT 响应解析），并在收集完字段后触发 `check_and_send_collected_response()`。
  - `check_and_send_collected_response()`：当采集到足够数据（或超时）时按协议组装 JSON（`code=102/103`），调用 `ble_protocol_send_json_response()` 回发 BLE。
  - 其余函数负责维护传感器数据、参数配置、生成响应 JSON，或提供调试输出（`ble_debug_printf()`）。

整体流程：手机通过 BLE 发送 JSON → `gus_service_process_event()` → `ble_protocol_parse_json_command()` → `analyze_and_send_super_command()` 通过 UART1 向 4G 发命令 → UART1 中断回收到数据 → `ble_protocol_handle_4g_data()` → 组装响应 JSON → `ble_protocol_send_json_response()` 回传 BLE。

## 模块与函数详解

### `user_periph_setup.c`
- **`uart1_init(uint32_t baud_rate)`**
  - 清空 UART1 的 TX 环形缓冲，填入 `app_uart_params_t`。
  - 绑定 GPIO7/6（`APP_IO_TYPE_NORMAL` + `APP_IO_MUX_3`），与硬件连线保持一致。
  - 调用 `app_uart_deinit()` 保障重复初始化时干净复位。
  - 使用 `app_uart_init(..., app_uart1_evt_handler, ...)` 进入**中断模式**，随后调用 `app_uart_receive_async()` 开启首帧接收。
- **`app_uart1_evt_handler(app_uart_evt_t *p_evt)`**
  - 对 RX 事件逐字节累积，检测 CRLF 结尾，完整一帧时调用 `ble_protocol_handle_4g_data()`。
  - RX 缓冲溢出/错误时复位长度并重启异步接收，保证链路持续可用。
- **`uart1_tx_data_send(uint8_t *p_data, uint16_t length)`**
  - 采用 `app_uart_transmit_sync(APP_UART_ID_1, ..., 1000)` 同步发送，避免使用 UART1 不支持的 DMA。
  - 若后续需要异步发送，可在确认 4G 模块硬件流控后再改回 `app_uart_transmit_async()` 并完善 TX 完成回调队列。
- **`app_periph_init(void)`**
  - 上电流程：初始化 UART0/1，配置 4G 模块使能脚（`GPIO25`、`AON_GPIO_2`、`AON_GPIO_6`）。
  - `SYS_SET_BD_ADDR` / `app_assert_init` 等全局初始化确保 BLE 协议栈参数正确。

### `user_app.c`
- **`gus_service_process_event(gus_evt_t *p_evt)`**
  - BLE 接收到透传数据后根据前缀分流：
    - `AT:` → `at_cmd_parse()`，用于本地 AT 指令交互。
    - `{...}` → 认定为 JSON 协议，进入 `ble_protocol_data_process()`。
    - 其它数据 → 填入 `ble_to_uart_buff_data_push()`，交给 UART0 发送。
  - 负责维持透传服务的通知开关、流控标志等状态。
- **`gap_params_init()`/`gatt` 初始化函数**
  - 设置广播、扫描、连接参数，确保 BLE 链路稳定，避免因连接间隔过长导致 JSON 指令延迟。

### `ble_protocol.c`
- **`ble_protocol_data_process(const uint8_t *p_data, uint16_t length)`**
  - 校验 JSON 长度并 null 终止，方便后续解析。
  - 打印日志便于抓取上位机发送的原始指令。
- **`ble_protocol_parse_json_command(const char *json_str)`**
  - 使用 `cJSON` 解析 `header`、`body`。
  - `code=101` 时读取 `type` 并派发到 `ble_protocol_handle_query()`。
  - 其它 `code` 对应参数设置、阈值配置等，调用 `ble_protocol_handle_param_set()`。
- **`ble_protocol_handle_query(uint8_t query_type)`**
  - 对于 `PROTOCOL_QUERY_TYPE_DEVICE_INFO` / `STATUS_INFO`：
    - 通过 `analyze_and_send_super_command()` 清空 `g_at_collector`，发送 `adminAT+IMEI?`、`adminAT+ICCID?`、`adminAT+GPS?` 等组合超级指令。
    - `SEND_AT_COMMAND_ASYNC()` 内部调用 `uart1_tx_data_send()`，确保实际走 UART1。
  - 对于本地即可完成的查询（实时数据/参数），直接生成 JSON 回复。
- **`ble_protocol_handle_4g_data(const uint8_t *p_data, uint16_t length)`**
  - 将 UART1 的响应转为字符串，调用 `handle_4g_response()` 解析字段。
  - 完成所需字段后触发 `check_and_send_collected_response()`，最终再经 BLE 返回手机。
- **`check_and_send_collected_response(void)`**
  - 根据 `pending_query_type` 生成标准 JSON（`code=102/103`），默认填入本地参数；缺失字段时使用占位值。
  - 调用 `ble_protocol_send_json_response()` 将结果写入 BLE 发送缓冲。

## 排查 UART1 发送失败的关键点
- **确认初始化**：`app_periph_init()` 在 `main.c` 启动阶段已执行，确保 `uart1_init()` 得到调用。
- **确保中断模式**：未调用 `app_uart_dma_init()` / `app_uart_dma_receive_async()` 对 UART1 做 DMA 配置，符合 UART1 不支持 DMA 的要求。
- **发送路径**：BLE `code=101` → `ble_protocol_handle_query()` → `SEND_AT_COMMAND_ASYNC()` → `uart1_tx_data_send()` → `app_uart_transmit_sync(APP_UART_ID_1, ...)`，可通过日志或示波器验证。
- **硬件连线**：`GPIO7`→4G `RX`，`GPIO6`←4G `TX`，均为 `APP_IO_TYPE_NORMAL + APP_IO_MUX_3`，并已默认上拉。
- **供电/控制脚**：`S_EN`、`4G_POWER_EN`、`P_M_EN` 输出逻辑需满足板端电路要求，确保 4G 模块上电且串口有效。
- **如仍无输出**：
  1. 使用串口助手直连 UART1，监测是否有超级指令发出。
  2. 检查 `app_uart1_evt_handler` 是否触发（可添加日志）。
  3. 将 `app_uart_transmit_sync` 返回值打印，确认是否因 BUSY/错误返回。
  4. 若需要异步发送，需实现 TX 完成事件与发送队列，避免阻塞。

