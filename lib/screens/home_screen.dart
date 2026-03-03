import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../data/mock_data.dart';
import 'diary_list_screen.dart';
import 'calendar_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<DiaryEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = generateMockData();
  }

  void _addEntry(DiaryEntry entry) {
    setState(() {
      _entries.add(entry);
    });
  }

  void _lockDiary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DiaryListScreen(entries: _entries, onAddEntry: _addEntry),
      CalendarScreen(entries: _entries, onAddEntry: _addEntry),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Diary'),
        backgroundColor: const Color(0xFF3E4F5B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _lockDiary,
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Lock Diary',
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF3E4F5B),
        unselectedItemColor: const Color(0xFF9E9689),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}