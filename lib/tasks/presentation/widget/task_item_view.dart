import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/widgets.dart';
import '../../../routes/pages.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_sizes.dart';
import '../../../utils/util.dart';
import '../../data/local/model/task_model.dart';
import '../bloc/tasks_bloc.dart';

class TaskItemView extends StatefulWidget {
  final TaskModel taskModel;
  const TaskItemView({super.key, required this.taskModel});

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: widget.taskModel.completed,
            onChanged: (value) {
              var updatedTask = TaskModel(
                id: widget.taskModel.id,
                title: widget.taskModel.title,
                description: widget.taskModel.description,
                completed: !widget.taskModel.completed,
                date: widget.taskModel.date,
                time: widget.taskModel.time,
              );
              context.read<TasksBloc>().add(UpdateTaskEvent(taskModel: updatedTask));
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Task title
                    Expanded(
                      child: buildText(
                        widget.taskModel.title,
                        kBlackColor,
                        fontSizeMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip,
                      ),
                    ),
                    // Edit Icon
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/svgs/edit.svg',
                        width: 20,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Pages.updateTask,
                          arguments: widget.taskModel,
                        );
                      },
                    ),
                    // Delete Icon
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/svgs/delete.svg',
                        width: 20,
                      ),
                      onPressed: () {
                        context
                            .read<TasksBloc>()
                            .add(DeleteTaskEvent(taskModel: widget.taskModel));
                      },
                    ),
                  ],
                ),
                // const SizedBox(height: 5),
                // Task description
                buildText(
                  widget.taskModel.description,
                  kGrey1,
                  fontSizeSmall,
                  FontWeight.normal,
                  TextAlign.start,
                  TextOverflow.clip,
                ),
                const SizedBox(height: 15),
                // Date and Time
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date on the left
                      Row(
                        children: [
                          SvgPicture.asset('assets/svgs/calender.svg', width: 12),
                          const SizedBox(width: 10),
                          buildText(
                            widget.taskModel.date != null
                                ? formatDate(dateTime: widget.taskModel.date.toString())
                                : 'No date set',
                            kBlackColor,
                            fontSizeTiny,
                            FontWeight.w400,
                            TextAlign.start,
                            TextOverflow.clip,
                          ),
                        ],
                      ),
                      // Time on the right
                      Row(
                        children: [
                          SvgPicture.asset('assets/svgs/clock.svg', width: 12),
                          const SizedBox(width: 10),
                          buildText(
                            widget.taskModel.time != null
                                ? widget.taskModel.time.format(context)
                                : 'No time set',
                            kBlackColor,
                            fontSizeTiny,
                            FontWeight.w400,
                            TextAlign.end,
                            TextOverflow.clip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
