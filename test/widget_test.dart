import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_app/main.dart';
import 'package:smart_home_app/routes/app_routes.dart';

// Розміри екранів: iPhone SE, iPhone 8, iPad (портрет і альбом).
const List<Size> _screenSizes = [
  Size(320, 568),
  Size(375, 667),
  Size(768, 1024),
  Size(1366, 1024),
];

void _setSize(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

// Відкриває застосунок одразу на маршруті [route].
Future<void> _pumpRoute(WidgetTester tester, String route) async {
  await tester.pumpWidget(
    SmartHomeApp(router: AppRoutes.createRouter(initialLocation: route)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('navigation between all screens', (tester) async {
    _setSize(tester, const Size(375, 667));
    await tester.pumpWidget(SmartHomeApp());
    expect(find.text('Увійдіть, щоб керувати своїм домом'), findsOneWidget);

    await tester.tap(find.text('Зареєструватися'));
    await tester.pumpAndSettle();
    expect(find.text('Створити акаунт'), findsOneWidget);

    await tester.ensureVisible(find.text('Увійти'));
    await tester.tap(find.text('Увійти'));
    await tester.pumpAndSettle();
    expect(find.text('Створити акаунт'), findsNothing);
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Увійти'));
    await tester.tap(find.widgetWithText(FilledButton, 'Увійти'));
    await tester.pumpAndSettle();
    expect(find.text('Пристрої'), findsOneWidget);

    await tester.tap(find.byTooltip('Профіль'));
    await tester.pumpAndSettle();
    expect(find.text('Особисті дані'), findsOneWidget);

    // Вкладений маршрут /main/profile дає кнопку «назад» у AppBar.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Пристрої'), findsOneWidget);

    await tester.tap(find.byTooltip('Профіль'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Вийти'), 200);
    await tester.tap(find.text('Вийти'));
    await tester.pumpAndSettle();
    expect(find.text('Увійдіть, щоб керувати своїм домом'), findsOneWidget);
  });

  testWidgets('room filter shows only devices of selected room', (
    tester,
  ) async {
    _setSize(tester, const Size(768, 1024));
    await _pumpRoute(tester, AppRoutes.main);
    expect(find.text('Нічник'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Кухня'));
    await tester.pump();
    expect(find.text('Нічник'), findsNothing);
    expect(find.text('Розумна розетка'), findsOneWidget);
  });

  for (final size in _screenSizes) {
    for (final route in AppRoutes.all) {
      testWidgets('$route renders without overflow at $size', (tester) async {
        _setSize(tester, size);
        await _pumpRoute(tester, route);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
