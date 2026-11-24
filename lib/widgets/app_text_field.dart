import 'package:flutter/material.dart';

// Уніфіковане текстове поле з іконкою зліва.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.icon,
    super.key,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final IconData icon;
  final String? initialValue;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
