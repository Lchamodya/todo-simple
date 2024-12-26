part of 'tasks_bloc.dart';

@immutable
sealed class TasksState {}

/// State representing successful fetching of tasks.
final class FetchTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  final bool isSearching;

  FetchTasksSuccess({
    required this.tasks,
    this.isSearching = false,
  });
}

/// State representing successful addition of a task.
final class AddTasksSuccess extends TasksState {}

/// State representing failure to load tasks.
final class LoadTaskFailure extends TasksState {
  final String error;

  LoadTaskFailure({required this.error});
}

/// State representing failure to add a task.
final class AddTaskFailure extends TasksState {
  final String error;

  AddTaskFailure({required this.error});
}

/// State representing tasks being loaded.
final class TasksLoading extends TasksState {}

/// State representing failure to update a task.
final class UpdateTaskFailure extends TasksState {
  final String error;

  UpdateTaskFailure({required this.error});
}

/// State representing successful update of a task.
final class UpdateTaskSuccess extends TasksState {}
