import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/schedule.dart';
import 'dart:developer' as developer;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('schedules.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE schedules (
            id TEXT PRIMARY KEY,
            date TEXT,
            name TEXT,
            content TEXT,
            timeBegin TEXT,
            timeEnd TEXT
          )
        ''');

        await _insertDummyData(db);
      },
    );
  }

  Future<void> _insertDummyData(Database db) async {
    final dummySchedules = [
      Schedule(
        id: '1',
        date: '25-05-2025',
        name: 'Lập trình di động',
        content: 'Học Flutter và Dart',
        timeBegin: '08:00',
        timeEnd: '10:00',
      ),
      Schedule(
        id: '2',
        date: '25-05-2025',
        name: 'Cơ sở dữ liệu',
        content: 'Ôn tập SQL',
        timeBegin: '13:00',
        timeEnd: '15:00',
      ),
      Schedule(
        id: '3',
        date: '26-05-2025',
        name: 'Mạng máy tính',
        content: 'Học giao thức TCP/IP',
        timeBegin: '09:00',
        timeEnd: '11:00',
      ),
      Schedule(
        id: '4',
        date: '27-05-2025',
        name: 'Thiết kế giao diện,vip pro max',
        content: 'Làm bài tập Figma',
        timeBegin: '14:00',
        timeEnd: '16:00',
      ),
    ];

    for (var schedule in dummySchedules) {
      await db.insert('schedules', schedule.toJson());
      developer.log('Đã thêm dữ liệu ảo: ${schedule.toJson()}');
    }
  }

  Future<void> insertSchedules(List<Schedule> schedules) async {
    final db = await instance.database;
    for (var schedule in schedules) {
      await db.insert(
        'schedules',
        schedule.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Schedule>> getSchedulesByDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(
      'schedules',
      where: 'date = ?',
      whereArgs: [date],
    );
    developer.log('Kết quả truy vấn SQLite cho $date: $maps');
    return maps.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final db = await instance.database;
    await db.update(
      'schedules',
      schedule.toJson(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}