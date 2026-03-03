class DiaryEntry {
  final String title;
  final String feeling;
  final String description;
  final DateTime date;
  final bool isLocked;

  DiaryEntry({
    required this.title,
    required this.feeling,
    required this.description,
    required this.date,
    this.isLocked = false,
  });
}