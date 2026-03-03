import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason:
            'Scan fingerprint, face, or use PIN to unlock your diary.',
        biometricOnly: false,
      );

      if (didAuthenticate && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("Error during authentication: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดตัวแปรสีให้ตรงกับโลโก้
    const Color creamBgColor = Color(0xFFF6F3EB); // สีครีมจากพื้นหลังโลโก้
    const Color indigoColor = Color(0xFF3B4653); // สีคราม/กรมท่าจากปกไดอารี่

    return Scaffold(
      backgroundColor: creamBgColor,
      appBar: AppBar(
        title: const Text(
          'My Safe Diary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: indigoColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Icon - เปลี่ยนเป็นแม่กุญแจให้เข้ากับโลโก้
              const Icon(Icons.lock_outline, size: 100, color: indigoColor),
              const SizedBox(height: 30), // Spacing
              // Title
              const Text(
                'Unlock Your Diary',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: indigoColor, // ใช้สีครามกับหัวข้อ
                ),
              ),
              const SizedBox(height: 10), // Spacing
              // Subtitle
              const Text(
                'Securely access your memories.\nUse biometric data or PIN.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54, // สีเทาเข้มให้อ่านง่าย
                ),
              ),
              const SizedBox(height: 50), // Spacing
              // Button
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(
                  Icons.fingerprint,
                  size: 30,
                  color: Colors.white,
                ),
                label: const Text(
                  'Unlock',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: indigoColor, // ปุ่มสีคราม
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
