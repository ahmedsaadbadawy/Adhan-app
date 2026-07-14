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

    final Duration? loadedDuration = await _player.setAudioSource(
      AudioSource.uri(Uri.parse(url)),
    );

    _initialized = true;

    final mediaWithDuration = media.copyWith(
      duration: loadedDuration ?? media.duration,
    );

    queue.add([mediaWithDuration]);
    mediaItem.add(mediaWithDuration);

    _broadcastState();
  }

  Future<void> setPlaylist({
    required List<String> urls,
    required List<MediaItem> mediaItems,
    int initialIndex = 0,
  }) async {
    final Duration? initialDuration = await _player.setAudioSources(
      urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
      initialIndex: initialIndex,
    );

    _initialized = true;

    if (mediaItems.isNotEmpty) {
      mediaItems[initialIndex] = mediaItems[initialIndex].copyWith(
        duration: initialDuration,
      );
    }

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

  Future<void> playAsset(String assetPath) async {
    await _player.setAudioSource(AudioSource.asset(assetPath));

    _initialized = true;

    await _player.play();
  }

  Future<void> playAssetAndWait(String assetPath) async {
    await _player.setAudioSource(AudioSource.asset(assetPath));

    _initialized = true;

    await _player.play();

    await _player.playerStateStream.firstWhere(
      (state) => state.processingState == ProcessingState.completed,
    );
  }

  void _listenToPlayer() {
    _playerStateSubscription = _player.playerStateStream.listen((_) {
      _broadcastState();
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      final index = _player.currentIndex;
      final currentQueue = queue.value;

      if (index != null &&
          index >= 0 &&
          index < currentQueue.length &&
          duration != null) {
        final updatedItem = currentQueue[index].copyWith(duration: duration);
        currentQueue[index] = updatedItem;
        queue.add(List.from(currentQueue));

        mediaItem.add(updatedItem);
        _broadcastState();
      }
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
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    _broadcastState();
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
    // close();
  }

  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _indexSubscription?.cancel();

    await _player.stop();
    await _player.dispose();
    await super.stop();
  }
}
