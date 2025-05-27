// Lớp Note đại diện cho một ghi chú trong ứng dụng ghi chú
class Note {
  // Các tag mặc định
  static const List<String> defaultTags = [
    'Important',
    'Urgent',
    'Meeting',
    'Project',
    'Personal',
    'Work',
    'Study',
    'Ideas',
    'To-Do',
    'Reference',
  ];

  final String id;              // Mã định danh duy nhất cho ghi chú
  final String title;           // Tiêu đề ghi chú
  final String content;         // Nội dung chi tiết của ghi chú
  final DateTime createdAt;     // Ngày giờ tạo ghi chú
  final DateTime? updatedAt;    // Ngày giờ cập nhật gần nhất (có thể null nếu chưa từng cập nhật)
  final List<String> tags;      // Danh sách các thẻ (tags) gắn với ghi chú
  final String category;        // Phân loại ghi chú
  final bool isFavorite;        // Đánh dấu ghi chú yêu thích
  final String? color;          // Màu sắc của ghi chú

  // Constructor để khởi tạo đối tượng Note
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    List<String>? tags,        // Cho phép truyền vào tags tùy chọn
    this.category = 'Uncategorized', // Mặc định là Uncategorized
    this.isFavorite = false,   // Mặc định là không yêu thích
    this.color,                // Màu sắc là tùy chọn
  }) : tags = tags ?? [];      // Nếu không có tags thì dùng list rỗng

  // Thêm tag mới vào note
  Note addTag(String tag) {
    if (!tags.contains(tag)) {
      return copyWith(tags: [...tags, tag]);
    }
    return this;
  }

  // Xóa tag khỏi note
  Note removeTag(String tag) {
    return copyWith(tags: tags.where((t) => t != tag).toList());
  }

  // Kiểm tra xem note có chứa tag không
  bool hasTag(String tag) {
    return tags.contains(tag);
  }

  // Hàm copyWith để tạo một bản sao mới từ Note cũ
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? category,
    bool? isFavorite,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
    );
  }

  // Chuyển đổi Note thành Map để lưu vào database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags.join(','),  // Chuyển List<String> thành String
      'category': category,
      'isFavorite': isFavorite ? 1 : 0,
      'color': color,
    };
  }

  // Tạo Note từ Map (từ database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      tags: map['tags']?.split(',') ?? [],  // Chuyển String thành List<String>
      category: map['category'] ?? 'Uncategorized',
      isFavorite: map['isFavorite'] == 1,
      color: map['color'],
    );
  }
}
