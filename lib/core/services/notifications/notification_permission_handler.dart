import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHandler {
  Future<void> handleNotificationsPermissions() async {
    if (!Platform.isAndroid) return;

    var notificationStatus = await Permission.notification.status;

    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();
    }

    // if (notificationStatus.isGranted) {
    //   debugPrint('✅ Notification permission granted');
    // } else {
    //   debugPrint('❌ Notification permission NOT granted');
    // }

    var alarmStatus = await Permission.scheduleExactAlarm.status;

    if (!alarmStatus.isGranted) {
      alarmStatus = await Permission.scheduleExactAlarm.request();
    }

    // if (alarmStatus.isGranted) {
    //   debugPrint('✅ Exact alarm permission granted');
    // } else {
    //   debugPrint('❌ Exact alarm permission NOT granted');
    // }
  }

  Future<void> checkAndRequestExactAlarmPermission(BuildContext context) async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) return;

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
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> checkAndRequestBatteryOptimization(BuildContext context) async {
    final status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) return;

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
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  Future<void> checkUnusedAppRestriction(BuildContext context) async {
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keep Prayer Notifications Working'),
        content: const Text(
          'Android may automatically stop apps that are not opened for a long time.\n\n'
          'On the next screen:\n\n'
          '• Tap "Manage app if unused"\n'
          '• Turn the switch OFF\n\n'
          'Otherwise, prayer notifications may stop after your app has not been used for some time.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await openAppSettings();
    }
  }
}
