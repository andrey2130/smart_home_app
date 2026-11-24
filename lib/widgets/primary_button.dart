import 'package:flutter/material.dart';

// Основна кнопка дії на всю ширину контейнера.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final style = isDestructive
        ? FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        : null;
    final buttonIcon = icon;

    if (buttonIcon == null) {
      return FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(buttonIcon),
      label: Text(label),
    );
  }
}
