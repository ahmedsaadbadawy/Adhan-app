import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_setup_state.dart';

class PermissionSetupCubit extends Cubit<PermissionSetupState> {
  PermissionSetupCubit() : super(PermissionSetupInitial());

  late bool unusedAppConfigured = false;
  Future<void> loadPermissions() async {
    final notificationGranted = await Permission.notification.isGranted;

    final exactAlarmGranted = await Permission.scheduleExactAlarm.isGranted;

    final batteryGranted =
        await Permission.ignoreBatteryOptimizations.isGranted;

    // We can't detect this one.

    emit(
      PermissionSetupLoaded(
        notificationGranted: notificationGranted,
        exactAlarmGranted: exactAlarmGranted,
        batteryOptimizationGranted: batteryGranted,
        unusedAppConfigured: unusedAppConfigured,
      ),
    );
  }

  Future<void> refresh() async {
    await loadPermissions();
  }
}
