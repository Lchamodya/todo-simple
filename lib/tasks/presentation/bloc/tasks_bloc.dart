import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/model/task_model.dart';
import '../../data/repository/task_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository taskRepository;

  TasksBloc(this.taskRepository) : super(FetchTasksSuccess(tasks: const [])) {
    on<AddNewTaskEvent>(_addNewTask);
    on<FetchTaskEvent>(_fetchTasks);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<SortTaskEvent>(_sortTasks);
    on<SearchTaskEvent>(_searchTasks);
  }

  /// Handles adding a new task
  Future<void> _addNewTask(
      AddNewTaskEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      // Validate the task fields
      if (event.taskModel.title.trim().isEmpty) {
        throw Exception('Task title cannot be blank');
      }
      if (event.taskModel.description.trim().isEmpty) {
        throw Exception('Task description cannot be blank');
      }
      if (event.taskModel.date == null) {
        throw Exception('Task date cannot be null');
      }
      if (event.taskModel.time == null) {
        throw Exception('Task time cannot be null');
      }

      // Add the new task
      await taskRepository.createNewTask(event.taskModel);
      emit(AddTasksSuccess());

      // Fetch updated task list
      final tasks = await taskRepository.getTasks();
      emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(AddTaskFailure(error: exception.toString()));
    }
  }

  /// Handles fetching tasks
  Future<void> _fetchTasks(FetchTaskEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }

  /// Handles updating an existing task
  Future<void> _updateTask(
      UpdateTaskEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      // Validate the task fields
      if (event.taskModel.title.trim().isEmpty) {
        throw Exception('Task title cannot be blank');
      }
      if (event.taskModel.description.trim().isEmpty) {
        throw Exception('Task description cannot be blank');
      }
      if (event.taskModel.date == null) {
        throw Exception('Task date cannot be null');
      }
      if (event.taskModel.time == null) {
        throw Exception('Task time cannot be null');
      }

      // Update the task
      final tasks = await taskRepository.updateTask(event.taskModel);
      emit(UpdateTaskSuccess());

      // Fetch updated task list
      emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(UpdateTaskFailure(error: exception.toString()));
    }
  }

  /// Handles deleting a task
  Future<void> _deleteTask(
      DeleteTaskEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await taskRepository.deleteTask(event.taskModel);
      emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }

  /// Handles sorting tasks
  Future<void> _sortTasks(SortTaskEvent event, Emitter<TasksState> emit) async {
    try {
      final tasks = await taskRepository.sortTasks(event.sortOption);
      emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }

  /// Handles searching tasks
  Future<void> _searchTasks(
      SearchTaskEvent event, Emitter<TasksState> emit) async {
    try {
      final tasks = await taskRepository.searchTasks(event.keywords);
      emit(FetchTasksSuccess(tasks: tasks, isSearching: true));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }
}
