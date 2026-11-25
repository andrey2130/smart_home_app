import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/data/local/prefs_auth_repository.dart';
import 'package:smart_home_app/data/local/prefs_device_repository.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/validators.dart';

void main() {
  group('Validators', () {
    test('email requires @ and domain', () {
      expect(Validators.email('user@mail.com'), isNull);
      for (final bad in ['', 'user', 'user@', 'user@mail', '@mail.com']) {
        expect(Validators.email(bad), isNotNull, reason: bad);
      }
    });

    test('password: at least 8 chars with letters and digits', () {
      expect(Validators.password('secret12'), isNull);
      expect(Validators.password('short1'), isNotNull);
      expect(Validators.password('onlyletters'), isNotNull);
      expect(Validators.password('12345678'), isNotNull);
    });

    test('phone is optional, but only in +380XXXXXXXXX format', () {
      expect(Validators.phone(''), isNull);
      expect(Validators.phone('+380671234567'), isNull);
      expect(Validators.phone('+380 (67) 123-45-67'), isNull);
      for (final bad in ['0671234567', '+38067123456', '+3806712345678']) {
        expect(Validators.phone(bad), isNotNull, reason: bad);
      }
    });

    test('name must not contain digits', () {
      expect(Validators.name('Андрій Дуда'), isNull);
      expect(Validators.name('Andrii2'), isNotNull);
      expect(Validators.name(' '), isNotNull);
    });
  });

  group('PrefsAuthRepository', () {
    late SharedPreferences prefs;
    late PrefsAuthRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = PrefsAuthRepository(prefs);
    });

    test('register -> logout -> login', () async {
      await repo.register(
        name: 'Андрій',
        email: 'A@x.ua',
        password: 'pass1234',
      );
      expect((await repo.getCurrentUser())?.email, 'a@x.ua');

      await repo.logout();
      expect(await repo.getCurrentUser(), isNull);

      final user = await repo.login(email: 'a@x.ua', password: 'pass1234');
      expect(user.name, 'Андрій');
    });

    test('profile update persists normalized phone and address', () async {
      await repo.register(
        name: 'Андрій',
        email: 'a@x.ua',
        password: 'pass1234',
      );
      await repo.updateProfile((
        name: 'Андрій Дуда',
        phone: '+380 67 123 45 67',
        address: 'Львів, вул. Наукова, 7',
      ));
      final user = await PrefsAuthRepository(prefs).getCurrentUser();
      expect(user?.name, 'Андрій Дуда');
      expect(user?.phone, '+380671234567');
      expect(user?.address, 'Львів, вул. Наукова, 7');
      expect(
        repo.updateProfile((name: 'Андрій', phone: '123', address: null)),
        throwsA(isA<AuthException>()),
      );
    });

    test('password is stored hashed, not in plain text', () async {
      await repo.register(
        name: 'Андрій',
        email: 'a@x.ua',
        password: 'pass1234',
      );
      expect(prefs.getString('auth.users'), isNot(contains('pass1234')));
    });

    test('rejects wrong password, duplicates and invalid data', () async {
      await repo.register(
        name: 'Андрій',
        email: 'a@x.ua',
        password: 'pass1234',
      );
      expect(
        repo.login(email: 'a@x.ua', password: 'wrong123'),
        throwsA(isA<AuthException>()),
      );
      expect(
        repo.register(name: 'Інший', email: 'a@x.ua', password: 'pass1234'),
        throwsA(isA<AuthException>()),
      );
      expect(
        repo.register(name: 'Bob', email: 'bad', password: 'pass1234'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  test('PrefsDeviceRepository CRUD persists between instances', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsDeviceRepository(prefs);
    const owner = 'a@x.ua';

    final initial = await repo.getDevices(owner);
    final added = await repo.addDevice(owner, (
      name: 'Лампа',
      room: 'Кухня',
      type: DeviceType.light,
    ));
    await repo.updateDevice(owner, added.copyWith(isOn: true));
    await repo.deleteDevice(owner, initial.first.id);

    // Новий екземпляр читає ті самі дані — тобто вони збережені.
    final reloaded = await PrefsDeviceRepository(prefs).getDevices(owner);
    expect(reloaded.length, initial.length);
    expect(reloaded.any((d) => d.id == initial.first.id), isFalse);
    expect(reloaded.firstWhere((d) => d.id == added.id).isOn, isTrue);
  });
}
