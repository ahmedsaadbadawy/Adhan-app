import '../../../core/services/audio/audio_model.dart';

class SoundsDatasourse {
  SoundsDatasourse._();
  static final List<AudioModel> testPlaylist = [
    AudioModel(
      id: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/001.mp3',
      url: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/001.mp3',
      title: 'Al-Fatiha',
      artist: 'Abdu Albasit',
    ),
    AudioModel(
      id: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/002.mp3',
      url: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/002.mp3',
      title: 'Al-Baqarah',
      artist: 'Abdu Albasit',
    ),
    AudioModel(
      id: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/007.mp3',
      url: 'https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/007.mp3',
      title: "Al-A'raf",
      artist: 'Abdu Albasit',
    ),
  ];
}
