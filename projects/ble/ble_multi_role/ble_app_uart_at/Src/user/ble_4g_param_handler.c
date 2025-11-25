#include "ble_4g_param_handler.h"
#include "shared_params.h"
#include "app_log.h"
#include <string.h>

#define DEBUG_TAG "[4G_PROTOCOL]"

// 将数值按两位小数四舍五入，避免2.0999999这类浮点显示问题
static double round_to_2_decimal(double value)
{
    long tmp = (long)(value * 100.0 + 0.5);
    return (double)tmp / 100.0;
}

static char* create_collect_time_response(int result, uint16_t collect_time)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();

    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        return NULL;
    }

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

static char* create_update_time_response(int result, uint16_t update_time)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();

    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        return NULL;
    }

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

static char* create_threshold_response(int result, float methane_threshold,
                                       int16_t temp_high, int16_t temp_low)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();

    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        return NULL;
    }

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
            // 甲烷阈值按两位小数四舍五入后再写入JSON，避免2.0999999046等显示
            cJSON_AddNumberToObject(body, "methane_threshold_set", round_to_2_decimal(methane_threshold));
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

static char* create_water_threshold_response(int result, uint16_t water_threshold)
{
    cJSON *json = cJSON_CreateObject();
    cJSON *header = cJSON_CreateObject();

    if (json == NULL || header == NULL)
    {
        APP_LOG_ERROR("%s Failed to create JSON objects", DEBUG_TAG);
        if (json) cJSON_Delete(json);
        if (header) cJSON_Delete(header);
        return NULL;
    }

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
            cJSON_AddNumberToObject(body, "water_threshold_set", water_threshold);
            cJSON_AddItemToObject(json, "body", body);
        }
    }

    cJSON_AddNumberToObject(json, "result", result);

    char *json_string = cJSON_Print(json);
    cJSON_Delete(json);

    return json_string;
}

static char* handle_collect_time_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;

    if (body == NULL)
    {
        APP_LOG_ERROR("%s No body in collect time set command", DEBUG_TAG);
    }
    else
    {
        cJSON *collect_time_item = cJSON_GetObjectItem(body, "collect_time_set");
        if (collect_time_item == NULL || !cJSON_IsNumber(collect_time_item))
        {
            APP_LOG_ERROR("%s Invalid collect_time_set parameter", DEBUG_TAG);
        }
        else
        {
            uint16_t new_collect_time = (uint16_t)collect_time_item->valueint;
            APP_LOG_INFO("%s Setting collect time to: %d minutes", DEBUG_TAG, new_collect_time);

            if (new_collect_time >= 1 && new_collect_time <= 1440)
            {
                if (shared_params_set_collect_time(new_collect_time))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Collect time set successfully", DEBUG_TAG);
                    ble_4g_protocol_restart_collect_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Failed to set collect time", DEBUG_TAG);
                }
            }
            else
            {
                APP_LOG_ERROR("%s Invalid collect time: %d (range: 1-1440)", DEBUG_TAG, new_collect_time);
            }
        }
    }

    return create_collect_time_response(result, g_shared_params.device_collect_time);
}

static char* handle_update_time_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;

    if (body == NULL)
    {
        APP_LOG_ERROR("%s No body in update time set command", DEBUG_TAG);
    }
    else
    {
        cJSON *update_time_item = cJSON_GetObjectItem(body, "updata_time_set");
        if (update_time_item == NULL || !cJSON_IsNumber(update_time_item))
        {
            APP_LOG_ERROR("%s Invalid updata_time_set parameter", DEBUG_TAG);
        }
        else
        {
            uint16_t new_update_time = (uint16_t)update_time_item->valueint;
            APP_LOG_INFO("%s Setting update time to: %d minutes", DEBUG_TAG, new_update_time);

            if (new_update_time >= 1 && new_update_time <= 1440)
            {
                if (shared_params_set_update_time(new_update_time))
                {
                    result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                    APP_LOG_INFO("%s Update time set successfully", DEBUG_TAG);
                    ble_4g_protocol_restart_report_timer();
                }
                else
                {
                    APP_LOG_ERROR("%s Failed to set update time", DEBUG_TAG);
                }
            }
            else
            {
                APP_LOG_ERROR("%s Invalid update time: %d (range: 1-1440)", DEBUG_TAG, new_update_time);
            }
        }
    }

    return create_update_time_response(result, g_shared_params.device_updata_time);
}

static char* handle_threshold_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;

    if (body == NULL)
    {
        APP_LOG_ERROR("%s No body in threshold set command", DEBUG_TAG);
    }
    else
    {
        cJSON *methane_item   = cJSON_GetObjectItem(body, "methane_threshold_set");
        cJSON *temp_high_item = cJSON_GetObjectItem(body, "TEMPH_threshold_set");
        cJSON *temp_low_item  = cJSON_GetObjectItem(body, "TEMPL_threshold_set");

        if (methane_item == NULL || !cJSON_IsNumber(methane_item) ||
            temp_high_item == NULL || !cJSON_IsNumber(temp_high_item) ||
            temp_low_item == NULL || !cJSON_IsNumber(temp_low_item))
        {
            APP_LOG_ERROR("%s Invalid threshold parameters", DEBUG_TAG);
        }
        else
        {
            float  new_methane_threshold = (float)methane_item->valuedouble;
            int16_t new_temp_high        = (int16_t)temp_high_item->valueint;
            int16_t new_temp_low         = (int16_t)temp_low_item->valueint;

            APP_LOG_INFO("%s Setting thresholds: CH4=%.2f, TEMP_H=%d, TEMP_L=%d",
                         DEBUG_TAG, new_methane_threshold, new_temp_high, new_temp_low);

            if (shared_params_set_methane_threshold(new_methane_threshold) &&
                shared_params_set_temp_thresholds(new_temp_high, new_temp_low))
            {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Thresholds set successfully", DEBUG_TAG);
            }
            else
            {
                APP_LOG_ERROR("%s Failed to set thresholds", DEBUG_TAG);
            }
        }
    }

    return create_threshold_response(result,
                                     g_shared_params.methane_threshold,
                                     g_shared_params.temp_high_threshold,
                                     g_shared_params.temp_low_threshold);
}

static char* handle_water_threshold_set_command(cJSON *body)
{
    int result = PROTOCOL_4G_RESULT_SET_FAILED;

    if (body == NULL)
    {
        APP_LOG_ERROR("%s No body in water threshold set command", DEBUG_TAG);
    }
    else
    {
        cJSON *water_threshold_item = cJSON_GetObjectItem(body, "water_threshold_set");
        if (water_threshold_item == NULL || !cJSON_IsNumber(water_threshold_item))
        {
            APP_LOG_ERROR("%s Invalid water_threshold_set parameter", DEBUG_TAG);
        }
        else
        {
            uint16_t new_water_threshold = (uint16_t)water_threshold_item->valueint;
            APP_LOG_INFO("%s Setting water threshold to: %d", DEBUG_TAG, new_water_threshold);

            if (shared_params_set_water_threshold(new_water_threshold))
            {
                result = PROTOCOL_4G_RESULT_SET_SUCCESS;
                APP_LOG_INFO("%s Water threshold set successfully", DEBUG_TAG);
            }
            else
            {
                APP_LOG_ERROR("%s Failed to set water threshold", DEBUG_TAG);
            }
        }
    }

    return create_water_threshold_response(result, g_shared_params.water_threshold);
}

char* ble_4g_param_process_json_command(int cmd_code, cJSON *body)
{
    switch (cmd_code)
    {
        case PROTOCOL_4G_CMD_COLLECT_TIME_SET:
            return handle_collect_time_set_command(body);

        case PROTOCOL_4G_CMD_UPDATE_TIME_SET:
            return handle_update_time_set_command(body);

        case PROTOCOL_4G_CMD_THRESHOLD_SET:
            return handle_threshold_set_command(body);

        case PROTOCOL_4G_CMD_WATER_THRESHOLD_SET:
            return handle_water_threshold_set_command(body);

        default:
            APP_LOG_WARNING("%s Unknown command code: %d", DEBUG_TAG, cmd_code);
            break;
    }

    return NULL;
}
