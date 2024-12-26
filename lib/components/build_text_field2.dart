import 'package:flutter/material.dart';

class BuildTextField2 extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? prefixIcon;
  final Color fillColor;
  final ValueChanged<String> onChange;
  final InputDecoration? decoration;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;

  const BuildTextField2({
    Key? key,
    required this.hint,
    this.controller,
    required this.inputType,
    this.prefixIcon,
    this.fillColor = Colors.white,
    required this.onChange,
    this.decoration,
    this.obscureText = false,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      onChanged: onChange,
      obscureText: obscureText,
      decoration: decoration ??
          InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
      style: textStyle ??
          const TextStyle(
            fontSize: 14,
          ),
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
    );
  }
}
