import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../../core/services/adhan_service.dart';
import '../../../../../core/services/notafications_service.dart';
import '../../../domain/entities/adhan_status.dart';

part 'adhan_state.dart';

class AdhanCubit extends Cubit<AdhanState> {
  AdhanCubit(this._adhanService, this._notificationService)
    : super(AdhanInitial());

  final AdhanService _adhanService;
  // final AudioService _audioService;
  final NotificationService _notificationService;

  StreamSubscription<AdhanStatus>? _subscription;

  // Future<bool> startFromCache() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lat = prefs.getDouble('last_lat');
  //   final lng = prefs.getDouble('last_lng');
  //   final tzName = prefs.getString('last_timezone');

  //   if (lat == null || lng == null || tzName == null) {
  //     return false;
  //   }

  //   start(coordinates: Coordinates(lat, lng), location: tz.getLocation(tzName));
  //   return true;
  // }

  void start({
    required Coordinates coordinates,
    required tz.Location location,
    CalculationParameters? calculationParameters,
  }) {
    emit(AdhanLoading());

    _notificationService.scheduleUpcomingPrayers( // TODO for the celebrities
      adhanService: _adhanService,
      coordinates: coordinates,
      location: location,
      calculationParameters: calculationParameters,
    );

    _subscription?.cancel();

    _subscription = _adhanService
        .adhanStatusStream(
          coordinates: coordinates,
          location: location,
          calculationParameters: calculationParameters,
        )
        .listen((adhanStatus) async {
          // if (adhanStatus.shouldPlayAdhan) {
          //   await _audioService.playSound('sounds/adhan.mp3').catchError((e) {
          //     debugPrint('Failed to play adhan audio: $e');
          //   });
          // }

          emit(AdhanSuccess(adhanStatus: adhanStatus));
        });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
