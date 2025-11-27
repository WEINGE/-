#include "4g_time_utils.h"
#include "app_log.h"
#include "bm8563_rtc.h"
#include <string.h>

#define TAG "4G_TIME"

void fourg_time_rtc_debug_test(void)
{
    rtc_time_t t;
    char str[RTC_TIME_STRING_LEN];
    bool running = bm8563_is_running();
    
    APP_LOG_INFO("[%s] RTC running=%d", TAG, running);
    
    if (bm8563_read_time(&t)) {
        APP_LOG_INFO("[%s] %04d-%02d-%02d %02d:%02d:%02d", TAG,
                     t.year, t.month, t.day, t.hour, t.minute, t.second);
    }
    
    if (bm8563_get_time_string(str)) {
        APP_LOG_INFO("[%s] str=%s", TAG, str);
    }
    
    if (!running) {
        bm8563_start();
    }
}

bool fourg_time_get_collection_timestamp(char *timestamp_buffer)
{
    if (!timestamp_buffer) return false;

    // 确保RTC运行
    if (!bm8563_is_running() && !bm8563_start()) {
        strcpy(timestamp_buffer, "202411141642");
        return false;
    }

    // 获取时间字符串 "YYYYMMDDHHmmss"
    char ts[RTC_TIME_STRING_LEN];
    if (!bm8563_get_time_string(ts)) {
        strcpy(timestamp_buffer, "202411141642");
        return false;
    }

    // 补齐截断到14位
    size_t len = strlen(ts);
    while (len < 14) { ts[len++] = '0'; ts[len] = '\0'; }
    if (len > 14) ts[14] = '\0';

    // 截取前12位（去掉秒）
    strncpy(timestamp_buffer, ts, 12);
    timestamp_buffer[12] = '\0';
    return true;
}
