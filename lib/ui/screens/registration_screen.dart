import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/validators.dart';
import 'package:smart_home_app/ui/routes/app_routes.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/app_snack_bar.dart';
import 'package:smart_home_app/ui/widgets/app_text_field.dart';
import 'package:smart_home_app/ui/widgets/auth_footer_link.dart';
import 'package:smart_home_app/ui/widgets/auth_layout.dart';
import 'package:smart_home_app/ui/widgets/primary_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.authRepository.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (mounted) context.go(AppRoutes.main);
    } on AuthException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthLayout(
        title: 'Створити акаунт',
        subtitle: 'Підключіть свій дім за кілька хвилин',
        footer: AuthFooterLink(
          text: 'Вже маєте акаунт?',
          actionLabel: 'Увійти',
          onPressed: () => context.pop(),
        ),
        children: [
          AppTextField(
            key: const Key('regName'),
            label: 'Імʼя та прізвище',
            icon: Icons.person_outline,
            controller: _name,
            validator: Validators.name,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('regEmail'),
            label: 'Email',
            icon: Icons.email_outlined,
            controller: _email,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('regPassword'),
            label: 'Пароль',
            icon: Icons.lock_outline,
            controller: _password,
            validator: Validators.password,
            obscureText: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('regConfirm'),
            label: 'Повторіть пароль',
            icon: Icons.lock_reset,
            controller: _confirm,
            validator: (v) =>
                Validators.passwordConfirmation(v, _password.text),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Зареєструватися',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
