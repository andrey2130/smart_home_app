import 'package:flutter/material.dart';
import 'package:smart_home_app/models/device.dart';
import 'package:smart_home_app/theme/app_colors.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/icon_badge.dart';

// Картка розумного пристрою з перемикачем увімкнення
class DeviceCard extends StatefulWidget {
  const DeviceCard({required this.device, super.key});

  final Device device;

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool _isOn = widget.device.isOn;

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final textTheme = Theme.of(context).textTheme;
    final accent = _isOn ? AppColors.primary : AppColors.textSecondary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBadge(icon: device.icon, color: accent),
                const Spacer(),
                Switch(
                  value: _isOn,
                  onChanged: (value) => setState(() => _isOn = value),
                ),
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
              _isOn ? '${device.room} · ${device.status}' : device.room,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
