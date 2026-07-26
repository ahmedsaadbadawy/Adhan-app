import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/sounds_datasourse.dart';
import '../cubit/quran_player_cubit/quran_player_cubit.dart';

class QuranPlayerScreen extends StatelessWidget {
  const QuranPlayerScreen({super.key});

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

                RepaintBoundary(
                  child: Slider(
                    value: state.position.inSeconds.toDouble(),
                    max: state.duration.inSeconds <= 0
                        ? 1
                        : state.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      cubit.seek(value);
                    },
                  ),
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
                      onPressed: () =>
                          cubit.playPlaylist(SoundsDatasourse.testPlaylist),
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
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(blurRadius: 3, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      SoundsDatasourse.testPlaylist[state.currentIndex].url,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
