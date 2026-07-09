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

  Future<void> play() async {
    await _handler.play();
  }

  Future<void> pause() async {
    await _handler.pause();
  }

  Future<void> resume() async {
    await _handler.play();
  }

  Future<void> stop() async {
    await _handler.stop();
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
