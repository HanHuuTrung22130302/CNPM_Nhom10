import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'study_storage.dart';

//kiểm tra hiệu suất
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int> _timePerTask = {};
  int _totalTime = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final sessions = await StudyStorage.getSessions();
    Map<String, int> map = {};
    int total = 0;
    for (var s in sessions) {
      map[s.taskName] = (map[s.taskName] ?? 0) + s.durationSeconds;
      total += s.durationSeconds;
    }
    setState(() {
      _timePerTask = map;
      _totalTime = total;
    });
  }

  List<PieChartSectionData> _generateSections() {
    final List<PieChartSectionData> list = [];
    _timePerTask.forEach((task, duration) {
      final percent = duration / _totalTime * 100;
      list.add(
        PieChartSectionData(
          value: duration.toDouble(),
          title: '${percent.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });
    return list;
  }

  //H1.3.8 hiển thị tổng thời gian
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê học tập')),
      body:
          _timePerTask.isEmpty
              ? Center(child: Text('Chưa có dữ liệu để thống kê'))
              : Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Tổng thời gian học: ${(_totalTime / 60).toStringAsFixed(1)} phút',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _generateSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          _timePerTask.entries.map((e) {
                            final percent = e.value / _totalTime * 100;
                            return ListTile(
                              title: Text(e.key),
                              trailing: Text(
                                '${(e.value / 60).toStringAsFixed(1)} phút (${percent.toStringAsFixed(1)}%)',
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
    );
  }
}
