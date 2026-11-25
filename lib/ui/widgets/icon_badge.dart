import 'package:flutter/material.dart';

// Іконка в напівпрозорому кольоровому колі
class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.icon,
    required this.color,
    super.key,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
