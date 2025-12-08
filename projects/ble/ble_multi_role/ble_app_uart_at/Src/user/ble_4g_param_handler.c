#include "ble_4g_param_handler.h"
#include "shared_params.h"
#include "app_log.h"
#include <string.h>

#define TAG "4G_PARAM"

// 将数值按两位小数四舍五入，避免2.0999999这类浮点显示问题
static double round_to_2_decimal(double value)
{
    long tmp = (long)(value * 100.0 + 0.5);
    return (double)tmp / 100.0;
}

/** @brief 创建采集周期设置响应 */
static char* create_collect_time_response(int result, uint16_t collect_time)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    if (!json || !header) { if (json) cJSON_Delete(json); if (header) cJSON_Delete(header); return NULL; }

    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));

    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_COLLECT_TIME_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);

    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "collect_time_set", collect_time);
            cJSON_AddItemToObject(json, "body", body);
        }
    }

    cJSON_AddNumberToObject(json, "result", result);

    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);

    return json_string;
}

/** @brief 创建上报周期设置响应 */
static char* create_update_time_response(int result, uint16_t update_time)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    if (!json || !header) { if (json) cJSON_Delete(json); if (header) cJSON_Delete(header); return NULL; }

    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));

    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_UPDATE_TIME_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);

    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "updata_time_set", update_time);
            cJSON_AddItemToObject(json, "body", body);
        }
    }

    cJSON_AddNumberToObject(json, "result", result);

    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);

    return json_string;
}

/** @brief 创建阈值设置响应（水位检测版本）*/
static char* create_threshold_response(int result, float water_level_threshold, int16_t temp_high, int16_t temp_low)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    if (!json || !header) { if (json) cJSON_Delete(json); if (header) cJSON_Delete(header); return NULL; }

    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));

    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_THRESHOLD_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);

    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            // 水位阈值按两位小数四舍五入后再写入JSON
            cJSON_AddNumberToObject(body, "water_depth_threshold_cm_set", round_to_2_decimal(water_level_threshold));
            cJSON_AddNumberToObject(body, "TEMPH_threshold_set", temp_high);
            cJSON_AddNumberToObject(body, "TEMPL_threshold_set", temp_low);
            cJSON_AddItemToObject(json, "body", body);
        }
    }

    cJSON_AddNumberToObject(json, "result", result);

    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);

    return json_string;
}

/** @brief 创建水浸深度阈值设置响应 */
static char* create_water_threshold_response(int result, float flood_depth_threshold)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();
    if (!json || !header) { if (json) cJSON_Delete(json); if (header) cJSON_Delete(header); return NULL; }

    char device_id[DEVICE_ID_SIZE] = {0};
    ble_4g_protocol_get_device_id(device_id, sizeof(device_id));

    cJSON_AddNumberToObject(header, "code", PROTOCOL_4G_CMD_WATER_THRESHOLD_SET);
    cJSON_AddStringToObject(header, "device_ID", device_id);
    cJSON_AddItemToObject(json, "header", header);

    if (result == PROTOCOL_4G_RESULT_SET_SUCCESS)
    {
        cJSON *body = cJSON_CreateObject();
        if (body)
        {
            cJSON_AddNumberToObject(body, "water_threshold_set", round_to_2_decimal(flood_depth_threshold));
            cJSON_AddItemToObject(json, "body", body);
        }
    }

    cJSON_AddNumberToObject(json, "result", result);

    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);

    return json_string;
}

/** @brief 处理采集周期设置命令 */
static char* handle_collect_time_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;
    if (body) {
        cJSON *item = cJSON_GetObjectItem(body, "collect_time_set");
        if (item && cJSON_IsNumber(item)) {
            uint16_t val = (uint16_t)item->valueint;
            if (val >= 1 && val <= 1440 && shared_params_set_collect_time(val)) {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                ble_4g_protocol_restart_collect_timer();
            }
        }
    }
    return create_collect_time_response(result, g_shared_params.device_collect_time);
}

/** @brief 处理上报周期设置命令 */
static char* handle_update_time_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;
    if (body) {
        cJSON *item = cJSON_GetObjectItem(body, "updata_time_set");
        if (item && cJSON_IsNumber(item)) {
            uint16_t val = (uint16_t)item->valueint;
            if (val >= 1 && val <= 1440 && shared_params_set_update_time(val)) {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                ble_4g_protocol_restart_report_timer();
            }
        }
    }
    return create_update_time_response(result, g_shared_params.device_updata_time);
}

/** @brief 处理阈值设置命令（水位检测版本）*/
static char* handle_threshold_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;
    if (body) {
        cJSON *water = cJSON_GetObjectItem(body, "water_depth_threshold_cm_set");
        cJSON *th = cJSON_GetObjectItem(body, "TEMPH_threshold_set");
        cJSON *tl = cJSON_GetObjectItem(body, "TEMPL_threshold_set");
        if (water && cJSON_IsNumber(water) && th && cJSON_IsNumber(th) && tl && cJSON_IsNumber(tl)) {
            if (shared_params_set_water_depth_threshold((float)water->valuedouble) &&
                shared_params_set_temp_thresholds((int16_t)th->valueint, (int16_t)tl->valueint)) {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
            }
        }
    }
    return create_threshold_response(result, g_shared_params.water_depth_threshold_cm,
                                     g_shared_params.temp_high_threshold, g_shared_params.temp_low_threshold);
}

/** @brief 处理水浸深度阈值设置命令 */
static char* handle_water_threshold_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;
    if (body) {
        cJSON *item = cJSON_GetObjectItem(body, "water_threshold_set");
        if (item && cJSON_IsNumber(item) && shared_params_set_water_threshold((uint16_t)item->valueint)) {
            result = PROTOCOL_4G_RESULT_SET_SUCCESS;
        }
    }
    return create_water_threshold_response(result, g_shared_params.water_threshold);
}

/** @brief 处理JSON参数设置命令 */
char* ble_4g_param_process_json_command(int cmd_code, cJSON *body)
{
    switch (cmd_code) {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET:    return handle_collect_time_set_command(body);
        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:     return handle_update_time_set_command(body);
        case PROTOCOL_4G_CMD_THRESHOLD_SET:       return handle_threshold_set_command(body);
        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET: return handle_water_threshold_set_command(body);
        default: return NULL;
    }
}
