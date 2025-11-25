#include "4g_time_utils.h"
#include "app_log.h"
#include "bm8563_rtc.h"
#include <string.h>

#define DEBUG_TAG "[4G_PROTOCOL]"

void fourg_time_rtc_debug_test(void)
{
    APP_LOG_INFO("%s === RTC Debug Test Start ===", DEBUG_TAG);

    // 1. 检查RTC是否运行
    bool is_running = bm8563_is_running();
    APP_LOG_INFO("%s RTC is running: %s", DEBUG_TAG, is_running ? "YES" : "NO");

    // 2. 尝试读取原始时间数据
    rtc_time_t rtc_time;
    bool read_success = bm8563_read_time(&rtc_time);
    APP_LOG_INFO("%s Raw time read success: %s", DEBUG_TAG, read_success ? "YES" : "NO");

    if (read_success) {
        APP_LOG_INFO("%s Raw time: %04d-%02d-%02d %02d:%02d:%02d (weekday: %d)",
                     DEBUG_TAG, rtc_time.year, rtc_time.month, rtc_time.day,
                     rtc_time.hour, rtc_time.minute, rtc_time.second, rtc_time.weekday);
    }

    // 3. 测试格式化时间字符串
    char time_str[RTC_TIME_STRING_LEN];
    bool format_success = bm8563_get_time_string(time_str);
    APP_LOG_INFO("%s Formatted time success: %s", DEBUG_TAG, format_success ? "YES" : "NO");

    if (format_success) {
        APP_LOG_INFO("%s Formatted time: %s (length: %d)", DEBUG_TAG, time_str, strlen(time_str));
    }

    // 4. 如果RTC没有运行，尝试启动
    if (!is_running) {
        APP_LOG_INFO("%s Attempting to start RTC...", DEBUG_TAG);
        bool start_success = bm8563_start();
        APP_LOG_INFO("%s RTC start result: %s", DEBUG_TAG, start_success ? "SUCCESS" : "FAILED");

        // 重新检查状态
        is_running = bm8563_is_running();
        APP_LOG_INFO("%s RTC is now running: %s", DEBUG_TAG, is_running ? "YES" : "NO");
    }

    APP_LOG_INFO("%s === RTC Debug Test End ===", DEBUG_TAG);
}

bool fourg_time_get_collection_timestamp(char *timestamp_buffer)
{
    if (timestamp_buffer == NULL) {
        APP_LOG_ERROR("%s Invalid timestamp buffer pointer", DEBUG_TAG);
        return false;
    }

    // 首先检查RTC是否正常工作
    if (!bm8563_is_running()) {
        APP_LOG_WARNING("%s RTC is not running, attempting to start", DEBUG_TAG);
        if (!bm8563_start()) {
            APP_LOG_ERROR("%s Failed to start RTC, using default timestamp", DEBUG_TAG);
            strcpy(timestamp_buffer, "20241114164200");
            return false;
        }
    }

    // 直接获取格式化的时间字符串 "YYYYMMDDHHmmss"
    char full_timestamp[RTC_TIME_STRING_LEN];
    if (!bm8563_get_time_string(full_timestamp)) {
        APP_LOG_ERROR("%s Failed to get RTC time for 4G upload", DEBUG_TAG);
        strcpy(timestamp_buffer, "202411141642");
        return false;
    }

    // 如果时间为默认值，记录警告但继续使用
    if (strncmp(full_timestamp, "2000", 4) == 0) {
        APP_LOG_WARNING("%s RTC time is default (%s), using default timestamp", DEBUG_TAG, full_timestamp);
    }

    // 验证时间戳格式和长度
    size_t len = strlen(full_timestamp);
    if (len != 14) {
        APP_LOG_WARNING("%s Invalid timestamp length: %d, expected 14. Timestamp: %s",
                        DEBUG_TAG, (int)len, full_timestamp);

        // 如果长度不对，尝试补零或截断
        if (len < 14) {
            // 长度不足，补零
            while (strlen(full_timestamp) < 14) {
                strcat(full_timestamp, "0");
            }
        } else if (len > 14) {
            // 长度过长，截断
            full_timestamp[14] = '\0';
        }
        APP_LOG_INFO("%s Corrected timestamp: %s", DEBUG_TAG, full_timestamp);
    }

    // 截取前12位（YYYYMMDDHHmm），去掉秒
    strncpy(timestamp_buffer, full_timestamp, 12);
    timestamp_buffer[12] = '\0';

    APP_LOG_INFO("%s Collection timestamp for 4G (12-digit): %s", DEBUG_TAG, timestamp_buffer);
    return true;
}
