import 'package:flutter/material.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';

// Заголовок секції з необовʼязковим текстом праворуч.
class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, super.key, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trailingText = trailing;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
