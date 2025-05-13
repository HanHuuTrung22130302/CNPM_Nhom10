import '../models/stat.dart';

class StudyStat {
  final String date;
  final double studyHours;
  final int completedTasks;
  final int pomodoroSessions;
  final int goalAchievedPercent;
  final String priority; 

  StudyStat({
    required this.date,
    required this.studyHours,
    required this.completedTasks,
    required this.pomodoroSessions,
    required this.goalAchievedPercent,
    required this.priority,
  });
}

final List<StudyStat> mockStats = [
  StudyStat(date: "Thứ Hai",   studyHours: 4.5, completedTasks: 3, pomodoroSessions: 4, goalAchievedPercent: 75, priority: "High"),
  StudyStat(date: "Thứ Ba",    studyHours: 3.2, completedTasks: 2, pomodoroSessions: 3, goalAchievedPercent: 60, priority: "Medium"),
  StudyStat(date: "Thứ Tư",    studyHours: 2.5, completedTasks: 1, pomodoroSessions: 2, goalAchievedPercent: 40, priority: "Low"),
  StudyStat(date: "Thứ Năm",   studyHours: 3.8, completedTasks: 4, pomodoroSessions: 5, goalAchievedPercent: 90, priority: "High"),
  StudyStat(date: "Thứ Sáu",   studyHours: 5.0, completedTasks: 5, pomodoroSessions: 6, goalAchievedPercent: 95, priority: "Medium"),
  StudyStat(date: "Thứ Bảy",   studyHours: 4.0, completedTasks: 3, pomodoroSessions: 4, goalAchievedPercent: 80, priority: "Low"),
  StudyStat(date: "Chủ Nhật",  studyHours: 3.6, completedTasks: 2, pomodoroSessions: 3, goalAchievedPercent: 70, priority: "High"),
];
