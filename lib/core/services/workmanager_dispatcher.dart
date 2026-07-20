import 'dart:developer' as developer;

import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../DI/service_allocator.dart';
import 'adhan_service.dart';
import 'home_widget_service.dart';
import 'notifications/notafications_service.dart';
import 'notifications/prayer_notification_scheduler.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      developer.log('Task: $task', name: 'WorkManager');
      print(
        'Task: $task'
        'WorkManager',
      );
      print('========== WORKMANAGER STARTED WITH GET IT ==========');
      tz.initializeTimeZones();

      final location = tz.getLocation(inputData!['timezoneName'] as String);

      tz.setLocalLocation(location);

      await setupBackgroundDependencies();

      final coordinates = Coordinates(
        inputData['latitude'] as double,
        inputData['longitude'] as double,
      );

      final notificationService = getIt<NotificationService>();
      final prayerNotificationScheduler = getIt<PrayerNotificationScheduler>();
      final adhanService = getIt<AdhanService>();

      await notificationService.init(requestPermissions: false);

      await prayerNotificationScheduler.scheduleUpcomingPrayers(
        adhanService: adhanService,
        coordinates: coordinates,
        location: location,
        force: true,
      );

      final testTime = tz.TZDateTime.now(
        location,
      ).add(const Duration(seconds: 1));
      await getIt<PrayerNotificationScheduler>().scheduleForPrayer(
        id: 995,
        title: 'Test Prayer',
        scheduledTime: testTime,
      );

      await HomeWidgetService.updateCurrentTime();

      print('========== WORKMANAGER FINISHED WITH GET IT ==========');
      return true;
    } catch (e, s) {
      developer.log(
        'Background task failed',
        name: 'WorkManager',
        error: e,
        stackTrace: s,
      );

      return false;
    }
  });
}
