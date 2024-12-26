import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_simple/utils/font_sizes.dart';

/// Converts a UTC date string to a local [DateTime] object.
DateTime toDate({required String dateTime}) {
  final utcDateTime = DateTime.parse(dateTime);
  return utcDateTime.toLocal();
}

/// Formats a date string into a desired format.
/// Defaults to "dd MMM, yyyy" if no format is specified.
String formatDate({
  required String dateTime,
  String format = "dd MMM, yyyy",
}) {
  final localDateTime = toDate(dateTime: dateTime);
  return DateFormat(format).format(localDateTime);
}

/// Creates a customizable [SnackBar] with the given message and background color.
SnackBar getSnackBar({
  required String message,
  required Color backgroundColor,
}) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: fontSizeMedium),
    ),
    backgroundColor: backgroundColor,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
  );
}
