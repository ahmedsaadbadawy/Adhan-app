import 'package:adhan_dart/adhan_dart.dart';

class AdhanStatus {
  final Prayer currentPrayer;
  final Prayer nextPrayer;
  final Duration remainingTime;
  final bool shouldPlayAdhan;

  const AdhanStatus({
    required this.currentPrayer,
    required this.nextPrayer,
    required this.remainingTime,
    this.shouldPlayAdhan = false,
  });
}
