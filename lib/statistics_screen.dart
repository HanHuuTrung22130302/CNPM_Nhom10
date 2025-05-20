import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<StudyStatResponse> _statsFuture;

  @override
  void initState() {
    super.initState();
    // I1.2. Giao diện thống kê gửi yêu cầu GET /api/stats?range=week để lấy dữ liệu thống kê mặc định (7 ngày gần nhất).
    _statsFuture = ApiService().getStats("week");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📊 Phân tích & Thống kê")),
      body: FutureBuilder<StudyStatResponse>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // I1.8. Trong khi chờ dữ liệu, hiển thị loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // I1.8. Nếu lỗi xảy ra khi lấy dữ liệu từ API
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // I1.8. Không có dữ liệu để hiển thị
            return const Center(child: Text('Không có dữ liệu.'));
          }

          final data = snapshot.data!;
          // I1.8. Dữ liệu được nhận từ API và hiển thị biểu đồ + KPIs

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Biểu đồ số giờ học mỗi ngày"),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups:
                          data.stats
                              .map(
                                (stat) => BarChartGroupData(
                                  x: data.stats.indexOf(stat),
                                  barRods: [
                                    BarChartRodData(
                                      toY: stat.studyHours,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              return Text(data.stats[value.toInt()].date);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("KPIs"),
                Text("Số giờ học trung bình/ngày: ${data.kpi['avgStudy']}"),
                Text(
                  "Tỉ lệ hoàn thành công việc: ${data.kpi['taskCompletion']}%",
                ),
                Text("Tỉ lệ đạt mục tiêu: ${data.kpi['goalAchieved']}%"),
              ],
            ),
          );
        },
      ),
    );
  }
}
