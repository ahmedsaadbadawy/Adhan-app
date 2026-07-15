import 'package:flutter/material.dart';

import '../../../../../core/DI/service_allocator.dart';
import '../../../../../core/services/notifications/notification_permission_handler.dart';
import '../../cubit/permission_setup/permission_setup_cubit.dart';
import 'permission_tile.dart';

class PermissionTilesSection extends StatelessWidget {
  const PermissionTilesSection({
    super.key,
    required this.cubit,
    required this.state,
  });

  final PermissionSetupCubit cubit;

  final PermissionSetupLoaded state;

  @override
  Widget build(BuildContext context) {
    final handler = getIt<NotificationPermissionHandler>();

    return Column(
      children: [
        PermissionTile(
          title: "Notifications",
          subtitle: "Allow prayer notifications.",
          granted: state.notificationGranted,
          onPressed: () async {
            await handler.handleNotificationsPermissions();
            await cubit.refresh();
          },
        ),

        PermissionTile(
          title: "Exact Alarm",
          subtitle: "Required for accurate prayer times.",
          granted: state.exactAlarmGranted,
          onPressed: () async {
            await handler.checkAndRequestExactAlarmPermission(context);
            await cubit.refresh();
          },
        ),

        PermissionTile(
          title: "Battery Optimization",
          subtitle: "Prevent Android from delaying notifications.",
          granted: state.batteryOptimizationGranted,
          onPressed: () async {
            await handler.checkAndRequestBatteryOptimization(context);
            await cubit.refresh();
          },
        ),

        PermissionTile(
          title: "Manage App If Unused",
          subtitle:
              "Prevent Android from stopping the app after long periods of inactivity.",
          granted: state.unusedAppConfigured,
          onPressed: () async {
            await handler.checkUnusedAppRestriction(context).then((_) {
              cubit.unusedAppConfigured = true;
            });

            await cubit.refresh();
          },
        ),
      ],
    );
  }
}
