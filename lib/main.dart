import 'package:flutter/material.dart';
import 'package:flutter_todo_app/theme.dart';
import 'package:flutter_todo_app/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme().theme,
      home: const WelcomePage(),
    );
  }
}
