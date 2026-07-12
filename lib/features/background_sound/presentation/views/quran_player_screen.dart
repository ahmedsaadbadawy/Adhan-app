import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              ],
            ),
          );
        },
      ),
    );
  }
}
