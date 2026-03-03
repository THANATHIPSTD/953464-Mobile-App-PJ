import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

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


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      // โค้ดที่ปรับแก้แล้ว ไม่ต้องใช้ options
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'สแกนนิ้วหรือใบหน้าเพื่อปลดล็อกไดอารี่',
        biometricOnly: true, 
      );

      // ถ้าสแกนผ่าน ให้เปลี่ยนไปหน้า DiaryScreen
      if (didAuthenticate && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiaryScreen()),
        );
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการสแกน: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('My Safe Diary'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _authenticate,
          icon: const Icon(Icons.fingerprint, size: 50),
          label: const Text('Unlock Diary', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// ส่วนหน้าสมุดไดอารี่
// ---------------------------------------------------
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> notes = []; 

  void _saveNote() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        notes.add(_controller.text);
        _controller.clear(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('My Secret Diary 💖'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'วันนี้รู้สึกยังไงบ้าง ระบายมาได้เลย...',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
                    title: Text(notes[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}