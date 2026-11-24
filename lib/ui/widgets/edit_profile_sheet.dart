import 'package:flutter/material.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/domain/validators.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/app_text_field.dart';
import 'package:smart_home_app/ui/widgets/primary_button.dart';

// Форма редагування профілю. Повертає нові дані або null, якщо закрито.
Future<ProfileDraft?> showEditProfileSheet(BuildContext context, User user) {
  return showModalBottomSheet<ProfileDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _EditProfileForm(user: user),
  );
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({required this.user});

  final User user;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.user.name);
  late final _phone = TextEditingController(text: widget.user.phone);
  late final _address = TextEditingController(text: widget.user.address);

  @override
  void dispose() {
    for (final c in [_name, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final ProfileDraft draft = (
      name: _name.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
    );
    Navigator.pop(context, draft);
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context).bottom;

    return SingleChildScrollView(
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
              'Редагувати профіль',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              key: const Key('profileName'),
              label: 'Імʼя та прізвище',
              icon: Icons.person_outline,
              controller: _name,
              validator: Validators.name,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              key: const Key('profilePhone'),
              label: 'Телефон (+380XXXXXXXXX)',
              icon: Icons.phone_outlined,
              controller: _phone,
              validator: Validators.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              key: const Key('profileAddress'),
              label: 'Адреса будинку',
              icon: Icons.home_work_outlined,
              controller: _address,
              validator: Validators.address,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Зберегти', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
