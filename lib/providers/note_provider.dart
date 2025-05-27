// Import các thư viện cần thiết
import 'package:flutter/foundation.dart';          // Dùng để sử dụng ChangeNotifier
import '../models/note.dart';                      // Import model Note
import '../repositories/note_repository.dart';     // Import repository để làm việc với dữ liệu

// NoteProvider là lớp quản lý trạng thái ghi chú, sử dụng ChangeNotifier để thông báo thay đổi
class NoteProvider with ChangeNotifier {
  final NoteRepository _noteRepository; // Đối tượng xử lý lưu trữ/đọc dữ liệu (thường là từ DB hoặc API)
  List<Note> _notes = [];              // Danh sách ghi chú hiện có
  bool _isLoading = false;             // Biến trạng thái để hiển thị loading trong UI
  String? _error;

  // Constructor nhận vào NoteRepository
  NoteProvider(this._noteRepository) {
    debugPrint('NoteProvider initialized');
    // Tự động load notes khi khởi tạo provider
    loadNotes();
  }

  // Getter để lấy danh sách ghi chú
  List<Note> get notes => _notes;

  // Getter để kiểm tra trạng thái loading
  bool get isLoading => _isLoading;

  String? get error => _error;

  // Hàm load tất cả ghi chú từ repository
  Future<void> loadNotes() async {
    debugPrint('Loading notes...'); // Debug print
    _isLoading = true;       // Bắt đầu loading
    _error = null;
    notifyListeners();       // Cập nhật giao diện (UI sẽ rebuild nếu cần)

    try {
      _notes = await _noteRepository.getAllNotes();  // Lấy danh sách ghi chú từ repository
      debugPrint('Loaded ${_notes.length} notes'); // Debug print
    } catch (e) {
      debugPrint('Error loading notes: $e');         // Ghi log nếu có lỗi
      _error = 'Failed to load notes: $e';
    } finally {
      _isLoading = false;    // Kết thúc loading
      notifyListeners();     // Thông báo cho UI cập nhật
    }
  }

  // Hàm thêm ghi chú mới
  Future<void> addNote(Note note) async {
    debugPrint('Adding note: ${note.title}'); // Debug print
    _error = null;
    notifyListeners();

    try {
      await _noteRepository.addNote(note);  // Thêm ghi chú vào repository
      debugPrint('Note added successfully'); // Debug print
      await loadNotes();                    // Tải lại danh sách ghi chú
    } catch (e) {
      debugPrint('Error adding note: $e');  // Ghi log lỗi nếu có
      _error = 'Failed to add note: $e';
      notifyListeners();
    }
  }

  // Hàm cập nhật ghi chú
  Future<void> updateNote(Note note) async {
    debugPrint('Updating note: ${note.title}'); // Debug print
    _error = null;
    notifyListeners();

    try {
      await _noteRepository.updateNote(note);  // Cập nhật ghi chú trong repository
      debugPrint('Note updated successfully'); // Debug print
      await loadNotes();                       // Tải lại danh sách
    } catch (e) {
      debugPrint('Error updating note: $e');
      _error = 'Failed to update note: $e';
      notifyListeners();
    }
  }

  // Hàm xóa ghi chú theo id
  Future<void> deleteNote(String id) async {
    debugPrint('Deleting note with id: $id'); // Debug print
    _error = null;
    notifyListeners();

    try {
      await _noteRepository.deleteNote(id);  // Xóa ghi chú từ repository
      debugPrint('Note deleted successfully'); // Debug print
      await loadNotes();                     // Tải lại danh sách
    } catch (e) {
      debugPrint('Error deleting note: $e');
      _error = 'Failed to delete note: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
