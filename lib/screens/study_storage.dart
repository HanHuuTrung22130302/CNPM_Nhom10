import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'study_session.dart';

class StudyStorage {
  static const String _key = 'study_sessions';

  // Lấy danh sách
  //h1.3.8 lấy dữ liệu
  static Future<List<StudySession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => StudySession.fromJson(jsonDecode(e))).toList();
  }

  // Lưu phiên học mới
  //h1.1.5 lưu studysession
  static Future<void> saveSession(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(session.toJson()));
    await prefs.setStringList(_key, list);
  }

  // Xóa toàn bộ lịch sử
  static Future<void> clearSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
