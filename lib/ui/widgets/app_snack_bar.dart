import 'package:flutter/material.dart';

// Єдиний спосіб показати користувачу коротке повідомлення.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final colors = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colors.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
