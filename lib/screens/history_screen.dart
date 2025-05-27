import 'package:flutter/material.dart';
import 'study_storage.dart';
import 'study_session.dart';

//theo dõi dựa trên dữ liệu của máy
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<StudySession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await StudyStorage.getSessions();
    setState(() {
      _sessions = sessions.reversed.toList(); // mới nhất lên đầu
    });
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}p ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử học tập'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              await StudyStorage.clearSessions();
              _loadSessions();
            },
            tooltip: 'Xóa lịch sử',
          ),
        ],
      ),
      body:
          _sessions.isEmpty
              ? Center(child: Text('Chưa có lịch sử học'))
              : ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final s = _sessions[index];
                  return ListTile(
                    title: Text(s.taskName),
                    subtitle: Text(
                      '${s.timestamp.toLocal()} - Thời gian: ${_formatDuration(s.durationSeconds)}',
                    ),
                  );
                },
              ),
    );
  }
}
