import 'package:flutter/material.dart';
import 'package:smart_home_app/theme/app_colors.dart';
import 'package:smart_home_app/widgets/icon_badge.dart';

// Рядок налаштувань / інформації профілю.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final subtitleText = subtitle;

    return ListTile(
      leading: IconBadge(icon: icon, color: AppColors.primary, size: 40),
      title: Text(title),
      subtitle: subtitleText == null ? null : Text(subtitleText),
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}
