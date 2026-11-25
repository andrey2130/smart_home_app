sealed class CounterCommand {
  const CounterCommand();
  static const String resetPhrase = 'Avada Kedavra';

  // Дозволений формат цілого числа необовʼязковий знак та цифри.
  static final RegExp _integerPattern = RegExp(r'^[+-]?\d+$');

  // Валідує та розбирає [raw] у відповідну команду
  static CounterCommand parse(String raw) {
    if (raw == resetPhrase) {
      return const ResetCommand();
    }

    final input = raw.trim();
    if (input.isEmpty) {
      return const InvalidCommand('Поле порожнє. Введіть ціле число.');
    }
    if (!_integerPattern.hasMatch(input)) {
      return InvalidCommand('"$raw" не є цілим числом.');
    }

    final value = int.tryParse(input);
    if (value == null) {
      return const InvalidCommand('Число занадто велике.');
    }
    return IncrementCommand(value);
  }
}

class IncrementCommand extends CounterCommand {
  const IncrementCommand(this.value);

  final int value;
}

class ResetCommand extends CounterCommand {
  const ResetCommand();
}

class InvalidCommand extends CounterCommand {
  const InvalidCommand(this.message);

  final String message;
}
