part of 'adhan_cubit.dart';

@immutable
sealed class AdhanState extends Equatable {
  const AdhanState();

  @override
  List<Object?> get props => [];
}

final class AdhanInitial extends AdhanState {}

final class AdhanLoading extends AdhanState {}

class AdhanSuccess extends AdhanState {
  final AdhanStatus adhanStatus;

  const AdhanSuccess({required this.adhanStatus});

  @override
  List<Object?> get props => [adhanStatus];
}

final class AdhanError extends AdhanState {
  final String message;

  const AdhanError(this.message);

  @override
  List<Object?> get props => [message];
}
