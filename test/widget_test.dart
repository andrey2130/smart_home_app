import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/main.dart';
import 'package:smart_home_app/ui/routes/app_routes.dart';

import 'fakes/fake_repositories.dart';

// Розміри екранів: iPhone SE, iPhone 8, iPad (портрет і альбом).
const List<Size> _screenSizes = [
  Size(320, 568),
  Size(375, 667),
  Size(768, 1024),
  Size(1366, 1024),
];

const User _demo = User(name: 'Demo User', email: 'demo@home.ua');

Future<(FakeAuthRepository, FakeDeviceRepository)> _pumpApp(
  WidgetTester tester, {
  String route = AppRoutes.login,
  User? user,
  Size size = const Size(375, 667),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final auth = FakeAuthRepository(current: user);
  final devices = FakeDeviceRepository();
  await tester.pumpWidget(
    SmartHomeApp(
      router: AppRoutes.createRouter(
        authRepository: auth,
        deviceRepository: devices,
        initialLocation: route,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (auth, devices);
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).last);
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

void main() {
  group('Login', () {
    testWidgets('invalid email is blocked by validation', (tester) async {
      await _pumpApp(tester);
      await tester.enterText(find.byKey(const Key('loginEmail')), 'demo');
      await _tapText(tester, 'Увійти');
      expect(find.text('Email має містити @ та домен'), findsOneWidget);
      expect(find.text('Пристрої'), findsNothing);
    });

    testWidgets('wrong password shows error, correct one opens main', (
      tester,
    ) async {
      await _pumpApp(tester);
      await tester.enterText(
        find.byKey(const Key('loginEmail')),
        'demo@home.ua',
      );
      await tester.enterText(find.byKey(const Key('loginPassword')), 'nope');
      await _tapText(tester, 'Увійти');
      expect(find.text('Невірний email або пароль'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('loginPassword')),
        'password1',
      );
      await _tapText(tester, 'Увійти');
      expect(find.text('Привіт, Demo!'), findsOneWidget);
    });
  });

  testWidgets('registration validates fields and signs up', (tester) async {
    final (auth, _) = await _pumpApp(tester, route: AppRoutes.registration);
    await tester.enterText(find.byKey(const Key('regName')), 'Bob1');
    await tester.enterText(find.byKey(const Key('regEmail')), 'bob@mail.com');
    await tester.enterText(find.byKey(const Key('regPassword')), 'short');
    await _tapText(tester, 'Зареєструватися');
    expect(find.text('Імʼя не може містити цифри'), findsOneWidget);
    expect(find.text('Пароль — мінімум 8 символів'), findsOneWidget);
    expect(auth.current, isNull);

    await tester.enterText(find.byKey(const Key('regName')), 'Bob Smith');
    await tester.enterText(find.byKey(const Key('regPassword')), 'secret123');
    await tester.enterText(find.byKey(const Key('regConfirm')), 'secret123');
    await _tapText(tester, 'Зареєструватися');
    expect(auth.current?.email, 'bob@mail.com');
    expect(find.text('Привіт, Bob!'), findsOneWidget);
  });

  testWidgets('devices CRUD on main screen', (tester) async {
    final (_, repo) = await _pumpApp(
      tester,
      route: AppRoutes.main,
      user: _demo,
    );
    expect(find.text('Нічник'), findsOneWidget);

    // Create
    await _tapText(tester, 'Додати');
    await tester.enterText(find.byKey(const Key('deviceNameField')), 'Лампа');
    await _tapText(tester, 'Зберегти');
    expect(find.text('Лампа'), findsOneWidget);
    expect(repo.devices.any((d) => d.name == 'Лампа'), isTrue);

    // Update
    await _tapText(tester, 'Лампа');
    await tester.enterText(find.byKey(const Key('deviceNameField')), 'Торшер');
    await _tapText(tester, 'Зберегти');
    expect(find.text('Торшер'), findsOneWidget);
    expect(find.text('Лампа'), findsNothing);

    // Toggle
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(repo.devices.first.isOn, isTrue);

    // Delete
    await _tapText(tester, 'Торшер');
    await _tapText(tester, 'Видалити пристрій');
    await _tapText(tester, 'Видалити');
    expect(find.text('Торшер'), findsNothing);
    expect(repo.devices.any((d) => d.name == 'Торшер'), isFalse);
  });

  testWidgets('profile shows user, edits profile and logs out', (tester) async {
    final (auth, _) = await _pumpApp(
      tester,
      route: AppRoutes.main,
      user: _demo,
    );
    await tester.tap(find.byTooltip('Профіль'));
    await tester.pumpAndSettle();
    expect(find.text('demo@home.ua'), findsWidgets);

    expect(find.text('Не вказано'), findsNWidgets(2));

    await _tapText(tester, 'Редагувати профіль');
    await tester.enterText(find.byKey(const Key('profilePhone')), '067123');
    await _tapText(tester, 'Зберегти');
    expect(find.text('Телефон у форматі +380XXXXXXXXX'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('profileName')), 'New Name');
    await tester.enterText(
      find.byKey(const Key('profilePhone')),
      '+380 67 123 45 67',
    );
    await tester.enterText(
      find.byKey(const Key('profileAddress')),
      'Львів, вул. Наукова, 7',
    );
    await _tapText(tester, 'Зберегти');
    expect(find.text('New Name'), findsWidgets);
    expect(find.text('Львів, вул. Наукова, 7'), findsOneWidget);
    expect(auth.current?.phone, '+380 67 123 45 67');

    // Чекаємо, поки SnackBar «Профіль оновлено» зникне з-над кнопки.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await _tapText(tester, 'Вийти');
    expect(auth.current, isNull);
    expect(find.text('Увійдіть, щоб керувати своїм домом'), findsOneWidget);
  });

  for (final size in _screenSizes) {
    for (final route in AppRoutes.all) {
      testWidgets('$route renders without overflow at $size', (tester) async {
        await _pumpApp(tester, route: route, user: _demo, size: size);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
