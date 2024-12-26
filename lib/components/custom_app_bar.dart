import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_simple/components/widgets.dart';
import 'package:todo_simple/utils/color_palette.dart';
import 'package:todo_simple/utils/font_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackArrow;
  final Color backgroundColor;
  final List<Widget>? actionWidgets;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackTap,
    this.showBackArrow = true,
    this.backgroundColor = kWhiteColor,
    this.actionWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: showBackArrow
          ? IconButton(
        icon: SvgPicture.asset('assets/svgs/back_arrow.svg'),
        onPressed: onBackTap ?? () => Navigator.of(context).pop(),
      )
          : null,
      actions: actionWidgets,
      title: buildText(
        title,
        kBlackColor,
        fontSizeMedium,
        FontWeight.w500,
        TextAlign.start,
        TextOverflow.clip,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
