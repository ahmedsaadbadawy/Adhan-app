import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/audio/audio_model.dart';
import '../../../../../core/services/audio/audio_player_service.dart';

part 'quran_player_state.dart';

class QuranPlayerCubit extends Cubit<QuranPlayerState> {
  QuranPlayerCubit({required this._audioService}) : super(QuranPlayerState());

  final AudioPlayerService _audioService;

  StreamSubscription? _playerSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _indexSubscription;

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
        id: "https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/007.mp3",
        url: "https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/007.mp3",
        title: "Test Audio",
        artist: "Ahmed",
      ),
    );
  }

  Future<void> pause() => _audioService.pause();

  Future<void> stop() => _audioService.stop();

  Future<void> seek(double value) {
    return _audioService.seek(Duration(seconds: value.toInt()));
  }

  //====================== Playlist ======================

  Future<void> loadPlaylist(
    List<AudioModel> tracks, {
    int initialIndex = 0,
  }) async {
    await _audioService.loadPlaylist(
      tracks: tracks,
      initialIndex: initialIndex,
    );

    emit(state.copyWith(playlist: tracks, currentIndex: initialIndex));

    _listenToIndex();
  }

  Future<void> playPlaylist(
    List<AudioModel> tracks, {
    int initialIndex = 0,
  }) async {
    await _audioService.playPlaylist(
      tracks: tracks,
      initialIndex: initialIndex,
    );

    emit(state.copyWith(playlist: tracks, currentIndex: initialIndex));

    _listenToIndex();
  }

  void _listenToIndex() {
    _indexSubscription ??= _audioService.currentIndexStream.listen((index) {
      if (index == null) return;

      emit(state.copyWith(currentIndex: index));
    });
  }

  Future<void> playNext() => _audioService.skipToNext();

  Future<void> playPrevious() => _audioService.skipToPrevious();

  Future<void> playTrackAt(int index) async {
    await _audioService.skipToIndex(index);
    await _audioService.play();
  }

  @override
  Future<void> close() async {
    await _playerSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _indexSubscription?.cancel();

    return super.close();
  }
}
