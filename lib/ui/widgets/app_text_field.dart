import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.icon,
    super.key,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      autovalidateMode: AutovalidateMode.onUnfocus,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
