import 'package:flutter/material.dart';
import 'package:smart_home_app/counter_command.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final TextEditingController _controller = TextEditingController();
  int _counter = 0;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final command = CounterCommand.parse(_controller.text);

    setState(() {
      switch (command) {
        case IncrementCommand(:final value):
          _counter += value;
          _errorText = null;
          _controller.clear();
        case ResetCommand():
          _counter = 0;
          _errorText = null;
          _controller.clear();
        case InvalidCommand(:final message):
          _errorText = message;
      }
    });

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    switch (command) {
      case InvalidCommand(:final message):
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      case ResetCommand():
        messenger.showSnackBar(
          const SnackBar(content: Text('Лічильник обнулено')),
        );
      case IncrementCommand():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Лабораторна №1')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Text('Лічильник', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      '$_counter',
                      key: const Key('counterValue'),
                      style: theme.textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              key: const Key('inputField'),
              controller: _controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
              decoration: InputDecoration(
                labelText: 'Введіть число або заклинання',
                helperText: 'Ціле число додається до лічильника',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('submitButton'),
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Застосувати'),
            ),
          ],
        ),
      ),
    );
  }
}
