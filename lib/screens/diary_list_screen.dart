import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'diary_write_screen.dart';
import 'diary_detail_screen.dart';

class DiaryListScreen extends StatelessWidget {
  final List<DiaryEntry> entries;
  final Function(DiaryEntry) onAddEntry;

  const DiaryListScreen({
    super.key,
    required this.entries,
    required this.onAddEntry,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_rounded, size: 80, color: const Color(0xFF8A7E6B).withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No diary entries yet...', style: TextStyle(fontSize: 18, color: Color(0xFF7A7267))),
                  const SizedBox(height: 8),
                  const Text('Tap + to start writing!', style: TextStyle(fontSize: 14, color: Color(0xFF9E9689))),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[entries.length - 1 - index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DiaryDetailScreen(entry: entry),
                    ));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF3E4F5B).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE8DF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(entry.feeling, style: const TextStyle(fontSize: 24))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(entry.description,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF7A7267)),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_formatDate(entry.date), style: const TextStyle(fontSize: 11, color: Color(0xFF9E9689))),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<DiaryEntry>(
            context,
            MaterialPageRoute(builder: (context) => const DiaryWriteScreen()),
          );
          if (result != null) onAddEntry(result);
        },
        backgroundColor: const Color(0xFF3E4F5B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}