import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class DiaryWriteScreen extends StatefulWidget {
  final DateTime? initialDate;

  const DiaryWriteScreen({super.key, this.initialDate});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedFeeling = '😊';

  final List<String> _feelings = ['😊','😢','😡','😍','😴','🤔','😎','🥺','🎉','💔'];

  String _formatDate(DateTime date) {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _save() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title first'), backgroundColor: Color(0xFF8A7E6B)),
      );
      return;
    }

    final entry = DiaryEntry(
      title: _titleController.text,
      feeling: _selectedFeeling,
      description: _descController.text,
      date: widget.initialDate ?? DateTime.now(),
    );
    Navigator.pop(context, entry);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = widget.initialDate ?? DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text('Write Diary ✏️'),
        backgroundColor: const Color(0xFF3E4F5B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8A7E6B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Color(0xFF8A7E6B)),
                  const SizedBox(width: 6),
                  Text(_formatDate(displayDate), style: const TextStyle(color: Color(0xFF8A7E6B), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Feeling selector
            const Text('How are you feeling?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44))),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _feelings.length,
                itemBuilder: (context, index) {
                  final feeling = _feelings[index];
                  final isSelected = feeling == _selectedFeeling;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFeeling = feeling),
                    child: Container(
                      width: 50,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3E4F5B).withOpacity(0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF3E4F5B) : const Color(0xFFEDE8DF),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(child: Text(feeling, style: const TextStyle(fontSize: 24))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44))),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. A Beautiful Day ☀️',
                hintStyle: const TextStyle(color: Color(0xFF9E9689)),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDE8DF))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3E4F5B), width: 1.5)),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text('Tell me about it...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3A44))),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Pour out your feelings here...\nThe good, the bad, anything at all 💭',
                hintStyle: const TextStyle(color: Color(0xFF9E9689)),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDE8DF))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3E4F5B), width: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}