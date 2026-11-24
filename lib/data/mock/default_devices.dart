import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';

// Стартові дані для нового користувача.
abstract final class DefaultDevices {
  static const List<Device> values = [
    Device(
      id: 'default-1',
      name: 'Головне світло',
      room: 'Вітальня',
      type: DeviceType.light,
      isOn: true,
    ),
    Device(
      id: 'default-2',
      name: 'Кондиціонер',
      room: 'Вітальня',
      type: DeviceType.climate,
      isOn: false,
    ),
    Device(
      id: 'default-3',
      name: 'Розумна розетка',
      room: 'Кухня',
      type: DeviceType.socket,
      isOn: true,
    ),
    Device(
      id: 'default-4',
      name: 'Дверний замок',
      room: 'Коридор',
      type: DeviceType.lock,
      isOn: true,
    ),
  ];

  static const List<SensorReading> sensors = [
    SensorReading(type: SensorType.temperature, value: '22.5 °C'),
    SensorReading(type: SensorType.humidity, value: '45 %'),
    SensorReading(type: SensorType.light, value: '320 lx'),
    SensorReading(type: SensorType.power, value: '1.2 кВт'),
  ];
}
