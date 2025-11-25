#ifndef __BLE_4G_PARAM_HANDLER_H__
#define __BLE_4G_PARAM_HANDLER_H__

#include "ble_4g_protocol.h"
#include "cJSON.h"

char* ble_4g_param_process_json_command(int cmd_code, cJSON *body);

#endif /* __BLE_4G_PARAM_HANDLER_H__ */
