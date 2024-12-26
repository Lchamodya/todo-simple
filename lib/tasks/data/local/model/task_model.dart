import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime date; // Task date
  final TimeOfDay time; // Task time
  final bool completed; // Task completion status

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.completed = false, // Default to false if not specified
  });

  /// Convert a TaskModel instance to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(), // ISO 8601 formatted date
    'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', // HH:mm format
    'completed': completed,
  };

  /// Create a TaskModel instance from a JSON-compatible map.
  static TaskModel fromJson(Map<String, dynamic> json) {
    try {
      return TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']), // Parse date
        time: TimeOfDay(
          hour: int.parse(json['time'].split(':')[0]), // Extract hour
          minute: int.parse(json['time'].split(':')[1]), // Extract minute
        ),
        completed: json['completed'] ?? false, // Default to false if missing
      );
    } catch (e) {
      throw FormatException('Error parsing TaskModel from JSON: $e');
    }
  }

  /// CopyWith method to create a modified copy of the TaskModel.
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, date: $date, time: $time, completed: $completed)';
  }
}
