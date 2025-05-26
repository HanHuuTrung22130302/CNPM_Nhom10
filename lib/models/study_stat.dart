class StudyStat {
  final DateTime date;
  final double studyHours;
  final int completedTasks;
  final int pomodoroSessions;
  final double goalAchievedPercent;

  StudyStat({
    required this.date,
    required this.studyHours,
    required this.completedTasks,
    required this.pomodoroSessions,
    required this.goalAchievedPercent,
  });

  factory StudyStat.fromJson(Map<String, dynamic> json) {
    return StudyStat(
      date: DateTime.parse(json['date']),
      studyHours: (json['studyHours'] as num).toDouble(), // ✅ đảm bảo là double
      completedTasks: json['completedTasks'] as int,
      pomodoroSessions: json['pomodoroSessions'] as int,
      goalAchievedPercent: (json['goalAchievedPercent'] as num).toDouble(), // ✅
    );
  }
}