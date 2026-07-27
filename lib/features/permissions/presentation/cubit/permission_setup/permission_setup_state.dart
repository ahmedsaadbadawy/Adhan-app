part of 'permission_setup_cubit.dart';

sealed class PermissionSetupState extends Equatable {
  const PermissionSetupState();

  @override
  List<Object> get props => [];
}

final class PermissionSetupInitial extends PermissionSetupState {}

final class PermissionSetupLoaded extends PermissionSetupState {
  const PermissionSetupLoaded({
    required this.notificationGranted,
    required this.exactAlarmGranted,
    required this.batteryOptimizationGranted,
    required this.unusedAppConfigured,
  });

  final bool notificationGranted;
  final bool exactAlarmGranted;
  final bool batteryOptimizationGranted;
  final bool unusedAppConfigured;

  int get totalPermissions => 4;

  int get completedCount => [
        notificationGranted,
        exactAlarmGranted,
        batteryOptimizationGranted,
        unusedAppConfigured,
      ].where((granted) => granted).length;

  double get progress => completedCount / totalPermissions;

  bool get allCompleted => completedCount == totalPermissions;

  PermissionSetupLoaded copyWith({
    bool? notificationGranted,
    bool? exactAlarmGranted,
    bool? batteryOptimizationGranted,
    bool? unusedAppConfigured,
  }) {
    return PermissionSetupLoaded(
      notificationGranted: notificationGranted ?? this.notificationGranted,
      exactAlarmGranted: exactAlarmGranted ?? this.exactAlarmGranted,
      batteryOptimizationGranted:
          batteryOptimizationGranted ?? this.batteryOptimizationGranted,
      unusedAppConfigured: unusedAppConfigured ?? this.unusedAppConfigured,
    );
  }

  @override
  List<Object> get props => [
    notificationGranted,
    exactAlarmGranted,
    batteryOptimizationGranted,
    unusedAppConfigured,
  ];
}
