import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'my_adhan_channel';
  static const _channelName = 'my_Adhan Notifications';

  Future<void> init({bool requestPermissions = true}) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    if (requestPermissions) {
      await NotificationPermissionHandler().handleNotificationsPermissions();
    }

    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for prayer times',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);
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
          visibility: NotificationVisibility.public,
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> logPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    print('📋 Pending notifications with OS scheduler: ${pending.length}');
    for (final p in pending) {
      print('   id=${p.id} title=${p.title}');
    }
  }
}
