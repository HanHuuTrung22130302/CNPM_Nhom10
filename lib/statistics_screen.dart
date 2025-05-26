import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/data/mock_data.dart';
import 'package:study_timer/models/study_stat.dart';
import 'package:study_timer/widgets/line_chart.dart';
import 'package:study_timer/widgets/bar_chart.dart';
import 'package:study_timer/widgets/kpi_box.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _endDate = DateTime(today.year, today.month, today.day);
    _startDate = _endDate.subtract(const Duration(days: 6));
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> exportPdf() async {
    // TODO: Thêm code xuất PDF tại đây
    // Ví dụ: gọi service backend hoặc tạo file PDF trực tiếp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng xuất PDF chưa được triển khai')),
    );
  }

  List<StudyStat> get _filteredStats {
    return mockStats.where((stat) {
      final date = stat.date;
      return !date.isAfter(DateTime.now()) &&
          date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _filteredStats;
    final dateFormat = DateFormat('dd/MM');

    final double totalStudyHours =
        stats.isNotEmpty
            ? stats.map((e) => e.studyHours).fold(0.0, (a, b) => a + b)
            : 0.0;
    final int totalTasks = stats
        .map((e) => e.completedTasks)
        .fold(0, (a, b) => a + b);
    final double taskCompletionRate =
        stats.isNotEmpty ? (totalTasks / (stats.length * 5)) * 100 : 0.0;
    final double avgGoalAchieved =
        stats.isNotEmpty
            ? stats
                    .map((e) => e.goalAchievedPercent)
                    .fold(0.0, (a, b) => a + b) /
                stats.length
            : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text("📊 Phân tích & Thống kê")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần thống kê hiện tại
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📅 Thống kê từ ${dateFormat.format(_startDate)} đến ${dateFormat.format(_endDate)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: const Text("Chọn"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KpiBox(
                        icon: Icons.access_time,
                        title: "Tổng giờ học",
                        value: "${totalStudyHours.toStringAsFixed(1)} giờ",
                      ),
                      KpiBox(
                        icon: Icons.check_circle,
                        title: "Hoàn thành công việc",
                        value: "${taskCompletionRate.toStringAsFixed(1)}%",
                      ),
                      KpiBox(
                        icon: Icons.emoji_events,
                        title: "Đạt mục tiêu",
                        value: "${avgGoalAchieved.toStringAsFixed(1)}%",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "📊 Biểu đồ số giờ học mỗi ngày",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 200, child: BarChartWidget(stats)),
                  const SizedBox(height: 24),
                  const Text(
                    "📉 Biểu đồ thống kê số nhiệm vụ và phiên pomodoro mỗi ngày",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 260, child: LineChartWidget(stats)),
                ],
              ),
            ),
          ),

          // Footer với nút Xuất PDF và bản quyền
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "© 2025 Study Timer App",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: exportPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Xuất PDF"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
