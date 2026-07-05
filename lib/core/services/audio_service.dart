import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() {
    _player = AudioPlayer();
  }

  late final AudioPlayer _player;

  Future<void> playSound(String sound) async {
    await _player.stop();

    await _player.play(
      AssetSource(sound),
    );
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}