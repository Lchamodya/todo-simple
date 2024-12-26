import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_simple/components/build_text_field2.dart';
import 'package:todo_simple/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:todo_simple/tasks/presentation/widget/task_item_view.dart';
import 'package:todo_simple/utils/color_palette.dart';
import '../../../utils/font_sizes.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All';

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildFilters(context),
              const SizedBox(height: 10),
              _buildTaskList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/createNewTask');
        },
      ),
    );
  }

  /// Builds the header with "Hello" text, search bar, and notification icon.
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Hello Lochini',
            style: TextStyle(
              color: kBlackColor,
              fontSize: fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: BuildTextField2(
            hint: "Search tasks",
            controller: searchController,
            inputType: TextInputType.text,
            prefixIcon: const Icon(Icons.search, color: kGrey2),
            fillColor: kWhiteColor,
            onChange: (value) {
              context.read<TasksBloc>().add(SearchTaskEvent(keywords: value));
            },
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: kBlackColor),
          onPressed: () => showNotificationPanel(context),
        ),
      ],
    );
  }

  /// Builds the segmented filter controls and filter dialog button.
  Widget _buildFilters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: CupertinoSegmentedControl<String>(
            padding: EdgeInsets.zero,
            children: {
              'All': _buildSegment("All"),
              'Today': _buildSegment("Today"),
              'To Do': _buildSegment("To Do"),
              'Completed': _buildSegment("Done"),
            },
            onValueChanged: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            groupValue: selectedFilter,
            borderColor: kPrimaryColor,
            selectedColor: kPrimaryColor,
            unselectedColor: kWhiteColor,
            pressedColor: kPrimaryColor.withOpacity(0.2),
          ),
        ),
        const SizedBox(width: 25),
        IconButton(
          onPressed: () => showFilterDialog(context),
          icon: const Icon(Icons.filter_alt_outlined, color: kPrimaryColor),
        ),
      ],
    );
  }

  /// Builds a single segment for the segmented control.
  Widget _buildSegment(String label) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the list of tasks based on the selected filter.
  Widget _buildTaskList() {
    return Expanded(
      child: BlocConsumer<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is LoadTaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchTasksSuccess) {
            final filteredTasks = filterTasks(state.tasks);

            if (filteredTasks.isEmpty) {
              return const Center(child: Text("No tasks available."));
            }

            return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return TaskItemView(taskModel: filteredTasks[index]);
              },
              separatorBuilder: (context, index) =>
              const Divider(color: kGrey3),
            );
          }

          return const Center(child: Text("No tasks available."));
        },
      ),
    );
  }

  /// Filters the tasks based on the selected filter.
  List filterTasks(List tasks) {
    final today = DateTime.now();
    if (selectedFilter == 'Today') {
      return tasks.where((task) {
        final taskDate = task.date;
        return taskDate.year == today.year &&
            taskDate.month == today.month &&
            taskDate.day == today.day;
      }).toList();
    } else if (selectedFilter == 'To Do') {
      return tasks.where((task) => !task.completed).toList();
    } else if (selectedFilter == 'Completed') {
      return tasks.where((task) => task.completed).toList();
    }
    return tasks;
  }

  /// Displays the notification panel with today's tasks (excluding completed).
  void showNotificationPanel(BuildContext context) {
    final today = DateTime.now();
    final tasksBlocState = context.read<TasksBloc>().state;
    List<String> todayNotifications = [];

    if (tasksBlocState is FetchTasksSuccess) {
      todayNotifications = tasksBlocState.tasks
          .where((task) {
        final taskDate = task.date;
        return !task.completed && // Exclude completed tasks
            taskDate.year == today.year &&
            taskDate.month == today.month &&
            taskDate.day == today.day;
      })
          .map((task) => "Task '${task.title}' is due today.")
          .toList();
    }

    if (todayNotifications.isEmpty) {
      todayNotifications.add("No tasks due today.");
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return ListView.builder(
          itemCount: todayNotifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.notifications, color: kPrimaryColor),
              title: Text(todayNotifications[index]),
            );
          },
        );
      },
    );
  }

  /// Displays a filter dialog for additional filtering options.
  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter by"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Date"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Time"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
