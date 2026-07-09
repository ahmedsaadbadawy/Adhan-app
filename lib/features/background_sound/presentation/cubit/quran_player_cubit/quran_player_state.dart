part of 'quran_player_cubit.dart';

class QuranPlayerState extends Equatable {
  const QuranPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final bool isPlaying;
  final Duration position;
  final Duration duration;

  QuranPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return QuranPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object> get props => [isPlaying, position, duration];
}
