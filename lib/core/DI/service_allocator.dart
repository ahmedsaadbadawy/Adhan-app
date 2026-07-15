import 'package:azan_app/core/services/adhan_service.dart';
import 'package:azan_app/core/services/audio/audio_player_service.dart';
import 'package:azan_app/core/services/notifications/islamic_events_notification_scheduler.dart';
import 'package:azan_app/core/services/notifications/notafications_service.dart';
import 'package:azan_app/core/services/notifications/notification_permission_handler.dart';
import 'package:azan_app/core/services/notifications/prayer_notification_scheduler.dart';
import 'package:get_it/get_it.dart';

import '../services/app_shortcuts/app_shortcuts_service.dart';
import '../services/deep_links/deep_links_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  if (!getIt.isRegistered<AudioPlayerService>()) {
    getIt.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  }

  if (!getIt.isRegistered<AdhanService>()) {
    getIt.registerSingleton<AdhanService>(const AdhanService());
  }

  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingleton<NotificationService>(NotificationService());
  }

  if (!getIt.isRegistered<NotificationPermissionHandler>()) {
    getIt.registerSingleton<NotificationPermissionHandler>(
      NotificationPermissionHandler(),
    );
  }

  if (!getIt.isRegistered<PrayerNotificationScheduler>()) {
    getIt.registerSingleton<PrayerNotificationScheduler>(
      PrayerNotificationScheduler(),
    );
  }

  if (!getIt.isRegistered<IslamicEventsNotificationScheduler>()) {
    getIt.registerSingleton<IslamicEventsNotificationScheduler>(
      IslamicEventsNotificationScheduler(),
    );
  }

  if (!getIt.isRegistered<AppShortcutsService>()) {
    getIt.registerSingleton<AppShortcutsService>(AppShortcutsService());
  }

  if (!getIt.isRegistered<DeepLinksService>()) {
    getIt.registerSingleton<DeepLinksService>(DeepLinksService());
  }
}

Future<void> setupBackgroundDependencies() async {
  await setupDependencyInjection();
}
