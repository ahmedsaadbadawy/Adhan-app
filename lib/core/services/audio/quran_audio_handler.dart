import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  QuranAudioHandler() {
    _listenToPlayer();
  }

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<int?>? _indexSubscription;

  bool _initialized = false;

  Future<void> setSource({
    required String url,
    required MediaItem media,
  }) async {
    final current = mediaItem.value;

    if (current?.id == media.id && _initialized) {
      return;
    }

    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));

    _initialized = true;

    queue.add([media]);

    mediaItem.add(media);

    _broadcastState();
  }

  Future<void> setPlaylist({
    required List<String> urls,
    required List<MediaItem> mediaItems,
    int initialIndex = 0,
  }) async {
    await _player.setAudioSources(
      urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
      initialIndex: initialIndex,
    );

    _initialized = true;

    queue.add(mediaItems);
    mediaItem.add(mediaItems[initialIndex]);

    _broadcastState();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    final currentQueue = queue.value;

    if (index < 0 || index >= currentQueue.length) return;

    await _player.seek(Duration.zero, index: index);
  }

  void _listenToPlayer() {
    _playerStateSubscription = _player.playerStateStream.listen((_) {
      _broadcastState();
    });

    _positionSubscription = _player.positionStream.listen((_) {
      _broadcastState();
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      final current = mediaItem.value;

      if (current == null) return;

      mediaItem.add(current.copyWith(duration: duration));
    });

    _indexSubscription = _player.currentIndexStream.listen((index) {
      final currentQueue = queue.value;

      if (index != null && index >= 0 && index < currentQueue.length) {
        mediaItem.add(currentQueue[index]);
      }
      _broadcastState();
    });
  }

  void _broadcastState() {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: _processingState,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.currentIndex ?? 0,
      ),
    );
  }

  AudioProcessingState get _processingState {
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;

      case ProcessingState.loading:
        return AudioProcessingState.loading;

      case ProcessingState.buffering:
        return AudioProcessingState.buffering;

      case ProcessingState.ready:
        return AudioProcessingState.ready;

      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() async {
    await _player.play();
    _broadcastState();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _broadcastState();
  }

  // @override
  // Future<void> stop() async {
  //   await _player.pause();
  //   await _player.seek(Duration.zero);

  //   _broadcastState();
  // }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);

    _broadcastState();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  @override
  Future<void> fastForward() async {
    await seek(_player.position + const Duration(seconds: 10));
  }

  @override
  Future<void> rewind() async {
    final target = _player.position - const Duration(seconds: 10);

    await seek(target.isNegative ? Duration.zero : target);
  }

  @override
  Future<void> onTaskRemoved() async {
    // Keep playback alive when the UI task is removed.
    // The user can stop playback from the notification.
    // await _player.stop();
  }

  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _indexSubscription?.cancel();

    await _player.stop();
    await _player.dispose();
    await super.stop();
  }
}
