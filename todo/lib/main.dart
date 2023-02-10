import 'package:flutter/material.dart';
import 'package:todo/screens/show_task.dart';

import 'screens/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        '/show_tasks': (context) => const ShowTasks(),
      },
    );
  }
}
