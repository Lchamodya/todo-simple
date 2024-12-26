import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_simple/components/widgets.dart';
import 'package:todo_simple/tasks/data/local/model/task_model.dart';
import 'package:todo_simple/utils/font_sizes.dart';
import 'package:todo_simple/utils/util.dart';

import '../../../components/custom_app_bar.dart';
import '../../../utils/color_palette.dart';
import '../bloc/tasks_bloc.dart';
import '../../../components/build_text_field.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    _selectedDate = DateTime.now(); // Default to today's date
    _selectedTime = TimeOfDay.now(); // Default to current time
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveTask(BuildContext context) {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(message: 'Please select a date', backgroundColor: kRed),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(message: 'Please select a time', backgroundColor: kRed),
      );
      return;
    }

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(message: 'Please enter a title', backgroundColor: kRed),
      );
      return;
    }

    final taskId = DateTime.now().millisecondsSinceEpoch.toString();

    final newTask = TaskModel(
      id: taskId,
      title: titleController.text,
      description: descriptionController.text,
      date: _selectedDate!,
      time: _selectedTime!,
    );

    context.read<TasksBloc>().add(AddNewTaskEvent(taskModel: newTask));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const CustomAppBar(title: 'Create New Task'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TasksBloc, TasksState>(
              listener: (context, state) {
                if (state is AddTaskFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    getSnackBar(
                      message: state.error,
                      backgroundColor: kRed,
                    ),
                  );
                }
                if (state is AddTasksSuccess) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return ListView(
                  children: [
                    _buildSectionTitle('Date'),
                    _buildDatePicker(context),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Time'),
                    _buildTimePicker(context),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Title'),
                    BuildTextField(
                      hint: "Task Title",
                      controller: titleController,
                      inputType: TextInputType.text,
                      fillColor: kWhiteColor,
                      onChange: (_) {},
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Description'),
                    BuildTextField(
                      hint: "Task Description",
                      controller: descriptionController,
                      inputType: TextInputType.multiline,
                      fillColor: kWhiteColor,
                      onChange: (_) {},
                    ),
                    const SizedBox(height: 20),

                    _buildActionButtons(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return buildText(
      title,
      kBlackColor,
      fontSizeMedium,
      FontWeight.bold,
      TextAlign.start,
      TextOverflow.clip,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: buildText(
          _selectedDate != null
              ? 'Task Date: ${formatDate(dateTime: _selectedDate.toString())}'
              : 'Select a Date',
          kPrimaryColor,
          fontSizeSmall,
          FontWeight.w400,
          TextAlign.start,
          TextOverflow.clip,
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: buildText(
          _selectedTime != null
              ? 'Task Time: ${_selectedTime!.format(context)}'
              : 'Select a Time',
          kPrimaryColor,
          fontSizeSmall,
          FontWeight.w400,
          TextAlign.start,
          TextOverflow.clip,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kWhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: buildText(
                'Cancel',
                kBlackColor,
                fontSizeMedium,
                FontWeight.w600,
                TextAlign.center,
                TextOverflow.clip,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _saveTask(context),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: buildText(
                'Save',
                kWhiteColor,
                fontSizeMedium,
                FontWeight.w600,
                TextAlign.center,
                TextOverflow.clip,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
