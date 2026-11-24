import 'package:flutter/material.dart';

// Розумний пристрій у кімнаті.
class Device {
  const Device({
    required this.name,
    required this.room,
    required this.icon,
    required this.status,
    required this.isOn,
  });

  final String name;
  final String room;
  final IconData icon;
  final String status;
  final bool isOn;
}

// Показник сенсора для блоку «Клімат».
class SensorReading {
  const SensorReading({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
