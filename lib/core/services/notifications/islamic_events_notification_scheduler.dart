import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/islamic_events_scheduler.dart';
import 'notafications_service.dart';

class IslamicEventsNotificationScheduler {
  IslamicEventsNotificationScheduler({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  final NotificationService _notificationService;

  Future<void> scheduleIslamicEvents() async {
    final scheduler = const IslamicEventsScheduler();

    final events = await scheduler.loadEvents();
    final now = tz.TZDateTime.now(tz.local);

    for (final event in events) {
      final scheduled = tz.TZDateTime.from(event.date, tz.local);

      if (scheduled.isBefore(now)) continue;

      await _notificationService.scheduleNotification(
        id: event.id,
        title: event.title,
        body: event.body,
        scheduledTime: scheduled,
      );
      print('🔔 تم جدولة [حدث] بنجاح: في وقت: $scheduled');
      debugPrint('Scheduling id=${event.id} for ${event.title} at $scheduled');
    }
  }
}
