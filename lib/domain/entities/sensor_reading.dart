enum SensorType { temperature, humidity, light, power }

// Показник сенсора для блоку «Клімат».
class SensorReading {
  const SensorReading({required this.type, required this.value});

  final SensorType type;
  final String value;
}
