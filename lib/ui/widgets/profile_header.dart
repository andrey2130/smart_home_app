import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/user_avatar.dart';

// Шапка профілю: великий аватар, імʼя та email.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        UserAvatar(initials: user.initials, radius: 48),
        const SizedBox(height: AppSpacing.md),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
