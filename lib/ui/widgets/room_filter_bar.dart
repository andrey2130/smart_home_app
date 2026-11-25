import 'package:flutter/material.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';

// Горизонтальний список кімнат-фільтрів.
class RoomFilterBar extends StatelessWidget {
  const RoomFilterBar({
    required this.rooms,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> rooms;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ChoiceChip(
            label: Text(room),
            selected: room == selected,
            onSelected: (_) => onSelected(room),
          );
        },
      ),
    );
  }
}
