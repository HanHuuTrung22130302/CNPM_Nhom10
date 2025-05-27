// Đây là class đại diện cho một công việc (task) trong ứng dụng quản lý công việc
import 'package:flutter/material.dart';

class Task {
  // Các thuộc tính của task (được khai báo là final vì chúng là immutable - không thay đổi sau khi khởi tạo)
  final String id;              // Mã định danh duy nhất cho mỗi task
  final String title;           // Tiêu đề của task
  final String? description;     // Mô tả chi tiết cho task
  final DateTime? dueDate;       // Hạn hoàn thành (deadline) của task
  final bool isCompleted;       // Trạng thái hoàn thành: true nếu đã hoàn thành
  final int priority;           // Độ ưu tiên của task
  final DateTime createdAt;     // Thời gian tạo task
  final DateTime? updatedAt;     // Thời gian cập nhật task
  final String? color; // Màu sắc của task
  final String category;  // Thêm lại trường category

  // Constructor khởi tạo đối tượng Task với các tham số bắt buộc và mặc định
  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,           // Mặc định là chưa hoàn thành
    this.priority = 0,                  // Mặc định là độ ưu tiên thấp nhất
    required this.createdAt,             // Thời gian tạo task là bắt buộc
    this.updatedAt,                     // Thời gian cập nhật là tùy chọn
    this.color,                         // Màu sắc là tùy chọn
    this.category = 'Uncategorized',  // Giá trị mặc định
  });

  // Hàm copyWith dùng để tạo một bản sao của Task với một số thuộc tính được thay đổi
  // Các thuộc tính không truyền vào sẽ giữ nguyên như bản gốc
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'color': color,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] == 1,
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      color: map['color'],
      category: map['category'] ?? 'Uncategorized',
    );
  }
}
