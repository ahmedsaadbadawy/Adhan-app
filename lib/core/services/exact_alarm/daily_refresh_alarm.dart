import 'dart:developer' as developer;

import 'package:adhan_dart/adhan_dart.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../DI/service_allocator.dart';
import '../adhan_service.dart';
import '../home_widget_service.dart';
import '../notifications/notafications_service.dart';
import '../notifications/prayer_notification_scheduler.dart';
import 'daily_alarm_scheduler.dart';

const int kDailyRefreshAlarmId = 10001;

@pragma('vm:entry-point')
Future<void> dailyRefreshCallback() async {
  developer.log("🔥 DAILY REFRESH CALLBACK STARTED", name: "AlarmManager");

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Africa/Cairo"));

  await setupBackgroundDependencies();

  final notificationService = getIt<NotificationService>();
  await notificationService.init(requestPermissions: false);

  final scheduler = getIt<PrayerNotificationScheduler>();
  final adhanService = getIt<AdhanService>();

  await scheduler.scheduleUpcomingPrayers(
    adhanService: adhanService,
    coordinates: const Coordinates(31.04, 31.38),
    location: tz.local,
    force: true,
  );

  await HomeWidgetService.updateCurrentTime();

  await DailyAlarmScheduler.reset();
  await DailyAlarmScheduler.schedule();

  developer.log("✅ DAILY REFRESH CALLBACK FINISHED", name: "AlarmManager");
}

// Future<void> scheduleTomorrowRefresh() async {
//   await AndroidAlarmManager.cancel(kDailyRefreshAlarmId);

//   final now = DateTime.now();

//   var next = DateTime(now.year, now.month, now.day, 0, 5);

//   if (!next.isAfter(now)) {
//     next = next.add(const Duration(days: 1));
//   }

//   await AndroidAlarmManager.oneShotAt(
//     next,
//     kDailyRefreshAlarmId,
//     dailyRefreshCallback,
//     exact: true,
//     wakeup: true,
//     allowWhileIdle: true,
//     rescheduleOnReboot: true,
//   );
// }

Future<void> scheduleTomorrowRefresh() async {
  await AndroidAlarmManager.oneShot(
    const Duration(hours: 1),
    kDailyRefreshAlarmId,
    dailyRefreshCallback,
    exact: true,
    wakeup: true,
    allowWhileIdle: true,
    rescheduleOnReboot: true,
  );
}
