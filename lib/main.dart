import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/homepage.dart'; // <-- replace with your actual home screen
import 'package:flutter_application_1/service/alarm_service.dart';
import 'package:flutter_application_1/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AlarmService.initialize();

  final receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, 'alarm_isolate');

  receivePort.listen((dynamic data) {
    debugPrint("Received alarm signal: $data");
    if (data is Map && data.containsKey('taskId')) {
      int taskId = data['taskId'];
      AlarmService.showTaskNotification(taskId);
    }
  });

  // Determine initial screen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  Widget initialScreen;

  if (token != null && !JwtDecoder.isExpired(token)) {
    initialScreen =
        const Homepage(); // <-- Replace with your actual home screen
  } else {
    initialScreen =  LoginPage();
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deadline Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: initialScreen,
    );
  }
}
