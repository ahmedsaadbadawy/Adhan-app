import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

import 'quran_audio_handler.dart';

class AudioInitializer {
  AudioInitializer._();

  static late final QuranAudioHandler handler;

  static Future<void> init() async {
    final session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration.music());

    handler = await AudioService.init<QuranAudioHandler>(
      builder: () => QuranAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.azan_app.audio',
        androidNotificationChannelName: 'Quran Playback',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ),
    );
  }
}
