import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'diary_detail_screen.dart';
import 'diary_write_screen.dart';

class CalendarScreen extends StatefulWidget {
  final List<DiaryEntry> entries;
  final Function(DiaryEntry) onAddEntry;

  const CalendarScreen({super.key, required this.entries, required this.onAddEntry});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  List<DiaryEntry> _getEntriesForDate(DateTime date) {
    return widget.entries.where((e) =>
      e.date.year == date.year && e.date.month == date.month && e.date.day == date.day
    ).toList();
  }

  bool _hasEntry(DateTime date) => _getEntriesForDate(date).isNotEmpty;

  void _previousMonth() => setState(() { _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1); _selectedDate = null; });
  void _nextMonth() => setState(() { _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1); _selectedDate = null; });

  Future<void> _addEntryForSelectedDate() async {
    if (_selectedDate == null) return;
    final result = await Navigator.push<DiaryEntry>(
      context,
      MaterialPageRoute(builder: (context) => DiaryWriteScreen(initialDate: _selectedDate)),
    );
    if (result != null) {
      widget.onAddEntry(result);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    final startOffset = firstWeekday % 7;

    const monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December'];

    final selectedEntries = _selectedDate != null ? _getEntriesForDate(_selectedDate!) : <DiaryEntry>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Column(
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: _previousMonth, icon: const Icon(Icons.chevron_left, color: Color(0xFF3E4F5B))),
                Text('${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44)),
                ),
                IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right, color: Color(0xFF3E4F5B))),
              ],
            ),
          ),

          // Day names
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
                .map((d) => SizedBox(
                  width: 40,
                  child: Center(child: Text(d,
                    style: TextStyle(fontWeight: FontWeight.bold, color: d == 'Sun' ? Colors.red[300] : const Color(0xFF7A7267), fontSize: 12),
                  )),
                )).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
              itemCount: startOffset + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startOffset) return const SizedBox();

                final day = index - startOffset + 1;
                final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                final hasEntry = _hasEntry(date);
                final isToday = date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day;
                final isSelected = _selectedDate != null && date.year == _selectedDate!.year && date.month == _selectedDate!.month && date.day == _selectedDate!.day;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3E4F5B) : isToday ? const Color(0xFFEDE8DF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isToday && !isSelected ? Border.all(color: const Color(0xFF3E4F5B), width: 1.5) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$day', style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : const Color(0xFF2C3A44),
                        )),
                        if (hasEntry)
                          Container(
                            width: 6, height: 6,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : const Color(0xFF8A7E6B),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Selected date header + Add button
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${monthNames[_selectedDate!.month - 1]} ${_selectedDate!.day}, ${_selectedDate!.year}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addEntryForSelectedDate,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Entry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E4F5B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFFEDE8DF), thickness: 1),

          // Entries for selected date
          Expanded(
            child: _selectedDate == null
                ? const Center(child: Text('Select a date to view entries 📅', style: TextStyle(color: Color(0xFF9E9689), fontSize: 15)))
                : selectedEntries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No entries for this day 💭', style: TextStyle(color: Color(0xFF9E9689), fontSize: 15)),
                            const SizedBox(height: 8),
                            Text('Tap "Add Entry" to write one!', style: TextStyle(color: const Color(0xFF9E9689).withOpacity(0.6), fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedEntries.length,
                        itemBuilder: (context, index) {
                          final entry = selectedEntries[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryDetailScreen(entry: entry))),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Text(entry.feeling, style: const TextStyle(fontSize: 28)),
                                title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3A44))),
                                subtitle: Text(entry.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF7A7267))),
                                trailing: const Icon(Icons.chevron_right, color: Color(0xFF8A7E6B)),
                              ),
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