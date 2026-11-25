import 'package:flutter/material.dart';
import 'package:smart_home_app/theme/app_colors.dart';

// Аватар з ініціалами користувача.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.initials, super.key, this.radius = 20});

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.75,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
