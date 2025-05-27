import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/models/study_stat.dart';
import 'package:study_timer/services/statistics_service.dart';
import 'package:study_timer/widgets/line_chart.dart';
import 'package:study_timer/widgets/bar_chart.dart';
import 'package:study_timer/widgets/kpi_box.dart';
import 'package:study_timer/utils/statistics_calculator.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Future<List<StudyStat>> _futureStats;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 6));
    // I1.6. Màn hình thống kê (StatistisScreen) được khởi tại và gọi hàm fetchStats() để lấy dữ liệu 7 ngày gần nhất.
    _futureStats = StatisticsService.fetchStats(_startDate, _endDate);
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
        _futureStats = StatisticsService.fetchStats(_startDate, _endDate);
      });
    }
  }

  Future<void> exportPdf() async {
    // Placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng xuất PDF chưa được triển khai')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    return Scaffold(
      appBar: AppBar(title: const Text("📊 Phân tích & Thống kê")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<StudyStat>>(
              future: _futureStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có dữ liệu.'));
                }

                final stats = snapshot.data!;
                final double totalStudyHours = StatisticsCalculator.totalStudyHours(stats);
                final double taskCompletionRate = StatisticsCalculator.taskCompletionRate(stats);
                final double avgGoalAchieved = StatisticsCalculator.avgGoalAchieved(stats);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin ngày tháng + chọn ngày
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
                            // I1.17. Người dùng có thể click chọn (Icon) lịch ngày để chọn lại khoảng thời gian muốn cập nhật dữ liệu thống kê.
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: const Text("Chọn"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // KPI Boxes
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
                        "📉 Biểu đồ số nhiệm vụ & phiên pomodoro mỗi ngày",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(height: 260, child: LineChartWidget(stats)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Footer
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
