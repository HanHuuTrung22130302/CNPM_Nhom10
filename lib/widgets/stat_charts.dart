import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/mock_data.dart';

class BarChartWidget extends StatelessWidget {
  final List<StudyStat> stats;
  const BarChartWidget(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo BarChartGroupData cho mỗi ngày
    final groups = stats.asMap().entries.map((e) {
      final idx = e.key;
      final stat = e.value;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(toY: stat.studyHours, width: 16),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: stats.map((e) => e.studyHours).reduce((a, b) => a > b ? a : b) + 1,
        barGroups: groups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= stats.length) return const SizedBox.shrink();
                return Text(stats[idx].date, style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<StudyStat> stats;
  const PieChartWidget(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    // Đếm số ngày cho mỗi mức ưu tiên
    final count = <String, int>{'High': 0, 'Medium': 0, 'Low': 0};
    for (var s in stats) count[s.priority] = count[s.priority]! + 1;

    final colors = [Colors.red, Colors.orange, Colors.green];
    final entries = count.entries.toList();
    return PieChart(
      PieChartData(
        sections: entries.asMap().entries.map((e) {
          final i = e.key;
          final pr = e.value;
          return PieChartSectionData(
            value: pr.value.toDouble(),
            title: '${pr.key}: ${pr.value}',
            radius: 50,
            color: colors[i % colors.length],
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<StudyStat> stats;
  const LineChartWidget(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    final spots = stats.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.studyHours);
    }).toList();

    return LineChart(
      LineChartData(
        maxY: stats.map((e) => e.studyHours).reduce((a, b) => a > b ? a : b) + 1,
        minY: 0,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= stats.length) return const SizedBox.shrink();
              return Text(stats[idx].date, style: const TextStyle(fontSize: 10));
            }),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        lineBarsData: [
          LineChartBarData(isCurved: true, spots: spots, dotData: FlDotData(show: true)),
        ],
      ),
    );
  }
}
