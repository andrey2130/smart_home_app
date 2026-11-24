import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/data/mock_data.dart';
import 'package:smart_home_app/routes/app_routes.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/adaptive_grid.dart';
import 'package:smart_home_app/widgets/device_card.dart';
import 'package:smart_home_app/widgets/responsive_center.dart';
import 'package:smart_home_app/widgets/room_filter_bar.dart';
import 'package:smart_home_app/widgets/section_title.dart';
import 'package:smart_home_app/widgets/sensor_tile.dart';
import 'package:smart_home_app/widgets/user_avatar.dart';

// Головний екран (Dashboard): показники сенсорів і пристрої по кімнатах.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _room = MockData.rooms.first;

  @override
  Widget build(BuildContext context) {
    const user = MockData.user;
    final devices = MockData.devices
        .where((d) => _room == MockData.rooms.first || d.room == _room)
        .toList();
    final activeCount = MockData.devices.where((d) => d.isOn).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Привіт, ${user.name.split(' ').first}!'),
        actions: [
          IconButton(
            tooltip: 'Профіль',
            onPressed: () => context.go(AppRoutes.profile),
            icon: UserAvatar(initials: user.initials, radius: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ResponsiveCenter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle(title: 'Клімат', trailing: 'Вітальня'),
                  AdaptiveGrid(
                    itemHeight: 84,
                    minItemWidth: 170,
                    children: [
                      for (final reading in MockData.sensors)
                        SensorTile(reading: reading),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionTitle(
                    title: 'Пристрої',
                    trailing: '$activeCount активних',
                  ),
                  RoomFilterBar(
                    rooms: MockData.rooms,
                    selected: _room,
                    onSelected: (room) => setState(() => _room = room),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AdaptiveGrid(
                    itemHeight: 150,
                    children: [
                      for (final device in devices)
                        DeviceCard(key: ValueKey(device.name), device: device),
                    ],
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
