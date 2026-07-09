import 'dart:async';

import 'package:azan_app/core/services/audio/audio_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/services/audio/audio_player_service.dart';

part 'quran_player_state.dart';

class QuranPlayerCubit extends Cubit<QuranPlayerState> {
  QuranPlayerCubit({required this._audioService}) : super(QuranPlayerState());

  final AudioPlayerService _audioService;

  StreamSubscription? _playerSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  Future<void> initialize() async {
    _playerSubscription = _audioService.playerStateStream.listen((playerState) {
      emit(state.copyWith(isPlaying: playerState.playing));
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      emit(state.copyWith(duration: duration ?? Duration.zero));
    });
  }

  Future<void> play() async {
    await _audioService.playAudio(
      track: AudioModel(
        id: "https://server8.mp3quran.net/ayyub/002.mp3",
        url: "https://server8.mp3quran.net/ayyub/002.mp3",
        title: "Test Audio",
        artist: "Ahmed",
      ),
    );
  }

  Future<void> pause() => _audioService.pause();

  Future<void> resume() => _audioService.resume();

  Future<void> stop() => _audioService.stop();

  Future<void> seek(double value) {
    return _audioService.seek(Duration(milliseconds: value.toInt()));
  }

  @override
  Future<void> close() async {
    await _playerSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();

    return super.close();
  }
}
