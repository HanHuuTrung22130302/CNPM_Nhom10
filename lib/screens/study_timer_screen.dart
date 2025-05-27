import 'dart:async';
import 'package:flutter/material.dart';
import 'study_session.dart';
import 'study_storage.dart';

enum PomodoroState { study, shortBreak, longBreak }

class StudyTimerScreen extends StatefulWidget {
  final String taskName;

  const StudyTimerScreen({required this.taskName, Key? key}) : super(key: key);
  //H1.1.4 đếm ngược 25 Phút
  @override
  _StudyTimerScreenState createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 25;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _isStarted = false;
  bool _isFinished = false;

  // Pomodoro variables
  PomodoroState _pomodoroState = PomodoroState.study;
  int _cyclesCompleted = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _selectedMinutes * 60;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startOrResumeTimer() {
    if (!_isStarted) {
      _remainingSeconds = _selectedMinutes * 60;
      _animationController.duration = Duration(seconds: _remainingSeconds);
      _animationController.forward(from: 0);
      _isStarted = true;
    } else {
      _animationController.forward();
    }

    _isRunning = true;
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        await _onTimerFinished();
      }
    });

    setState(() {});
  }

  Future<void> _onTimerFinished() async {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isFinished = true;
    });

    // Lưu lịch sử học (chỉ khi study)
    if (_pomodoroState == PomodoroState.study) {
      final session = StudySession(
        taskName: widget.taskName,
        durationSeconds: _selectedMinutes * 60,
        timestamp: DateTime.now(),
      );
      await StudyStorage.saveSession(session);
      _cyclesCompleted++;
    }

    // Chuyển sang trạng thái kế tiếp
    if (_pomodoroState == PomodoroState.study) {
      //h1.1.7 nghỉ dài 15p
      if (_cyclesCompleted % 4 == 0) {
        _pomodoroState = PomodoroState.longBreak;
        _selectedMinutes = 15;
      } else {
        //h1.1.6 nghỉ ngắn 5p
        _pomodoroState = PomodoroState.shortBreak;
        _selectedMinutes = 5;
      }
    } else {
      _pomodoroState = PomodoroState.study;
      _selectedMinutes = 25;
    }

    _remainingSeconds = _selectedMinutes * 60;
    _animationController.duration = Duration(seconds: _remainingSeconds);
    _animationController.reset();

    setState(() {});
  }

  void _pauseTimer() {
    _timer?.cancel();
    _animationController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _resetTimer() async {
    _timer?.cancel();
    _animationController.reset();

    if (_isStarted && !_isFinished && _pomodoroState == PomodoroState.study) {
      final actualDuration = _selectedMinutes * 60 - _remainingSeconds;
      if (actualDuration > 0) {
        final session = StudySession(
          taskName: widget.taskName,
          durationSeconds: actualDuration,
          timestamp: DateTime.now(),
        );
        await StudyStorage.saveSession(session);
        _cyclesCompleted++;
      }
    }

    setState(() {
      _remainingSeconds = _selectedMinutes * 60;
      _isRunning = false;
      _isStarted = false;
      _isFinished = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  String _pomodoroStateText() {
    switch (_pomodoroState) {
      case PomodoroState.study:
        return "Học tập";
      case PomodoroState.shortBreak:
        return "Nghỉ ngắn";
      case PomodoroState.longBreak:
        return "Nghỉ dài";
    }
  }

  Color _pomodoroStateColor() {
    switch (_pomodoroState) {
      case PomodoroState.study:
        return Colors.green;
      case PomodoroState.shortBreak:
        return Colors.orange;
      case PomodoroState.longBreak:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _animationController.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        backgroundColor: _pomodoroStateColor(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "📝 Công việc: ${widget.taskName}",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(
              "Trạng thái: ${_pomodoroStateText()}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _pomodoroStateColor(),
              ),
            ),
            SizedBox(height: 20),

            // Đồng hồ vòng tròn
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    color: _pomodoroStateColor(),
                    backgroundColor: Colors.grey[300],
                  ),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            if (!_isStarted) ...[
              ElevatedButton(
                onPressed: _startOrResumeTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pomodoroStateColor(),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Bắt đầu', style: TextStyle(fontSize: 20)),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? _pauseTimer : _startOrResumeTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pomodoroStateColor(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(_isRunning ? 'Tạm dừng' : 'Tiếp tục'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Đặt lại'),
                  ),
                ],
              ),
            ],
            SizedBox(height: 40),
            Text(
              "Số chu kỳ đã hoàn thành: $_cyclesCompleted",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
