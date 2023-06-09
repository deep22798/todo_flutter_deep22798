import 'package:flutter/material.dart';
import 'package:todo_flutter_master_by_deep22798/screens/splash.dart';
import 'package:todo_flutter_master_by_deep22798/screens/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo_Deep22798',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}
