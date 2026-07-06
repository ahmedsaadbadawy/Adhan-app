import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../DI/service_allocator.dart';
import 'adhan_service.dart';
import 'notafications_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('========== WORKMANAGER STARTED WITH GET IT ==========');
    try {
      tz.initializeTimeZones();

      await setupBackgroundDependencies();

      final location = tz.getLocation(inputData!['timezoneName'] as String);
      final coordinates = Coordinates(
        inputData['latitude'] as double,
        inputData['longitude'] as double,
      );

      final notificationService = getIt<NotificationService>();
      final adhanService = getIt<AdhanService>();

      await notificationService.init(requestPermissions: false);

      await notificationService.scheduleUpcomingPrayers(
        adhanService: adhanService,
        coordinates: coordinates,
        location: location,
        force: true,
      );

      print('========== WORKMANAGER FINISHED SUCCESSFULLY ==========');
      return true;
    } catch (e) {
      print('========== WORKMANAGER CRASHED: $e ==========');
      return false;
    }
  });
}
