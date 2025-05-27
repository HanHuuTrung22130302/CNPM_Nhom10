import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;
  static const String tableName = 'tasks';

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    debugPrint('Initializing task database...');
    _database = await _initDB('tasks.db');
    debugPrint('Task database initialized successfully');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('Task database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) {
        debugPrint('Task database opened successfully');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    debugPrint('Creating task database tables...');
    await db.execute('''
      CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT,
        isCompleted INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        color TEXT DEFAULT 'blue',
        category TEXT DEFAULT 'Uncategorized'
      )
    ''');
    debugPrint('Task database tables created successfully');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading task database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableName ADD COLUMN category TEXT DEFAULT "Uncategorized"');
      await db.execute('ALTER TABLE $tableName ADD COLUMN color TEXT DEFAULT "blue"');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getTaskById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert(
      tableName,
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Map<String, dynamic> task, String id) async {
    final db = await database;
    await db.update(
      tableName,
      task,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByStatus(bool isCompleted) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'isCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0],
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByCategory(String category) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
    debugPrint('Task database closed');
  }
} 