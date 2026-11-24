import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/routes/app_routes.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/app_text_field.dart';
import 'package:smart_home_app/widgets/auth_footer_link.dart';
import 'package:smart_home_app/widgets/auth_layout.dart';
import 'package:smart_home_app/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Smart Home',
      subtitle: 'Увійдіть, щоб керувати своїм домом',
      footer: AuthFooterLink(
        text: 'Немає акаунта?',
        actionLabel: 'Зареєструватися',
        onPressed: () => context.go(AppRoutes.registration),
      ),
      children: [
        const AppTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Забули пароль?'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Увійти',
          onPressed: () => context.go(AppRoutes.main),
        ),
      ],
    );
  }
}
