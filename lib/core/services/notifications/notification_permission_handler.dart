import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHandler {
  Future<void> handleNotificationsPermissions() async {
    // print("NotificationService.init() called");
    var notificationStatus = await Permission.notification.status;
    // print('Notification status = $notificationStatus');

    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();
      // print('Notification after request = $notificationStatus');
    }

    var alarmStatus = await Permission.scheduleExactAlarm.status;
    // print('Alarm status = $alarmStatus');

    if (!alarmStatus.isGranted) {
      alarmStatus = await Permission.scheduleExactAlarm.request();
      // print('Alarm after request = $alarmStatus');
    }
  }

  Future<void> checkAndRequestExactAlarmPermission(BuildContext context) async {
    final status = await Permission.scheduleExactAlarm.status;

    if (!status.isGranted) {
      if (!context.mounted) return;

      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Enable Precise Prayer Alerts'),
          content: const Text(
            'To make sure Adhan notifications arrive exactly at prayer time — even when the app is closed or your phone is locked — please allow "Alarms & reminders" access in the next screen.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        final result = await Permission.scheduleExactAlarm.request();

        if (result.isGranted) {
          debugPrint('✅ Exact alarm permission granted.');
        } else {
          debugPrint(
            '⚠️ Exact alarm permission denied — notifications may be inexact.',
          );
        }
      } else {
        debugPrint('User postponed exact alarm permission.');
      }
    }
  }

  Future<void> checkAndRequestBatteryOptimization(BuildContext context) async {
    final isGranted = await Permission.ignoreBatteryOptimizations.isGranted;

    if (!isGranted) {
      if (!context.mounted) return;

      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Disable Battery Optimization'),
          content: const Text(
            'To ensure you receive Adhan notifications accurately even when your phone is locked or asleep, please allow the app to ignore battery optimizations.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow'),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        final status = await Permission.ignoreBatteryOptimizations.request();

        if (status.isGranted) {
          // print('Battery optimization disabled for this app.');
        } else {
          // print('User declined to disable battery optimization.');
        }
      }
    }
  }
}
