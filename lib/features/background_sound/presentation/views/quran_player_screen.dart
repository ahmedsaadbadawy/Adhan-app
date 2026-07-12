import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/audio/audio_model.dart';
import '../cubit/quran_player_cubit/quran_player_cubit.dart';

class QuranPlayerScreen extends StatelessWidget {
  const QuranPlayerScreen({super.key});

  static final _testPlaylist = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran Player Test')),
      body: BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
        builder: (context, state) {
          final cubit = context.read<QuranPlayerCubit>();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  state.isPlaying ? 'Playing' : 'Paused',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (state.playlist.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Track ${state.currentIndex + 1}/${state.playlist.length}: '
                    '${state.playlist[state.currentIndex].title}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],

                const SizedBox(height: 30),

                Slider(
                  value: state.position.inSeconds.toDouble(),
                  max: state.duration.inSeconds <= 0
                      ? 1
                      : state.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    cubit.seek(value);
                  },
                ),

                Text(
                  '${state.position.inMinutes} / ${state.duration.inMinutes} Minutes',
                ),

                const SizedBox(height: 40),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: cubit.play,
                      child: const Text('Play'),
                    ),
                    ElevatedButton(
                      onPressed: cubit.pause,
                      child: const Text('Pause'),
                    ),
                    ElevatedButton(
                      onPressed: cubit.stop,
                      child: const Text('Stop'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => cubit.playPlaylist(_testPlaylist),
                      child: const Text('Play Playlist'),
                    ),
                    ElevatedButton(
                      onPressed: cubit.playPrevious,
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: cubit.playNext,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
