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

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.authRepository.login(
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
        title: 'Smart Home',
        subtitle: 'Увійдіть, щоб керувати своїм домом',
        footer: AuthFooterLink(
          text: 'Немає акаунта?',
          actionLabel: 'Зареєструватися',
          onPressed: () => context.go(AppRoutes.registration),
        ),
        children: [
          AppTextField(
            key: const Key('loginEmail'),
            label: 'Email',
            icon: Icons.email_outlined,
            controller: _email,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('loginPassword'),
            label: 'Пароль',
            icon: Icons.lock_outline,
            controller: _password,
            validator: Validators.required,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Увійти',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
