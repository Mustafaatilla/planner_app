import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String title;
  String description;
  DateTime? date;
  bool isCompleted;
  String category;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.date,
    this.isCompleted = false,
    this.category = 'General',
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isCompleted: json['isCompleted'] ?? false,
      category: json['category'] ?? 'General',
    );
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    String? category,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}
