import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/services/app_shortcuts/app_shortcut_type.dart';
import '../../../../../core/services/app_shortcuts/app_shortcuts_service.dart';
import '../../../../../core/services/audio/audio_player_service.dart';
import '../../../../../core/services/deep_links/deep_link_type.dart';
import '../../../../../core/services/deep_links/deep_links_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._shortcuts, this._audioPlayerService, this._deepLinks)
    : super(SplashInitial());

  final DeepLinksService _deepLinks;
  final AppShortcutsService _shortcuts;
  final AudioPlayerService _audioPlayerService;

  Future<void> initialize() async {
    emit(SplashLoading());

    await _audioPlayerService.playAssetAndWait('assets/sounds/zad.mp3');

    final deepLink = _deepLinks.consumeDeepLink();

    if (deepLink != null) {
      _handleDeepLink(deepLink);
      return;
    }

    final shortcut = _shortcuts.consumeShortcut();

    if (shortcut != null) {
      _handleShortcut(shortcut);
      return;
    }

    emit(SplashNavigatePrayerTimes());
  }

  void _handleDeepLink(DeepLinkType link) {
    switch (link) {
      case DeepLinkType.quran:
        emit(SplashNavigateQuran());

      case DeepLinkType.prayerTimes:
        emit(SplashNavigatePrayerTimes());
    }
  }

  void _handleShortcut(AppShortcutType shortcut) {
    switch (shortcut) {
      case AppShortcutType.quran:
        emit(SplashNavigateQuran());

      case AppShortcutType.prayerTimes:
        emit(SplashNavigatePrayerTimes());
    }
  }
}
