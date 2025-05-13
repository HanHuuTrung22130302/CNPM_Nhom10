import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'widgets/stat_charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatisticsScreen(),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final averageHours = mockStats.map((e) => e.studyHours).reduce((a, b) => a + b) / mockStats.length;
    final avgGoal = mockStats.map((e) => e.goalAchievedPercent).reduce((a, b) => a + b) / mockStats.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Thống kê học tập")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Số giờ học trung bình/ngày: ${averageHours.toStringAsFixed(1)} giờ"),
            Text("Tỷ lệ đạt mục tiêu: ${avgGoal.toStringAsFixed(0)}%"),
            const SizedBox(height: 12),

            const Text("Biểu đồ cột - Giờ học mỗi ngày", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: BarChartWidget(mockStats)),

            const SizedBox(height: 12),

            const Text("Biểu đồ tròn - Ưu tiên công việc", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: PieChartWidget(mockStats)),

            const SizedBox(height: 12),

            const Text("Biểu đồ đường - Xu hướng giờ học", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: LineChartWidget(mockStats)),

            const SizedBox(height: 12),

            const Text("Chi tiết theo ngày", style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockStats.length,
              itemBuilder: (context, index) {
                final stat = mockStats[index];
                return Card(
                  child: ListTile(
                    title: Text("${stat.date} - ${stat.studyHours} giờ học"),
                    subtitle: Text(
                        "${stat.completedTasks} công việc | ${stat.pomodoroSessions} Pomodoro | Mục tiêu: ${stat.goalAchievedPercent}%"),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Xuất PDF"),
              onPressed: () {
                // TODO: Gọi hàm xuất PDF tại đây
              },
            ),
          ],
        ),
      ),
    );
  }
}
