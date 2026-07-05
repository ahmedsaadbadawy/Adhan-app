import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/adhan/domain/entities/adhan_status.dart';

class AdhanService {
  const AdhanService();

  PrayerTimes getPrayerTimes({
    required Coordinates coordinates,
    required tz.Location location,
    CalculationParameters? calculationParameters,
  }) {
    final now = tz.TZDateTime.now(location);

    return PrayerTimes(
      coordinates: coordinates,
      date: now,
      calculationParameters:
          calculationParameters ??
          (CalculationMethodParameters.muslimWorldLeague()
            ..madhab = Madhab.shafi),
      precision: true,
    );
  }

  Prayer currentPrayer({required PrayerTimes prayerTimes, DateTime? date}) {
    return prayerTimes.currentPrayer(date: date ?? DateTime.now());
  }

  Prayer nextPrayer({required PrayerTimes prayerTimes}) {
    return prayerTimes.nextPrayer();
  }

  DateTime timeForPrayer({
    required PrayerTimes prayerTimes,
    required Prayer prayer,
  }) {
    return prayerTimes.timeForPrayer(prayer);
  }

  double qiblaDirection({required Coordinates coordinates}) {
    return Qibla.qibla(coordinates);
  }

  SunnahTimes getSunnahTimes({required PrayerTimes prayerTimes}) {
    return SunnahTimes(prayerTimes);
  }

  Stream<AdhanStatus> adhanStatusStream({
    required Coordinates coordinates,
    required tz.Location location,
    CalculationParameters? calculationParameters,
  }) async* {
    final prayerTimes = getPrayerTimes(
      coordinates: coordinates,
      location: location,
      calculationParameters: calculationParameters,
    );

    var nextPrayer = prayerTimes.nextPrayer();
    var currentPrayer = prayerTimes.currentPrayer();
    var nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);

    while (true) {
      final now = tz.TZDateTime.now(location);
      final remaining = nextPrayerTime.difference(now);

      yield AdhanStatus(
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        remainingTime: remaining,
      );

      if (remaining <= Duration.zero) {
        final prayerTimes = getPrayerTimes(
          coordinates: coordinates,
          location: location,
          calculationParameters: calculationParameters,
        );

        currentPrayer = prayerTimes.currentPrayer();
        nextPrayer = prayerTimes.nextPrayer();
        nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);

        yield AdhanStatus(
          currentPrayer: currentPrayer,
          nextPrayer: nextPrayer,
          remainingTime: nextPrayerTime.difference(tz.TZDateTime.now(location)),
          shouldPlayAdhan: true,
        );
        break;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
