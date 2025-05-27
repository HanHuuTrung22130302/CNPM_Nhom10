// Import các thư viện cần thiết
import 'package:flutter/foundation.dart';          // Dùng ChangeNotifier để quản lý state
import '../models/task.dart';                      // Import model Task
import '../repositories/task_repository.dart';     // Import repository để thao tác dữ liệu

// Lớp TaskProvider giúp quản lý danh sách công việc (tasks) và thông báo khi có thay đổi
class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository; // Repository để thao tác lưu trữ/đọc dữ liệu task
  List<Task> _tasks = [];               // Danh sách công việc hiện có
  bool _isLoading = false;             // Biến trạng thái để hiển thị loading
  String? _error;

  // Constructor nhận vào một instance của TaskRepository
  TaskProvider(this._taskRepository) {
    debugPrint('TaskProvider initialized');
    loadTasks();
  }

  // Getter để lấy danh sách task
  List<Task> get tasks => _tasks;

  // Getter để biết có đang loading dữ liệu không
  bool get isLoading => _isLoading;

  String? get error => _error;

  // Hàm tải toàn bộ task từ repository
  Future<void> loadTasks() async {
    debugPrint('Loading tasks...');
    _isLoading = true;      // Bắt đầu loading
    _error = null;
    notifyListeners();      // Cập nhật UI

    try {
      _tasks = await _taskRepository.getAllTasks(); // Lấy dữ liệu từ repository
      debugPrint('Loaded ${_tasks.length} tasks');
    } catch (e) {
      debugPrint('Error loading tasks: $e'); // In lỗi nếu xảy ra
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;   // Kết thúc loading
      notifyListeners();    // Cập nhật UI
    }
  }

  // Hàm thêm một task mới
  Future<void> addTask(Task task) async {
    debugPrint('Adding task: ${task.title}');
    _error = null;
    notifyListeners();

    try {
      await _taskRepository.addTask(task);  // Thêm task vào repository
      debugPrint('Task added successfully');
      await loadTasks();                    // Tải lại danh sách
    } catch (e) {
      debugPrint('Error adding task: $e');  // In lỗi nếu xảy ra
      _error = 'Failed to add task: $e';
      notifyListeners();
    }
  }

  // Hàm cập nhật task
  Future<void> updateTask(Task task) async {
    debugPrint('Updating task: ${task.title}');
    _error = null;
    notifyListeners();

    try {
      await _taskRepository.updateTask(task); // Cập nhật task trong repository
      debugPrint('Task updated successfully');
      await loadTasks();                      // Tải lại danh sách
    } catch (e) {
      debugPrint('Error updating task: $e');
      _error = 'Failed to update task: $e';
      notifyListeners();
    }
  }

  // Hàm xoá task theo id
  Future<void> deleteTask(String id) async {
    debugPrint('Deleting task with id: $id');
    _error = null;
    notifyListeners();

    try {
      await _taskRepository.deleteTask(id); // Xoá task trong repository
      debugPrint('Task deleted successfully');
      await loadTasks();                   // Tải lại danh sách
    } catch (e) {
      debugPrint('Error deleting task: $e');
      _error = 'Failed to delete task: $e';
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    debugPrint('Toggling task completion for id: $id');
    final task = _tasks.firstWhere((t) => t.id == id);
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
    await updateTask(updatedTask);
  }



  void clearError() {
    _error = null;
    notifyListeners();
  }
}
