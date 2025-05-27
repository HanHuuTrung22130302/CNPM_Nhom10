import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;
  static const String tableName = 'notes';

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    debugPrint('Initializing note database...');
    _database = await _initDB('notes.db');
    debugPrint('Note database initialized successfully');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('Note database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) {
        debugPrint('Note database opened successfully');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    debugPrint('Creating note database tables...');
    await db.execute('''
      CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        tags TEXT,
        category TEXT DEFAULT 'Uncategorized',
        isFavorite INTEGER DEFAULT 0,
        color TEXT DEFAULT 'blue'
      )
    ''');
    debugPrint('Note database tables created successfully');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading note database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableName ADD COLUMN category TEXT DEFAULT "Uncategorized"');
      await db.execute('ALTER TABLE $tableName ADD COLUMN isFavorite INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE $tableName ADD COLUMN color TEXT DEFAULT "blue"');
    }
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getNoteById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert(
      tableName,
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Map<String, dynamic> note, String id) async {
    final db = await database;
    await db.update(
      tableName,
      note,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getNotesByTag(String tag) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'tags LIKE ?',
      whereArgs: ['%$tag%'],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
    debugPrint('Note database closed');
  }
} 