import 'package:flutter/material.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';

// Логотип застосунку: іконка будинку в кольоровому квадраті.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Icon(Icons.home_rounded, color: Colors.white, size: size * 0.6),
      ),
    );
  }
}
