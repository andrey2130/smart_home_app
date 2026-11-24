import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/adaptive_grid.dart';
import 'package:smart_home_app/ui/widgets/device_card.dart';
import 'package:smart_home_app/ui/widgets/responsive_center.dart';
import 'package:smart_home_app/ui/widgets/room_filter_bar.dart';
import 'package:smart_home_app/ui/widgets/section_title.dart';
import 'package:smart_home_app/ui/widgets/sensor_tile.dart';

// Вміст головного екрана: сенсори, фільтр кімнат і сітка пристроїв.
class DashboardContent extends StatefulWidget {
  const DashboardContent({
    required this.sensors,
    required this.devices,
    required this.onToggle,
    required this.onEdit,
    super.key,
  });

  final List<SensorReading> sensors;
  final List<Device> devices;
  final void Function(Device device, bool isOn) onToggle;
  final ValueChanged<Device> onEdit;

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  static const String _allRooms = 'Усі';
  String _room = _allRooms;

  @override
  Widget build(BuildContext context) {
    final devices = widget.devices
        .where((d) => _room == _allRooms || d.room == _room)
        .toList();
    final activeCount = widget.devices.where((d) => d.isOn).length;

    return ListView(
      // Нижній відступ, щоб FAB не перекривав останні картки.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl * 3,
      ),
      children: [
        ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'Клімат'),
              AdaptiveGrid(
                itemHeight: 84,
                minItemWidth: 170,
                children: [
                  for (final reading in widget.sensors)
                    SensorTile(reading: reading),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionTitle(
                title: 'Пристрої',
                trailing: '$activeCount з ${widget.devices.length} активні',
              ),
              RoomFilterBar(
                rooms: const [_allRooms, ...DeviceRooms.values],
                selected: _room,
                onSelected: (room) => setState(() => _room = room),
              ),
              const SizedBox(height: AppSpacing.md),
              if (devices.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'Тут ще немає пристроїв.\nНатисніть «Додати».',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                AdaptiveGrid(
                  itemHeight: 150,
                  children: [
                    for (final device in devices)
                      DeviceCard(
                        key: ValueKey(device.id),
                        device: device,
                        onToggle: (isOn) => widget.onToggle(device, isOn),
                        onTap: () => widget.onEdit(device),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
