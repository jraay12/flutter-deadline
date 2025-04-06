// alarm_service.dart
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_application_1/service/notification_service.dart';

// Global variable for passing task info to the alarm callback
@pragma('vm:entry-point')
class AlarmInfo {
  static Map<int, Map<String, String>> taskInfo = {};
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  // This function is called when the alarm fires
  debugPrint("Alarm fired!");
  final SendPort? send = IsolateNameServer.lookupPortByName('alarm_isolate');

  // Get the task ID from the alarm
  final int taskId = Isolate.current.hashCode;
  send?.send({'taskId': taskId});
}

class AlarmService {
  static final NotificationService _notificationService = NotificationService();

  static Future<bool> initialize() async {
    await _notificationService.initialize();
    // Removed the request permissions call
    return await AndroidAlarmManager.initialize();
  }

  static Future<bool> scheduleAlarm(
    int id,
    String title,
    DateTime scheduledTime,
  ) async {
    debugPrint("Scheduling alarm for $title at $scheduledTime");

    // Store task info in global map to access it from callback
    AlarmInfo.taskInfo[id] = {
      'title': title,
      'description': 'Task deadline reminder',
    };

    return await AndroidAlarmManager.oneShotAt(
      scheduledTime,
      id,
      callbackDispatcher,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      alarmClock: true,
    );
  }

  static Future<bool> cancelAlarm(int id) async {
    // Clean up the task info when canceling
    AlarmInfo.taskInfo.remove(id);
    return await AndroidAlarmManager.cancel(id);
  }

  // Show notification for a task
  static Future<void> showTaskNotification(int taskId) async {
    final taskInfo = AlarmInfo.taskInfo[taskId];
    if (taskInfo != null) {
      await _notificationService.showNotification(
        id: taskId,
        title: taskInfo['title'] ?? 'Task Reminder',
        body: taskInfo['description'] ?? 'You have a task due now!',
        payload: taskId.toString(),
      );
    } else {
      // Fallback if task info is not found
      await _notificationService.showNotification(
        id: taskId,
        title: 'Task Reminder',
        body: 'You have a task due now!',
        payload: taskId.toString(),
      );
    }
  }
}
