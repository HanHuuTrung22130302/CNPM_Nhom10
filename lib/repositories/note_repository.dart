import "package:hoangvu/models/note.dart";
import 'package:flutter/foundation.dart';
import '../dao/note_database.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<List<Note>> getNotesByTag(String tag);
}

class NoteRepositoryImpl implements NoteRepository {
  final NoteDatabase _database = NoteDatabase.instance;

  @override
  Future<List<Note>> getAllNotes() async {
    debugPrint('Getting all notes...');
    final List<Map<String, dynamic>> maps = await _database.getAllNotes();
    debugPrint('Found ${maps.length} notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  @override
  Future<Note?> getNoteById(String id) async {
    debugPrint('Getting note with id: $id');
    final Map<String, dynamic>? map = await _database.getNoteById(id);
    if (map == null) {
      debugPrint('Note not found');
      return null;
    }
    debugPrint('Note found');
    return Note.fromMap(map);
  }

  @override
  Future<void> addNote(Note note) async {
    debugPrint('Adding new note: ${note.title}');
    await _database.insertNote(note.toMap());
    debugPrint('Note added successfully');
  }

  @override
  Future<void> updateNote(Note note) async {
    debugPrint('Updating note: ${note.title}');
    await _database.updateNote(note.toMap(), note.id);
    debugPrint('Note updated successfully');
  }

  @override
  Future<void> deleteNote(String id) async {
    debugPrint('Deleting note with id: $id');
    await _database.deleteNote(id);
    debugPrint('Note deleted successfully');
  }

  @override
  Future<List<Note>> getNotesByTag(String tag) async {
    debugPrint('Getting notes with tag: $tag');
    final List<Map<String, dynamic>> maps = await _database.getNotesByTag(tag);
    debugPrint('Found ${maps.length} notes with tag: $tag');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }
} 