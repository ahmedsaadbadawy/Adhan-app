import 'package:azan_app/core/DI/service_allocator.dart';
import 'package:azan_app/core/services/workmanager_dispatcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'core/app_router.dart';
import 'core/services/notafications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await setupDependencyInjection();

  final notificationService = getIt<NotificationService>();
  await notificationService.init(requestPermissions: true);
  await notificationService.scheduleIslamicEvents();
  ////TODO in the first get location place.
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    'refresh-prayer-schedule',
    'refreshPrayerSchedule',
    frequency: const Duration(hours: 24),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    inputData: {
      'latitude': 31.04, //TODO get the real location later.
      'longitude': 31.38,
      'timezoneName': 'Africa/Cairo',
    },
  );

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
