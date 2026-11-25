import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/ui/presentation/type_ui.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/icon_badge.dart';

// Картка розумного пристрою. Стан зберігає батьківський екран,
// картка лише повідомляє про дії через колбеки.
class DeviceCard extends StatelessWidget {
  const DeviceCard({
    required this.device,
    required this.onToggle,
    required this.onTap,
    super.key,
  });

  final Device device;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = device.isOn ? AppColors.primary : AppColors.textSecondary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(icon: device.type.icon, color: accent),
                  const Spacer(),
                  Switch(value: device.isOn, onChanged: onToggle),
                ],
              ),
              const Spacer(),
              Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${device.room} · ${device.isOn ? 'Увімкнено' : 'Вимкнено'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
