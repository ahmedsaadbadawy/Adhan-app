import 'package:adhan_dart/adhan_dart.dart';
import 'package:azan_app/core/DI/service_allocator.dart';
import 'package:azan_app/core/services/notafications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/services/adhan_service.dart';
import 'cubit/adhan_cubit/adhan_cubit.dart';
import 'widgets/adhan_remaining_time_bloc_builder.dart';

class AzanScreen extends StatelessWidget {
  const AzanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();

    final location = tz.getLocation('Africa/Cairo');

    const coordinates = Coordinates(31.04, 31.38);

    final params = CalculationMethodParameters.egyptian()
      ..madhab = Madhab.shafi;

    final adhanService = AdhanService();

    final prayerTimes = adhanService.getPrayerTimes(
      coordinates: coordinates,
      location: location,
      calculationParameters: params,
    );
    final currentPrayer = adhanService.currentPrayer(prayerTimes: prayerTimes);

    final nextPrayer = adhanService.nextPrayer(prayerTimes: prayerTimes);

    final qibla = adhanService.qiblaDirection(coordinates: coordinates);

    final formatter = DateFormat('hh:mm:ss a');

    Widget prayerTile(String title, DateTime time) {
      final localTime = tz.TZDateTime.from(time, location);

      return ListTile(
        title: Text(title),
        trailing: Text(
          formatter.format(localTime),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationService>().checkAndRequestBatteryOptimization(context);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Azan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            AdhanCubit(AdhanService(), NotificationService())
              ..start(coordinates: coordinates, location: location),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Current Prayer: ${currentPrayer.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Next Prayer: ${nextPrayer.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Qibla Direction: ${qibla.toStringAsFixed(2)}°',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(height: 32),

            prayerTile('Fajr', prayerTimes.fajr),
            prayerTile('Sunrise', prayerTimes.sunrise),
            prayerTile('Dhuhr', prayerTimes.dhuhr),
            prayerTile('Asr', prayerTimes.asr),
            prayerTile('Maghrib', prayerTimes.maghrib),
            prayerTile('Isha', prayerTimes.isha),
            ElevatedButton(
              onPressed: () async {
                try {
                  final testTime = tz.TZDateTime.now(
                    location,
                  ).add(const Duration(seconds: 10));
                  await NotificationService().scheduleForPrayer(
                    id: 999,
                    title: 'Test Prayer',
                    scheduledTime: testTime,
                  );
                  debugPrint('✅ Test notification scheduled for $testTime');
                } catch (e, st) {
                  debugPrint('❌ Failed to schedule: $e\n$st');
                }
              },
              child: const Text('Test notification in 3s'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // final prefs = await SharedPreferences.getInstance();
            //     // await prefs.setDouble('last_lat', 31.04);
            //     // await prefs.setDouble('last_lng', 31.38);
            //     // await prefs.setString('last_timezone', location.name);

            //     await Workmanager().registerOneOffTask(
            //       'test-run',
            //       'refreshPrayerSchedule',
            //       inputData: {
            //         'latitude': 31.04,
            //         'longitude': 31.38,
            //         'timezoneName': 'Africa/Cairo',
            //       },
            //     );
            //   },
            //   child: const Text('Change location and its adhan'),
            // ),
            const Divider(height: 32),
            AdhanRemainingTimeBlocBuilder(),
          ],
        ),
      ),
    );
  }
}
