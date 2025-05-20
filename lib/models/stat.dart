class Stat {
  final String date;
  final double studyHours;
  final int completedTasks;
  final int pomodoroSessions;
  final double goalAchievedPercent;
  final Map<String, int> priorityTasks;

  Stat({
    required this.date,
    required this.studyHours,
    required this.completedTasks,
    required this.pomodoroSessions,
    required this.goalAchievedPercent,
    required this.priorityTasks,
  });
}