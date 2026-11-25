import 'package:flutter/material.dart';
import 'package:smart_home_app/models/device.dart';
import 'package:smart_home_app/theme/app_colors.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/icon_badge.dart';

// Плитка з показником сенсора (температура, вологість тощо).
class SensorTile extends StatelessWidget {
  const SensorTile({required this.reading, super.key});

  final SensorReading reading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            IconBadge(icon: reading.icon, color: reading.color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    reading.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    reading.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
