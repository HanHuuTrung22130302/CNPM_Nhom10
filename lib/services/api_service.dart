import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule.dart';
import 'dart:developer' as developer;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080'; // URL cho emulator

  Future<List<Schedule>> fetchSchedules(String date) async {
    try {
      developer.log('Gọi API: $baseUrl/schedule?date=$date');
      final response = await http.get(Uri.parse('$baseUrl/schedule?date=$date'));
      developer.log('Trả về API - Status: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Schedule.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải lịch: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Lỗi API: $e');
      throw Exception('Lỗi kết nối API: $e');
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/schedule/${schedule.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(schedule.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Lỗi cập nhật lịch: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Lỗi cập nhật API: $e');
      throw Exception('Lỗi cập nhật lịch: $e');
    }
  }
}