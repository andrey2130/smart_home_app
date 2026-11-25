import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/repositories/device_repository.dart';

// In-memory реалізації контрактів для тестів UI.
// Те, що екрани працюють з ними без змін, підтверджує інверсію залежностей.
class FakeAuthRepository implements IAuthRepository {
  FakeAuthRepository({this.current});

  User? current;
  final Map<String, (User, String)> _users = {
    'demo@home.ua': (
      const User(name: 'Demo User', email: 'demo@home.ua'),
      'password1',
    ),
  };

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_users.containsKey(email)) {
      throw const AuthException('Користувач з таким email вже існує');
    }
    final user = User(name: name, email: email);
    _users[email] = (user, password);
    return current = user;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final record = _users[email];
    if (record == null || record.$2 != password) {
      throw const AuthException('Невірний email або пароль');
    }
    return current = record.$1;
  }

  @override
  Future<User?> getCurrentUser() async => current;

  @override
  Future<User> updateProfile(ProfileDraft draft) async =>
      current = current!.withProfile(draft);

  @override
  Future<void> logout() async => current = null;
}

class FakeDeviceRepository implements IDeviceRepository {
  final List<Device> devices = [
    const Device(
      id: '1',
      name: 'Нічник',
      room: 'Спальня',
      type: DeviceType.light,
      isOn: false,
    ),
    const Device(
      id: '2',
      name: 'Розумна розетка',
      room: 'Кухня',
      type: DeviceType.socket,
      isOn: true,
    ),
  ];
  int _nextId = 100;

  @override
  Future<List<Device>> getDevices(String ownerEmail) async => List.of(devices);

  @override
  Future<Device> addDevice(String ownerEmail, DeviceDraft draft) async {
    final device = Device(
      id: '${_nextId++}',
      name: draft.name,
      room: draft.room,
      type: draft.type,
      isOn: false,
    );
    devices.add(device);
    return device;
  }

  @override
  Future<void> updateDevice(String ownerEmail, Device device) async {
    final index = devices.indexWhere((d) => d.id == device.id);
    devices[index] = device;
  }

  @override
  Future<void> deleteDevice(String ownerEmail, String deviceId) async =>
      devices.removeWhere((d) => d.id == deviceId);

  @override
  Future<List<SensorReading>> getSensorReadings() async => const [
    SensorReading(type: SensorType.temperature, value: '22 °C'),
  ];
}
