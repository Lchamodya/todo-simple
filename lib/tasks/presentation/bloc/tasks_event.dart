part of 'tasks_bloc.dart';

@immutable
sealed class TasksEvent {}

/// Event to add a new task.
final class AddNewTaskEvent extends TasksEvent {
  final TaskModel taskModel;

  AddNewTaskEvent({required this.taskModel});
}

/// Event to fetch all tasks.
final class FetchTaskEvent extends TasksEvent {}

/// Event to sort tasks based on a selected option.
final class SortTaskEvent extends TasksEvent {
  final int sortOption;

  SortTaskEvent({required this.sortOption});
}

/// Event to update an existing task.
final class UpdateTaskEvent extends TasksEvent {
  final TaskModel taskModel;

  UpdateTaskEvent({required this.taskModel});
}

/// Event to delete an existing task.
final class DeleteTaskEvent extends TasksEvent {
  final TaskModel taskModel;

  DeleteTaskEvent({required this.taskModel});
}

/// Event to search for tasks based on keywords.
final class SearchTaskEvent extends TasksEvent {
  final String keywords;

  SearchTaskEvent({required this.keywords});
}
