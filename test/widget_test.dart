import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_app/counter_command.dart';
import 'package:smart_home_app/main.dart';

void main() {
  group('CounterCommand.parse', () {
    test('parses positive and negative integers', () {
      expect(CounterCommand.parse('5'), isA<IncrementCommand>());
      expect((CounterCommand.parse('-7') as IncrementCommand).value, -7);
      expect((CounterCommand.parse(' +3 ') as IncrementCommand).value, 3);
    });

    test('recognizes the reset phrase', () {
      expect(CounterCommand.parse('Avada Kedavra'), isA<ResetCommand>());
    });

    test('rejects everything else', () {
      for (final input in [
        '',
        '   ',
        'abc',
        '1.5',
        '0x10',
        '@#!',
        'avada kedavra',
        '99999999999999999999999',
      ]) {
        expect(
          CounterCommand.parse(input),
          isA<InvalidCommand>(),
          reason: input,
        );
      }
    });
  });

  testWidgets('counter reacts to user input', (tester) async {
    await tester.pumpWidget(const MyApp());
    final field = find.byKey(const Key('inputField'));
    final button = find.byKey(const Key('submitButton'));
    String counter() =>
        tester.widget<Text>(find.byKey(const Key('counterValue'))).data!;

    expect(counter(), '0');

    await tester.enterText(field, '10');
    await tester.tap(button);
    await tester.pump();
    expect(counter(), '10');

    await tester.enterText(field, '-3');
    await tester.tap(button);
    await tester.pump();
    expect(counter(), '7');

    await tester.enterText(field, 'hello');
    await tester.tap(button);
    await tester.pump();
    expect(counter(), '7');
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.enterText(field, 'Avada Kedavra');
    await tester.tap(button);
    await tester.pump();
    expect(counter(), '0');
  });
}
