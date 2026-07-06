import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../helpers/islamic_events_scheduler.dart';
import 'adhan_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'my_adhan_channel';
  static const _channelName = 'my_Adhan Notifications';
  static const _prefsKey = 'last_scheduled_date';
  static const _daysAhead = 5;

  Future<void> init({bool requestPermissions = true}) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    await _plugin.initialize(
      settings: InitializationSettings(android: androidSettings),
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (requestPermissions) {
      await handleNotificationsPermissions();

      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    }

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for prayer times',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
    );

    await androidPlugin?.createNotificationChannel(channel);
  }

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
      return;
    }
    print('========== scheduleUpcomingPrayers START after force ==========');

    final now = tz.TZDateTime.now(location);
    await cancelAllPrayerNotifications();
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
          continue;
        }

        await scheduleForPrayer(id: id, title: name, scheduledTime: tzTime);
        print('🔔 تم جدولة صلاة بنجاح: في وقت: $tzTime');

        debugPrint('Scheduling id=$id for $name at $tzTime');
      }
    }

    await prefs.setString(_prefsKey, todayKey);
  }

  Future<void> scheduleForPrayer({
    required int id,
    required String title,
    required tz.TZDateTime scheduledTime,
  }) {
    return scheduleNotification(
      id: id,
      title: title,
      body: "It's time for $title prayer",
      scheduledTime: scheduledTime,
    );
  }

  Future<void> scheduleIslamicEvents() async {
    final scheduler = const IslamicEventsScheduler();

    final events = await scheduler.loadEvents();
    final now = tz.TZDateTime.now(tz.local);

    for (final event in events) {
      final scheduled = tz.TZDateTime.from(event.date, tz.local);

      if (scheduled.isBefore(now)) continue;

      await scheduleNotification(
        id: event.id,
        title: event.title,
        body: event.body,
        scheduledTime: scheduled,
      );
      print('🔔 تم جدولة [حدث] بنجاح: في وقت: $scheduled');
      debugPrint('Scheduling id=${event.id} for ${event.title} at $scheduled');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllPrayerNotifications() async {
    for (var dayOffset = 0; dayOffset < _daysAhead; dayOffset++) {
      for (final baseId in [1, 2, 3, 4, 5]) {
        await _plugin.cancel(id: dayOffset * 10 + baseId);
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

  Future<void> handleNotificationsPermissions() async {
    print("NotificationService.init() called");
    var notificationStatus = await Permission.notification.status;
    print('Notification status = $notificationStatus');

    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();
      print('Notification after request = $notificationStatus');
    }

    var alarmStatus = await Permission.scheduleExactAlarm.status;
    print('Alarm status = $alarmStatus');

    if (!alarmStatus.isGranted) {
      alarmStatus = await Permission.scheduleExactAlarm.request();
      print('Alarm after request = $alarmStatus');
    }
  }
}
