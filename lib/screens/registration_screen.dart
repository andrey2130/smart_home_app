import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/routes/app_routes.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/app_text_field.dart';
import 'package:smart_home_app/widgets/auth_footer_link.dart';
import 'package:smart_home_app/widgets/auth_layout.dart';
import 'package:smart_home_app/widgets/primary_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  static const List<(String, IconData, TextInputType?, bool)> _fields = [
    ('Імʼя та прізвище', Icons.person_outline, TextInputType.name, false),
    ('Email', Icons.email_outlined, TextInputType.emailAddress, false),
    ('Пароль', Icons.lock_outline, null, true),
    ('Повторіть пароль', Icons.lock_reset, null, true),
  ];

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Створити акаунт',
      subtitle: 'Підключіть свій дім за кілька хвилин',
      footer: AuthFooterLink(
        text: 'Вже маєте акаунт?',
        actionLabel: 'Увійти',
        onPressed: () => context.pop(),
      ),
      children: [
        for (final (label, icon, keyboard, obscure) in _fields) ...[
          AppTextField(
            label: label,
            icon: icon,
            keyboardType: keyboard,
            obscureText: obscure,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Зареєструватися',
          onPressed: () => context.go(AppRoutes.main),
        ),
      ],
    );
  }
}
