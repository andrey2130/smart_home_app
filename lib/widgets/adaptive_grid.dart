import 'package:flutter/material.dart';
import 'package:smart_home_app/theme/app_spacing.dart';

// Сітка, кількість колонок якої залежить від доступної ширини
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    required this.children,
    required this.itemHeight,
    super.key,
    this.minItemWidth = 160,
    this.maxColumns = 4,
  });

  final List<Widget> children;
  final double itemHeight;
  final double minItemWidth;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minItemWidth).floor().clamp(
          1,
          maxColumns,
        );

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: _aspectRatio(constraints.maxWidth, columns),
          children: children,
        );
      },
    );
  }

  double _aspectRatio(double width, int columns) {
    final spacing = AppSpacing.md * (columns - 1);
    final itemWidth = (width - spacing) / columns;
    return itemWidth / itemHeight;
  }
}
