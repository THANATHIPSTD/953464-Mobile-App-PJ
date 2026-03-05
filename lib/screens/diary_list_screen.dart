import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../models/diary_entry.dart';
import 'diary_write_screen.dart';
import 'diary_detail_screen.dart';

class DiaryListScreen extends StatelessWidget {
  final List<DiaryEntry> entries;
  final Function(DiaryEntry) onAddEntry;
  final LocalAuthentication auth;

  const DiaryListScreen({
    super.key,
    required this.entries,
    required this.onAddEntry,
    required this.auth,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _monthYearKey(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  //hint//
  // logic same as login_screen.dart //
  // the mock data have boolean variable name "isLocked" use this one to check have to authen or not //

  Future<void> _openEntry(BuildContext context, DiaryEntry entry) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryDetailScreen(entry: entry),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F0E8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: const Color(0xFF8A7E6B).withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No diary entries yet...',
                style: TextStyle(fontSize: 18, color: Color(0xFF7A7267)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap + to start writing!',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9689)),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFab(context),
      );
    }

    // Sort newest first
    final sorted = List<DiaryEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Group by month
    final Map<String, List<DiaryEntry>> grouped = {};
    for (final entry in sorted) {
      final key = _monthYearKey(entry.date);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(entry);
    }

    final monthKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: monthKeys.length,
        itemBuilder: (context, monthIndex) {
          final monthKey = monthKeys[monthIndex];
          final monthEntries = grouped[monthKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month header tab
              if (monthIndex > 0) const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E4F5B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  monthKey,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Entries for this month
              ...monthEntries.map((entry) => _buildEntryCard(context, entry)),
            ],
          );
        },
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildEntryCard(BuildContext context, DiaryEntry entry) {
    return GestureDetector(
      onTap: () => _openEntry(context, entry),
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
              // Feeling emoji
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: entry.isLocked
                      ? const Color(0xFF3E4F5B).withOpacity(0.1)
                      : const Color(0xFFEDE8DF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    entry.feeling,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title + description (blur if locked)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3A44),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (entry.isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3E4F5B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 12,
                                  color: Color(0xFF3E4F5B),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'Secret',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF3E4F5B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description: blur if locked
                    entry.isLocked
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 6,
                                sigmaY: 6,
                              ),
                              child: Text(
                                entry.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7A7267),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        : Text(
                            entry.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7A7267),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Date
              Text(
                _formatDate(entry.date),
                style: const TextStyle(fontSize: 11, color: Color(0xFF9E9689)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push<DiaryEntry>(
          context,
          MaterialPageRoute(builder: (context) => const DiaryWriteScreen()),
        );
        if (result != null) onAddEntry(result);
      },
      backgroundColor: const Color(0xFF3E4F5B),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
