import 'package:final_project/model//theme.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/auth.dart';
import 'package:final_project/screens/user.dart';
import 'package:final_project/screens/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RegScreen(),
        '/users': (context) => const UserScreen(),
        '/tasks': (context) => const TaskMainScreen(),
      },
      title: 'Final Project',
      theme: myTheme(),
    );
  }
}
