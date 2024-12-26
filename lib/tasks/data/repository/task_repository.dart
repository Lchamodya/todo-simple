import 'package:todo_simple/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:todo_simple/tasks/data/local/model/task_model.dart';

/// A repository class that acts as a mediator between the Bloc and the data provider.
class TaskRepository {
  final TaskDataProvider taskDataProvider;

  /// Constructor to initialize the `TaskDataProvider`.
  TaskRepository({required this.taskDataProvider});

  /// Fetches all tasks from the data provider.
  Future<List<TaskModel>> getTasks() async {
    return await taskDataProvider.getTasks();
  }

  /// Creates a new task using the data provider.
  Future<void> createNewTask(TaskModel taskModel) async {
    await taskDataProvider.createTask(taskModel);
  }

  /// Updates an existing task using the data provider.
  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    return await taskDataProvider.updateTask(taskModel);
  }

  /// Deletes an existing task using the data provider.
  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    return await taskDataProvider.deleteTask(taskModel);
  }

  /// Sorts tasks based on the provided sorting option.
  /// Sorting options can be defined and handled in the data provider.
  Future<List<TaskModel>> sortTasks(int sortOption) async {
    return await taskDataProvider.sortTasks(sortOption);
  }

  /// Searches for tasks based on a search query.
  Future<List<TaskModel>> searchTasks(String search) async {
    return await taskDataProvider.searchTasks(search);
  }
}
