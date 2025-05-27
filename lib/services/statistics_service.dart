import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:study_timer/models/study_stat.dart';

class StatisticsService {
  static const String baseUrl = 'http://10.0.3.2:8080/api/statistics';

  static Future<List<StudyStat>> fetchStats(
    DateTime start,
    DateTime end,
  ) async {
    final formattedStart = DateFormat('yyyy-MM-dd').format(start);
    final formattedEnd = DateFormat('yyyy-MM-dd').format(end);
    // I1.7. Hàm (fetchStats) tạo request resful api (url='http...') với tham số ngày bắt đầu và ngày kết thúc.
    final url = Uri.parse(
      'http://10.0.3.2:8080/api/statistics?startDate=$formattedStart&endDate=$formattedEnd',
    );

    // I1.8. Hệ thống thực hiện http GET với api (url trên).
    final response = await http.get(url);


    if (response.statusCode == 200) {
      //I1.12. Hệ thống giải mã dữ liệu json nhận từ CSDL (StudyStatRepository).
      final List<dynamic> data = jsonDecode(response.body);
      //I1.13. Hệ thống ánh xạ về danh sách đối tượng (List<StudyStat>).
      return data.map((json) => StudyStat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }
}
