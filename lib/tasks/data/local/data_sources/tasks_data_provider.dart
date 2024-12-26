import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_simple/tasks/data/local/model/task_model.dart';
import 'package:todo_simple/utils/exception_handler.dart';
import '../../../../utils/constants.dart';

class TaskDataProvider {
  List<TaskModel> tasks = [];
  final SharedPreferences? prefs;

  TaskDataProvider(this.prefs);

  /// Fetch all tasks from SharedPreferences and sort by completion status.
  Future<List<TaskModel>> getTasks() async {
    try {
      final savedTasks = prefs?.getStringList(Constants.taskKey);
      if (savedTasks != null) {
        tasks = savedTasks
            .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
            .toList();
        _sortByCompletion();
      }
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Sort tasks based on the provided sort option.
  /// Options:
  /// 0 - By date
  /// 1 - Completed tasks first
  /// 2 - Pending tasks first
  Future<List<TaskModel>> sortTasks(int sortOption) async {
    try {
      switch (sortOption) {
        case 0: // Sort by date
          tasks.sort((a, b) => (a.date ?? DateTime.now()).compareTo(b.date ?? DateTime.now()));
          break;
        case 1: // Completed tasks first
          tasks.sort((a, b) => a.completed ? -1 : 1);
          break;
        case 2: // Pending tasks first
          tasks.sort((a, b) => a.completed ? 1 : -1);
          break;
        default:
          throw Exception('Invalid sort option');
      }
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Add a new task to the task list and save it to SharedPreferences.
  Future<void> createTask(TaskModel taskModel) async {
    try {
      tasks.add(taskModel);
      await _saveTasksToPrefs();
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Update an existing task in the task list and save the changes.
  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    try {
      final index = tasks.indexWhere((task) => task.id == taskModel.id);
      if (index == -1) throw Exception('Task not found');
      tasks[index] = taskModel;
      _sortByCompletion();
      await _saveTasksToPrefs();
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Delete a task from the task list and update SharedPreferences.
  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    try {
      tasks.removeWhere((task) => task.id == taskModel.id);
      await _saveTasksToPrefs();
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Search for tasks by keywords in the title or description.
  Future<List<TaskModel>> searchTasks(String keywords) async {
    try {
      final searchText = keywords.toLowerCase();
      return tasks.where((task) {
        return task.title.toLowerCase().contains(searchText) ||
            task.description.toLowerCase().contains(searchText);
      }).toList();
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Sort tasks by their completion status (pending tasks first).
  void _sortByCompletion() {
    tasks.sort((a, b) {
      if (a.completed == b.completed) return 0;
      return a.completed ? 1 : -1;
    });
  }

  /// Save the current list of tasks to SharedPreferences.
  Future<void> _saveTasksToPrefs() async {
    try {
      final taskJsonList = tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs?.setStringList(Constants.taskKey, taskJsonList);
    } catch (e) {
      throw Exception(handleException(e));
    }
  }
}
