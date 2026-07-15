import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/services/app_shortcuts/app_shortcut_type.dart';
import '../../../../../core/services/app_shortcuts/app_shortcuts_service.dart';
import '../../../../../core/services/audio/audio_player_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._shortcuts, this._audioPlayerService)
    : super(SplashInitial());

  final AppShortcutsService _shortcuts;
  final AudioPlayerService _audioPlayerService;

  Future<void> initialize() async {
    emit(SplashLoading());

    await _audioPlayerService.playAssetAndWait('assets/sounds/zad.mp3');

    final shortcut = _shortcuts.consumeShortcut();

    switch (shortcut) {
      case AppShortcutType.prayerTimes:
        emit(SplashNavigatePrayerTimes());
        break;

      case AppShortcutType.quran:
        emit(SplashNavigateQuran());
        break;

      default:
        emit(SplashNavigateHome());
    }
  }
}
