import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // ดึงหน้า Login มาเป็นหน้าแรก

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Diary',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginScreen(), 
    );
  }
}