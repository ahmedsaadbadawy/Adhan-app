part of 'quran_player_cubit.dart';

class QuranPlayerState extends Equatable {
  const QuranPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playlist = const [],
    this.currentIndex = 0,
  });

  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<AudioModel> playlist;
  final int currentIndex;

  QuranPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    List<AudioModel>? playlist,
    int? currentIndex,
  }) {
    return QuranPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [isPlaying, position, duration, playlist, currentIndex];
}
