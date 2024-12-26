import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_simple/components/widgets.dart';
import 'package:todo_simple/tasks/data/local/model/task_model.dart';
import 'package:todo_simple/utils/font_sizes.dart';

import '../../../components/custom_app_bar.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/util.dart';
import '../bloc/tasks_bloc.dart';
import '../../../components/build_text_field.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;

  const UpdateTaskScreen({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskModel.title;
    descriptionController.text = widget.taskModel.description;
    _selectedDate = widget.taskModel.date;
    _selectedTime = widget.taskModel.time;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
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
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _updateTask() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(
          message: 'Please select both date and time',
          backgroundColor: kRed,
        ),
      );
      return;
    }

    final updatedTask = widget.taskModel.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      date: _selectedDate!,
      time: _selectedTime!,
    );

    context.read<TasksBloc>().add(UpdateTaskEvent(taskModel: updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const CustomAppBar(title: 'Update Task'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TasksBloc, TasksState>(
              listener: (context, state) {
                if (state is UpdateTaskFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    getSnackBar(
                      message: state.error,
                      backgroundColor: kRed,
                    ),
                  );
                }
                if (state is UpdateTaskSuccess) {
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
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Description'),
                    BuildTextField(
                      hint: "Task Description",
                      controller: descriptionController,
                      inputType: TextInputType.multiline,
                      fillColor: kWhiteColor,
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),

                    _buildUpdateButton(size),
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

  Widget _buildUpdateButton(Size size) {
    return SizedBox(
      width: size.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        onPressed: _updateTask,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: buildText(
            'Update',
            kWhiteColor,
            fontSizeMedium,
            FontWeight.w600,
            TextAlign.center,
            TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
