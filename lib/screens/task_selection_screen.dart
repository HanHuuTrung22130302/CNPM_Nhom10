import 'package:flutter/material.dart';
import 'study_timer_screen.dart';
import 'history_screen.dart';
import 'statistics_screen.dart';

class TaskSelectionScreen extends StatefulWidget {
  @override
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<TaskSelectionScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  //H1.1.1.nhập tên công việc
  void _startStudy() {
    final taskName = _taskController.text.trim();
    if (taskName.isNotEmpty) {
      Navigator.push(
        //H1.1.2. bắt đầu
        context,
        MaterialPageRoute(
          builder:
              (context) => StudyTimerScreen(
                taskName: taskName,
              ), //H1.1.3 chuyển sang màng hình timer
        ),
      );
    }
  }

  void _goToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen()),
    );
  }

  //h1.3.8 mở mằn hình thống kê
  void _goToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chọn công việc học')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Tên công việc',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startStudy,
              child: Text('Bắt đầu học', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 40),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _goToHistory,
                  icon: Icon(Icons.history),
                  label: Text('Lịch sử học'),
                ),
                ElevatedButton.icon(
                  onPressed: _goToStatistics,
                  icon: Icon(Icons.bar_chart),
                  label: Text('Thống kê'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
