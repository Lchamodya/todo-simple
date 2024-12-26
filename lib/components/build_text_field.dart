import 'package:flutter/material.dart';

import '../utils/color_palette.dart';
import '../utils/font_sizes.dart';

class BuildTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final Color fillColor;
  final Color hintColor;
  final int? maxLength;
  final ValueChanged<String> onChange;
  final FormFieldValidator<String>? validator;

  const BuildTextField({
    Key? key,
    required this.hint,
    this.controller,
    required this.inputType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.fillColor = kWhiteColor,
    this.hintColor = kGrey1,
    this.maxLength,
    required this.onChange,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: inputType == TextInputType.multiline ? null : 1,
      onChanged: onChange,
      validator: validator ?? (value) => value?.isEmpty == true ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        hintStyle: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.w300,
          color: hintColor,
        ),
        counterText: "",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: const TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.normal,
          color: kRed,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: kGrey1, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: kRed, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: kGrey1, width: 1),
        ),
      ),
      style: const TextStyle(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.normal,
        color: kBlackColor,
      ),
      cursorColor: kPrimaryColor,
    );
  }
}
