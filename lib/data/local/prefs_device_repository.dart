import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/data/mock/default_devices.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';
import 'package:smart_home_app/domain/repositories/device_repository.dart';

// Реалізація [IDeviceRepository] на shared_preferences.
// Пристрої кожного користувача зберігаються окремим JSON-списком.
class PrefsDeviceRepository implements IDeviceRepository {
  const PrefsDeviceRepository(this._prefs, {this.latency = Duration.zero});

  final SharedPreferences _prefs;
  final Duration latency;

  @override
  Future<List<Device>> getDevices(String ownerEmail) async {
    await Future<void>.delayed(latency);
    final raw = _prefs.getString(_key(ownerEmail));
    if (raw == null) {
      // Новий користувач отримує стартовий набір пристроїв.
      await _write(ownerEmail, DefaultDevices.values);
      return DefaultDevices.values;
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list)
        _fromJson(Map<String, Object?>.from(item as Map)),
    ];
  }

  @override
  Future<Device> addDevice(String ownerEmail, DeviceDraft draft) async {
    final devices = await getDevices(ownerEmail);
    final device = Device(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: draft.name.trim(),
      room: draft.room,
      type: draft.type,
      isOn: false,
    );
    await _write(ownerEmail, [...devices, device]);
    return device;
  }

  @override
  Future<void> updateDevice(String ownerEmail, Device device) async {
    final devices = await getDevices(ownerEmail);
    await _write(ownerEmail, [
      for (final d in devices) d.id == device.id ? device : d,
    ]);
  }

  @override
  Future<void> deleteDevice(String ownerEmail, String deviceId) async {
    final devices = await getDevices(ownerEmail);
    await _write(ownerEmail, devices.where((d) => d.id != deviceId).toList());
  }

  @override
  Future<List<SensorReading>> getSensorReadings() async {
    // Реальні сенсори підключимо через REST API в наступних лабах.
    return DefaultDevices.sensors;
  }

  String _key(String ownerEmail) => 'devices.$ownerEmail';

  Future<void> _write(String ownerEmail, List<Device> devices) {
    final json = jsonEncode([for (final d in devices) _toJson(d)]);
    return _prefs.setString(_key(ownerEmail), json);
  }

  static Map<String, Object?> _toJson(Device d) => {
    'id': d.id,
    'name': d.name,
    'room': d.room,
    'type': d.type.name,
    'isOn': d.isOn,
  };

  static Device _fromJson(Map<String, Object?> json) => Device(
    id: json['id'] as String,
    name: json['name'] as String,
    room: json['room'] as String,
    type: DeviceType.values.byName(json['type'] as String),
    isOn: json['isOn'] as bool,
  );
}
