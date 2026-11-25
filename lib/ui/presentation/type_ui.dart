import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';
import 'package:smart_home_app/ui/theme/app_colors.dart';

extension DeviceTypeUi on DeviceType {
  IconData get icon => switch (this) {
    DeviceType.light => Icons.lightbulb,
    DeviceType.climate => Icons.ac_unit,
    DeviceType.socket => Icons.power,
    DeviceType.sensor => Icons.sensors,
    DeviceType.lock => Icons.lock,
  };

  String get label => switch (this) {
    DeviceType.light => 'Освітлення',
    DeviceType.climate => 'Клімат',
    DeviceType.socket => 'Розетка',
    DeviceType.sensor => 'Датчик',
    DeviceType.lock => 'Замок',
  };
}

extension SensorTypeUi on SensorType {
  IconData get icon => switch (this) {
    SensorType.temperature => Icons.thermostat,
    SensorType.humidity => Icons.water_drop,
    SensorType.light => Icons.wb_sunny,
    SensorType.power => Icons.bolt,
  };

  Color get color => switch (this) {
    SensorType.temperature => AppColors.warm,
    SensorType.humidity => AppColors.water,
    SensorType.light => AppColors.light,
    SensorType.power => AppColors.primary,
  };

  String get label => switch (this) {
    SensorType.temperature => 'Температура',
    SensorType.humidity => 'Вологість',
    SensorType.light => 'Освітлення',
    SensorType.power => 'Споживання',
  };
}
