import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';

// Контракт CRUD-операцій з пристроями користувача.
abstract interface class IDeviceRepository {
  Future<List<Device>> getDevices(String ownerEmail);

  Future<Device> addDevice(String ownerEmail, DeviceDraft draft);

  Future<void> updateDevice(String ownerEmail, Device device);

  Future<void> deleteDevice(String ownerEmail, String deviceId);

  Future<List<SensorReading>> getSensorReadings();
}
