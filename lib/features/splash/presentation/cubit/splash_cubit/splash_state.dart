part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {}

final class SplashLoading extends SplashState {}

final class SplashNavigateHome extends SplashState {}

final class SplashNavigatePrayerTimes extends SplashState {}

final class SplashNavigateQuran extends SplashState {}
