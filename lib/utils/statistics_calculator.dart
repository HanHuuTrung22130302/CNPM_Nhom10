import 'package:study_timer/models/study_stat.dart';

class StatisticsCalculator {
  static double totalStudyHours(List<StudyStat> stats) =>
      stats.isNotEmpty ? stats.map((e) => e.studyHours).fold(0.0, (a, b) => a + b) : 0.0;

  static int totalTasks(List<StudyStat> stats) =>
      stats.map((e) => e.completedTasks).fold(0, (a, b) => a + b);

  static double taskCompletionRate(List<StudyStat> stats) {
    if (stats.isEmpty) return 0.0;
    return (totalTasks(stats) / (stats.length * 5)) * 100;
  }

  static double avgGoalAchieved(List<StudyStat> stats) {
    if (stats.isEmpty) return 0.0;
    return stats.map((e) => e.goalAchievedPercent).fold(0.0, (a, b) => a + b) / stats.length;
  }
}
