import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/models/study_stat.dart';

class LineChartWidget extends StatelessWidget {
  final List<StudyStat> stats;
  const LineChartWidget(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    final labels = stats.map((e) => dateFormat.format(e.date)).toList();

    final studySpots = List.generate(
      stats.length,
      (i) => FlSpot(i.toDouble(), stats[i].completedTasks.toDouble()),
    );

    final pomodoroSpots = List.generate(
      stats.length,
      (i) => FlSpot(i.toDouble(), stats[i].pomodoroSessions.toDouble()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          //I1.16. Hệ thống hiển thị biểu đồ (LineChart)
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 7,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                      return Text(labels[index], style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: studySpots,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  isCurved: true,
                  spots: pomodoroSpots,
                  color: Colors.orange,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.circle, size: 10, color: Colors.blue),
            SizedBox(width: 4),
            Text("Số nhiệm vụ hoàn thành", style: TextStyle(fontSize: 12)),
            SizedBox(width: 16),
            Icon(Icons.circle, size: 10, color: Colors.orange),
            SizedBox(width: 4),
            Text("Số phiên Pomodoro", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
