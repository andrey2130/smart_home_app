import 'package:flutter/material.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';

// Центрує контент і обмежує його ширину, щоб на планшеті
// він не розтягувався на весь екран.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    required this.child,
    super.key,
    this.maxWidth = AppSpacing.contentMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
