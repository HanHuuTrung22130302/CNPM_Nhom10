class StudyStat {
  final DateTime date;
  final double studyHours;
  final int completedTasks;
  final int pomodoroSessions;
  final int goalAchievedPercent;

  StudyStat({
    required this.date,
    required this.studyHours,
    required this.completedTasks,
    required this.pomodoroSessions,
    required this.goalAchievedPercent,
  });
}