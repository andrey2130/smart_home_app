import 'package:flutter/material.dart';
import 'package:smart_home_app/theme/app_colors.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.text,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: AppColors.textSecondary)),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}
