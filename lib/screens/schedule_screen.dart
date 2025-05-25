import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';
import 'dart:developer' as developer;
import 'detail_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String? _selectedDate;
  List<Schedule> _schedules = [];
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now()); // Lấy ngày hiện tại
    _fetchSchedules(_selectedDate!);
  }

  void _fetchSchedules(String date) async {
    try {
      developer.log('Gọi _fetchSchedules cho ngày: $date');
      // Lấy dữ liệu từ API (MySQL)
      final schedulesFromApi = await _apiService.fetchSchedules(date);
      developer.log('Dữ liệu từ API: $schedulesFromApi');
      if (schedulesFromApi.isNotEmpty) {
        await _dbHelper.insertSchedules(schedulesFromApi); // Lưu dữ liệu API vào SQLite
      }

      // Lấy dữ liệu từ SQLite
      final schedulesFromDb = await _dbHelper.getSchedulesByDate(date);
      developer.log('Dữ liệu từ SQLite: $schedulesFromDb');

      // Kết hợp dữ liệu: ưu tiên API, bổ sung dữ liệu cục bộ không trùng
      Set<String> apiIds = schedulesFromApi.map((s) => s.id).toSet();
      List<Schedule> combinedSchedules = [
        ...schedulesFromApi,
        ...schedulesFromDb.where((s) => !apiIds.contains(s.id)),
      ];

      setState(() {
        _schedules = combinedSchedules;
        developer.log('Dữ liệu kết hợp _schedules: $_schedules');
      });

      if (_schedules.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có dữ liệu cho ngày này')),
        );
      }
    } catch (e) {
      developer.log('Lỗi _fetchSchedules: $e');
      final schedulesFromDb = await _dbHelper.getSchedulesByDate(date);
      setState(() {
        _schedules = schedulesFromDb;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi API: $e. Đã lấy dữ liệu cục bộ.')),
      );
    }
  }

  List<Widget> _buildDayButtons() {
    List<Widget> buttons = [];
    DateTime firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday;

    for (int i = 1; i < firstWeekday; i++) {
      buttons.add(const SizedBox(width: 40, height: 40));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateFormat('dd-MM-yyyy').format(
                  DateTime(_selectedYear, _selectedMonth, day),
                );
              });
              _fetchSchedules(_selectedDate!);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(40, 40),
            ),
            child: Text('$day'),
          ),
        ),
      );
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời khóa biểu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: _selectedMonth,
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text('Tháng ${index + 1}'),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                          _selectedDate = null;
                          _schedules = [];
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: _selectedYear,
                      items: List.generate(10, (index) {
                        int year = DateTime.now().year + index - 5;
                        return DropdownMenuItem(
                          value: year,
                          child: Text('$year'),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                          _selectedDate = null;
                          _schedules = [];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Th 2'),
                    Text('Th 3'),
                    Text('Th 4'),
                    Text('Th 5'),
                    Text('Th 6'),
                    Text('Th 7'),
                    Text('CN'),
                  ],
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 7,
                    children: _buildDayButtons(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _schedules.isEmpty
                ? const Center(child: Text('Hôm nay không có môn học nào'))
                : ListView.builder(
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      schedule.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${schedule.timeBegin} - ${schedule.timeEnd}\n${schedule.content}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(schedule: schedule),
                        ),
                      ).then((value) {
                        if (_selectedDate != null) {
                          _fetchSchedules(_selectedDate!);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}