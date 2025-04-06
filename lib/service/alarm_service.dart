// alarm_service.dart
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  // This function is called when the alarm fires
  debugPrint("Alarm fired!");
  final SendPort? send = IsolateNameServer.lookupPortByName('alarm_isolate');
  send?.send('ALARM_TRIGGERED');
}

class AlarmService {
  static Future<bool> initialize() async {
    return await AndroidAlarmManager.initialize();
  }

  static Future<bool> scheduleAlarm(
    int id,
    String title,
    DateTime scheduledTime,
  ) async {
    debugPrint("Scheduling alarm for $title at $scheduledTime");
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
    return await AndroidAlarmManager.cancel(id);
  }
}
