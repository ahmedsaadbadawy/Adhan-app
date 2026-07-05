import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'my_adhan_channel';
  static const _channelName = 'my_Adhan Notifications';
  static const _prefsKey = 'last_scheduled_date';

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await _plugin.initialize(
      settings: InitializationSettings(android: androidSettings),
    );

    await handleAppPermissions();

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

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

  Future<void> scheduleTodaysPrayers({
    required PrayerTimes prayerTimes,
    required tz.Location location,
    bool force = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (!force && prefs.getString(_prefsKey) == todayKey) {
      return;
    }

    await cancelAllPrayerNotifications();

    final now = tz.TZDateTime.now(location);

    final prayers = <int, MapEntry<String, DateTime>>{
      1: MapEntry('Fajr', prayerTimes.fajr),
      2: MapEntry('Dhuhr', prayerTimes.dhuhr),
      3: MapEntry('Asr', prayerTimes.asr),
      4: MapEntry('Maghrib', prayerTimes.maghrib),
      5: MapEntry('Isha', prayerTimes.isha),
    };

    for (final entry in prayers.entries) {
      final id = entry.key;
      final name = entry.value.key;
      final time = entry.value.value;

      final tzTime = tz.TZDateTime.from(time, location);

      if (tzTime.isBefore(now)) {
        continue;
      }

      await scheduleForPrayer(id: id, title: name, scheduledTime: tzTime);
    }

    await prefs.setString(_prefsKey, todayKey);
  }

  Future<void> scheduleForPrayer({
    required int id,
    required String title,
    required tz.TZDateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: "It's time for $title prayer",
      scheduledDate: scheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Notifications for prayer times',
          sound: RawResourceAndroidNotificationSound('adhan'),
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future handleAppPermissions() async {
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();
    }

    PermissionStatus alarmStatus = await Permission.scheduleExactAlarm.status;
    if (!alarmStatus.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> cancelAllPrayerNotifications() async {
    for (final id in [1, 2, 3, 4, 5]) {
      await _plugin.cancel(id: id);
    }
  }
}
