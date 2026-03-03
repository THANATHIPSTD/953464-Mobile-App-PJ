import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends StatelessWidget {
  final DiaryEntry entry;

  const DiaryDetailScreen({super.key, required this.entry});

  String _formatDate(DateTime date) {
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text('Read Diary 📖'),
        backgroundColor: const Color(0xFF3E4F5B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3E4F5B), Color(0xFF2C3A44)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF3E4F5B).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                children: [
                  Text(entry.feeling, style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 14),
                  Text(entry.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(_formatDate(entry.date), style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF3E4F5B).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                entry.description.isEmpty ? 'No description' : entry.description,
                style: const TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF2C3A44)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}