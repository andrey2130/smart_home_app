import 'package:flutter/material.dart';
import 'package:smart_home_app/models/device.dart';
import 'package:smart_home_app/models/user_profile.dart';
import 'package:smart_home_app/theme/app_colors.dart';

// Статичні дані-заглушки
abstract final class MockData {
  static const UserProfile user = UserProfile(
    name: 'Андрій Дуда',
    email: 'andrii@smarthome.ua',
    phone: '+380 67 123 45 67',
    address: 'Львів, вул. Наукова, 7',
  );

  static const List<String> rooms = [
    'Усі',
    'Вітальня',
    'Спальня',
    'Кухня',
    'Ванна',
  ];

  static const List<SensorReading> sensors = [
    SensorReading(
      label: 'Температура',
      value: '22.5 °C',
      icon: Icons.thermostat,
      color: AppColors.warm,
    ),
    SensorReading(
      label: 'Вологість',
      value: '45 %',
      icon: Icons.water_drop,
      color: AppColors.water,
    ),
    SensorReading(
      label: 'Освітлення',
      value: '320 lx',
      icon: Icons.wb_sunny,
      color: AppColors.light,
    ),
    SensorReading(
      label: 'Споживання',
      value: '1.2 кВт',
      icon: Icons.bolt,
      color: AppColors.primary,
    ),
  ];

  static const List<Device> devices = [
    Device(
      name: 'Головне світло',
      room: 'Вітальня',
      icon: Icons.lightbulb,
      status: 'Яскравість 70%',
      isOn: true,
    ),
    Device(
      name: 'Кондиціонер',
      room: 'Вітальня',
      icon: Icons.ac_unit,
      status: 'Охолодження 21 °C',
      isOn: false,
    ),
    Device(
      name: 'Нічник',
      room: 'Спальня',
      icon: Icons.nightlight,
      status: 'Теплий, 30%',
      isOn: false,
    ),
    Device(
      name: 'Розумна розетка',
      room: 'Кухня',
      icon: Icons.power,
      status: 'Чайник · 0.0 кВт',
      isOn: true,
    ),
    Device(
      name: 'Датчик протікання',
      room: 'Ванна',
      icon: Icons.water_damage,
      status: 'Сухо',
      isOn: true,
    ),
    Device(
      name: 'Дверний замок',
      room: 'Вітальня',
      icon: Icons.lock,
      status: 'Зачинено',
      isOn: true,
    ),
  ];
}
