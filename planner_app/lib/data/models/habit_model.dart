import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  String title;
  Set<DateTime> completedDates;
  Color color;
  DateTime startDate;
  DateTime? endDate; // null means permanent

  Habit({
    String? id,
    required this.title,
    Set<DateTime>? completedDates,
    this.color = Colors.blue,
    DateTime? startDate,
    this.endDate,
  })  : id = id ?? const Uuid().v4(),
        completedDates = completedDates ?? {},
        startDate = startDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
      'color': color.value,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d))
              .toSet() ??
          {},
      color: Color(json['color'] ?? Colors.blue.value),
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  bool isActiveOn(DateTime date) {
    // Normalize dates to remove time components for comparison
    final d = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    
    if (d.isBefore(start)) return false;
    
    if (endDate != null) {
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (d.isAfter(end)) return false;
    }
    
    return true;
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  void toggleCompletion(DateTime date) {
    if (isCompletedOn(date)) {
      completedDates.removeWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
    } else {
      completedDates.add(date);
    }
  }
}
