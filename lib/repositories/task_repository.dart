import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../dao/task_database.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String id);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getTasksByStatus(bool isCompleted);
  Future<List<Task>> getTasksByCategory(String category);
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskDatabase _database = TaskDatabase.instance;

  @override
  Future<List<Task>> getAllTasks() async {
    debugPrint('Getting all tasks...');
    final List<Map<String, dynamic>> maps = await _database.getAllTasks();
    debugPrint('Found ${maps.length} tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  @override
  Future<Task?> getTaskById(String id) async {
    debugPrint('Getting task with id: $id');
    final Map<String, dynamic>? map = await _database.getTaskById(id);
    if (map == null) {
      debugPrint('Task not found');
      return null;
    }
    debugPrint('Task found');
    return Task.fromMap(map);
  }

  @override
  Future<void> addTask(Task task) async {
    debugPrint('Adding new task: ${task.title}');
    await _database.insertTask(task.toMap());
    debugPrint('Task added successfully');
  }

  @override
  Future<void> updateTask(Task task) async {
    debugPrint('Updating task: ${task.title}');
    await _database.updateTask(task.toMap(), task.id);
    debugPrint('Task updated successfully');
  }

  @override
  Future<void> deleteTask(String id) async {
    debugPrint('Deleting task with id: $id');
    await _database.deleteTask(id);
    debugPrint('Task deleted successfully');
  }

  @override
  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    debugPrint('Getting tasks with status: ${isCompleted ? "completed" : "pending"}');
    final List<Map<String, dynamic>> maps = await _database.getTasksByStatus(isCompleted);
    debugPrint('Found ${maps.length} tasks with status: ${isCompleted ? "completed" : "pending"}');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  @override
  Future<List<Task>> getTasksByCategory(String category) async {
    debugPrint('Getting tasks with category: $category');
    final List<Map<String, dynamic>> maps = await _database.getTasksByCategory(category);
    debugPrint('Found ${maps.length} tasks with category: $category');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }
}