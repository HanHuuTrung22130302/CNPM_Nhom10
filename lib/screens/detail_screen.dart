import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class DetailScreen extends StatefulWidget {
  final Schedule schedule;

  const DetailScreen({super.key, required this.schedule});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contentController;
  late TextEditingController _timeBeginController;
  late TextEditingController _timeEndController;
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.schedule.name);
    _contentController = TextEditingController(text: widget.schedule.content);
    _timeBeginController = TextEditingController(text: widget.schedule.timeBegin);
    _timeEndController = TextEditingController(text: widget.schedule.timeEnd);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    _timeBeginController.dispose();
    _timeEndController.dispose();
    super.dispose();
  }

  void _updateSchedule() async {
    final updatedSchedule = Schedule(
      id: widget.schedule.id,
      date: widget.schedule.date,
      name: _nameController.text,
      content: _contentController.text,
      timeBegin: _timeBeginController.text,
      timeEnd: _timeEndController.text,
    );
    try {
      // Gọi API để cập nhật
      await _apiService.updateSchedule(updatedSchedule);
      // Cập nhật vào SQLite
      await _dbHelper.updateSchedule(updatedSchedule);
      Navigator.pop(context);
    } catch (e) {
      // Nếu API lỗi, vẫn cập nhật SQLite
      await _dbHelper.updateSchedule(updatedSchedule);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi API: $e. Đã lưu cục bộ.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết môn học'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày: ${widget.schedule.date}'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên môn học'),
            ),
            TextField(
              controller: _timeBeginController,
              decoration: const InputDecoration(labelText: 'Thời gian bắt đầu'),
            ),
            TextField(
              controller: _timeEndController,
              decoration: const InputDecoration(labelText: 'Thời gian kết thúc'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Nội dung'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateSchedule,
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}