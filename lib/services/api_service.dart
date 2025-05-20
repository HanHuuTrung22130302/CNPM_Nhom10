import 'dart:convert';
import 'package:http/http.dart' as http;

class StudyStat {
  final String date;
  final double studyHours;

  StudyStat({required this.date, required this.studyHours});

  factory StudyStat.fromJson(Map<String, dynamic> json) {
    return StudyStat(
      date: json['date'],
      studyHours: json['studyHours'].toDouble(),
    );
  }
}

class StudyStatResponse {
  final List<StudyStat> stats;
  final Map<String, dynamic> kpi;

  StudyStatResponse({required this.stats, required this.kpi});

  factory StudyStatResponse.fromJson(Map<String, dynamic> json) {
    return StudyStatResponse(
      stats: (json['stats'] as List).map((e) => StudyStat.fromJson(e)).toList(),
      kpi: json['kpi'],
    );
  }
}

class ApiService {
  final baseUrl = 'http://localhost:8080/api';

  Future<StudyStatResponse> getStats(String range) async {
    // I1.2 / I1.10. Gửi yêu cầu GET đến backend theo khoảng thời gian đã chọn
    final response = await http.get(Uri.parse("$baseUrl/stats?range=$range"));
    if (response.statusCode == 200) {
      // I1.7. Nhận JSON từ server và chuyển sang StudyStatResponse
      return StudyStatResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Lỗi lấy dữ liệu thống kê');
    }
  }
}
