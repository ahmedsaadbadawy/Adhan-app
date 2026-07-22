import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:azan_app/core/DI/service_allocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/app_router.dart';
import 'core/services/app_shortcuts/app_shortcuts_service.dart';
import 'core/services/audio/audio_initializer.dart';
import 'core/services/exact_alarm/daily_alarm_scheduler.dart';
import 'core/services/home_widget_service.dart';
import 'core/services/notifications/islamic_events_notification_scheduler.dart';
import 'core/services/notifications/notafications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    await AudioInitializer.init();

  await setupDependencyInjection();

  final notificationService = getIt<NotificationService>();
  await notificationService.init(requestPermissions: true);

  await DailyAlarmScheduler.schedule();

  final islamicEventsNotificationScheduler =
      getIt<IslamicEventsNotificationScheduler>();
  await islamicEventsNotificationScheduler.scheduleIslamicEvents();

  await getIt<AppShortcutsService>().init();

  await HomeWidgetService.updateCurrentTime();

  runApp(const AzanApp());
}

class AzanApp extends StatelessWidget {
  const AzanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.greenAccent),
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
