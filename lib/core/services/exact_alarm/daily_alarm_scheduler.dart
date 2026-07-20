import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'daily_refresh_alarm.dart';

class DailyAlarmScheduler {
  static const _scheduledKey = 'daily_alarm_scheduled';

  static Future<void> schedule() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_scheduledKey) == true) {
      return;
    }

    await scheduleTomorrowRefresh();

    await prefs.setBool(_scheduledKey, true);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_scheduledKey);

    await AndroidAlarmManager.cancel(kDailyRefreshAlarmId);
  }
}
