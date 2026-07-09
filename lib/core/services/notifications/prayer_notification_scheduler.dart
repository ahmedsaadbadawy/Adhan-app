import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../adhan_service.dart';
import 'notafications_service.dart';

class PrayerNotificationScheduler {
  PrayerNotificationScheduler({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  final NotificationService _notificationService;

  static const _prefsKey = 'last_scheduled_date';
  static const _daysAhead = 5;

  Future<void> scheduleUpcomingPrayers({
    required AdhanService adhanService,
    required Coordinates coordinates,
    required tz.Location location,
    CalculationParameters? calculationParameters,
    bool force = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (!force && prefs.getString(_prefsKey) == todayKey) {
      // debugPrint(
      //   '⏭️ scheduleUpcomingPrayers skipped (same-day gate, force=false)',
      // );
      return;
    }
    // print(
    //   '========== scheduleUpcomingPrayers START after force=$force ==========',
    // );

    final now = tz.TZDateTime.now(location);
    await cancelAllPrayerNotifications();

    var scheduledCount = 0;
    var skippedPastCount = 0;
    var failedCount = 0;

    for (var dayOffset = 0; dayOffset < _daysAhead; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));

      final prayerTimes = adhanService.getPrayerTimes(
        coordinates: coordinates,
        location: location,
        calculationParameters: calculationParameters,
        date: targetDate,
      );

      final prayers = _buildPrayerMap(prayerTimes);

      for (final entry in prayers.entries) {
        final id = dayOffset * 10 + entry.key;
        final name = entry.value.key;
        final time = entry.value.value;

        final tzTime = tz.TZDateTime.from(time, location);

        if (tzTime.isBefore(now)) {
          skippedPastCount++;
          debugPrint(
            '⏩ Skipping $name (id=$id) at $tzTime — already in the past (now=$now)',
          );
          continue;
        }

        try {
          await scheduleForPrayer(id: id, title: name, scheduledTime: tzTime);
          scheduledCount++;
          // print('🔔 تم جدولة صلاة بنجاح: $name (id=$id) في وقت: $tzTime');
          debugPrint('Scheduling id=$id for $name at $tzTime');
        } catch (e, st) {
          failedCount++;
          // print('❌ Failed to schedule $name (id=$id) at $tzTime: $e');
          debugPrint('Stack trace: $st');
        }
      }
    }

    print(
      '========== scheduleUpcomingPrayers FINISHED: scheduled=$scheduledCount, skippedPast=$skippedPastCount, failed=$failedCount ==========',
    );

    if (failedCount == 0) {
      await prefs.setString(_prefsKey, todayKey);
    } else {
      debugPrint(
        '⚠️ Not marking $todayKey as scheduled — $failedCount failure(s) occurred, will retry next opportunity',
      );
    }

    await _notificationService.logPendingNotifications();
  }

  Future<void> scheduleForPrayer({
    required int id,
    required String title,
    required tz.TZDateTime scheduledTime,
  }) {
    return _notificationService.scheduleNotification(
      id: id,
      title: title,
      body: "It's time for $title prayer",
      scheduledTime: scheduledTime,
    );
  }

  Future<void> cancelAllPrayerNotifications() async {
    for (var dayOffset = 0; dayOffset < _daysAhead; dayOffset++) {
      for (final baseId in [1, 2, 3, 4, 5]) {
        await _notificationService.cancelNotification(dayOffset * 10 + baseId);
      }
    }
  }

  Map<int, MapEntry<String, DateTime>> _buildPrayerMap(
    PrayerTimes prayerTimes,
  ) {
    return <int, MapEntry<String, DateTime>>{
      1: MapEntry('Fajr', prayerTimes.fajr),
      2: MapEntry('Dhuhr', prayerTimes.dhuhr),
      3: MapEntry('Asr', prayerTimes.asr),
      4: MapEntry('Maghrib', prayerTimes.maghrib),
      5: MapEntry('Isha', prayerTimes.isha),
    };
  }
}
