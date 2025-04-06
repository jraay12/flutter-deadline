import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_application_1/service/alarm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';
void main() async{

   WidgetsFlutterBinding.ensureInitialized();

  // Initialize alarm manager
  await AlarmService.initialize();

  // Setup isolate communication for alarms
  final receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, 'alarm_isolate');

  receivePort.listen((dynamic data) {
    debugPrint("Received alarm signal: $data");
    // Show notification here
  });


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deadline Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  LoginPage(),
    );
  }
}

 
