import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secret Diary',
      theme: ThemeData(
        primaryColor: const Color(0xFF3E4F5B),
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3E4F5B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}