import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:study_timer/models/study_stat.dart';

class StatisticsService {
  static const String baseUrl = 'https://cnpm-nhom10-study-timer-backend.onrender.com/api/statistics';

  static Future<List<StudyStat>> fetchStats(
    DateTime start,
    DateTime end,
  ) async {
    final formattedStart = DateFormat('yyyy-MM-dd').format(start);
    final formattedEnd = DateFormat('yyyy-MM-dd').format(end);
    final url = Uri.parse(
      'https://cnpm-nhom10-study-timer-backend.onrender.com/api/statistics?startDate=$formattedStart&endDate=$formattedEnd',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StudyStat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }
}
