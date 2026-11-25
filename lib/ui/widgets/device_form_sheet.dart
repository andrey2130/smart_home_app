import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/validators.dart';
import 'package:smart_home_app/ui/presentation/type_ui.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/app_text_field.dart';
import 'package:smart_home_app/ui/widgets/primary_button.dart';

// Результат роботи форми: зберегти зміни або видалити пристрій.
sealed class DeviceFormResult {
  const DeviceFormResult();
}

class DeviceFormSaved extends DeviceFormResult {
  const DeviceFormSaved(this.draft);

  final DeviceDraft draft;
}

class DeviceFormDeleted extends DeviceFormResult {
  const DeviceFormDeleted();
}

// Відкриває форму створення (device == null) або редагування пристрою.
Future<DeviceFormResult?> showDeviceFormSheet(
  BuildContext context, {
  Device? device,
}) {
  return showModalBottomSheet<DeviceFormResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DeviceForm(device: device),
  );
}

class _DeviceForm extends StatefulWidget {
  const _DeviceForm({this.device});

  final Device? device;

  @override
  State<_DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<_DeviceForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.device?.name);
  late String _room = widget.device?.room ?? DeviceRooms.values.first;
  late DeviceType _type = widget.device?.type ?? DeviceType.light;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final draft = (name: _name.text.trim(), room: _room, type: _type);
    Navigator.pop(context, DeviceFormSaved(draft));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.device != null;
    final insets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + insets,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdit ? 'Редагувати пристрій' : 'Новий пристрій',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              key: const Key('deviceNameField'),
              label: 'Назва',
              icon: Icons.edit_outlined,
              controller: _name,
              validator: Validators.deviceName,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _room,
              decoration: const InputDecoration(labelText: 'Кімната'),
              items: [
                for (final room in DeviceRooms.values)
                  DropdownMenuItem(value: room, child: Text(room)),
              ],
              onChanged: (room) => setState(() => _room = room ?? _room),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<DeviceType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Тип'),
              items: [
                for (final type in DeviceType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (type) => setState(() => _type = type ?? _type),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Зберегти', onPressed: _save),
            if (isEdit)
              TextButton.icon(
                onPressed: () =>
                    Navigator.pop(context, const DeviceFormDeleted()),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Видалити пристрій'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
