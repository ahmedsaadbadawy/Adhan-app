import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_initializer.dart';
import 'audio_model.dart';
import 'quran_audio_handler.dart';

class AudioPlayerService {
  AudioPlayerService();

  QuranAudioHandler get _handler => AudioInitializer.handler;

  AudioPlayer get _player => _handler.player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  Stream<bool> get playingStream =>
      _player.playerStateStream.map((e) => e.playing).distinct();

  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  Stream<double> get speedStream => _player.speedStream;

  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  Stream<MediaItem?> get currentMediaItemStream => _handler.mediaItem;

  bool get isPlaying => _player.playing;

  Duration get position => _player.position;

  Duration? get duration => _player.duration;

  Duration get bufferedPosition => _player.bufferedPosition;

  double get speed => _player.speed;

  Future<void> load({required AudioModel track}) async {
    final media = MediaItem(
      id: track.id,
      title: track.title,
      artist: track.artist,
      artUri: track.artUri == null ? null : Uri.parse(track.artUri!),
    );

    await _handler.setSource(url: track.url, media: media);
  }

  Future<void> loadPlaylist({
    required List<AudioModel> tracks,
    int initialIndex = 0,
  }) async {
    final mediaItems = tracks
        .map(
          (track) => MediaItem(
            id: track.id,
            title: track.title,
            artist: track.artist,
            artUri: track.artUri == null ? null : Uri.parse(track.artUri!),
          ),
        )
        .toList();

    await _handler.setPlaylist(
      urls: tracks.map((track) => track.url).toList(),
      mediaItems: mediaItems,
      initialIndex: initialIndex,
    );
  }

  Future<void> playPlaylist({
    required List<AudioModel> tracks,
    int initialIndex = 0,
  }) async {
    await loadPlaylist(tracks: tracks, initialIndex: initialIndex);
    await play();
  }

  Future<void> skipToNext() async {
    await _handler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _handler.skipToPrevious();
  }

  Future<void> skipToIndex(int index) async {
    await _handler.skipToQueueItem(index);
  }

  Future<void> play() async {
    await _handler.play();
  }

  Future<void> pause() async {
    await _handler.pause();
  }

  Future<void> stop() async {
    await _handler.stop();
  }

  Future<void> close() async {
    await _handler.close();
  }

  Future<void> seek(Duration position) async {
    await _handler.seek(position);
  }

  Future<void> seekForward({
    Duration amount = const Duration(seconds: 10),
  }) async {
    await seek(position + amount);
  }

  Future<void> seekBackward({
    Duration amount = const Duration(seconds: 10),
  }) async {
    final target = position - amount;

    await seek(target.isNegative ? Duration.zero : target);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> playAudio({required AudioModel track}) async {
    await load(track: track);

    await play();
  }
}
