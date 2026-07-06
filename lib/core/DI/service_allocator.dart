import 'package:azan_app/core/services/adhan_service.dart';
import 'package:azan_app/core/services/notafications_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  if (!getIt.isRegistered<AdhanService>()) {
    getIt.registerSingleton<AdhanService>(const AdhanService());
  }

  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingleton<NotificationService>(NotificationService());
  }
}

Future<void> setupBackgroundDependencies() async {
  await setupDependencyInjection();
}
