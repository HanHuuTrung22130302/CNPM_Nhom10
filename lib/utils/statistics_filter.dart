import 'package:study_timer/models/study_stat.dart';

List<StudyStat> filterStatsByDateRange(
  List<StudyStat> stats,
  DateTime start,
  DateTime end,
) {
  return stats.where((stat) {
    final date = stat.date;
    return !date.isAfter(DateTime.now()) &&
        date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }).toList();
}
