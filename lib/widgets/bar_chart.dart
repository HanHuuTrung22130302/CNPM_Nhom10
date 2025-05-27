import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/models/study_stat.dart';

class BarChartWidget extends StatelessWidget {
  final List<StudyStat> stats;
  const BarChartWidget(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    final groups = stats.asMap().entries.map((e) {
      final idx = e.key;
      final stat = e.value;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(toY: stat.studyHours, width: 16, color: Colors.blue),
        ],
      );
    }).toList();
    // I1.15. Hệ thống hiển thị biểu đồ (BarChart)
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: stats.map((e) => e.studyHours).reduce((a, b) => a > b ? a : b) + 1,
        barGroups: groups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= stats.length) return const SizedBox.shrink();
                return Text(dateFormat.format(stats[idx].date), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
      ),
    );
  }
}