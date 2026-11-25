import 'package:flutter/material.dart';

// Основна кнопка дії на всю ширину контейнера.
// Під час [isLoading] показує індикатор і блокує повторне натискання.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isDestructive = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isDestructive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = isDestructive
        ? FilledButton.styleFrom(backgroundColor: colors.error)
        : null;
    final callback = isLoading ? null : onPressed;
    final buttonIcon = icon;

    if (isLoading) {
      return FilledButton(
        onPressed: callback,
        style: style,
        child: const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    if (buttonIcon == null) {
      return FilledButton(
        onPressed: callback,
        style: style,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: callback,
      style: style,
      icon: Icon(buttonIcon),
      label: Text(label),
    );
  }
}
