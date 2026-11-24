import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/data/mock_data.dart';
import 'package:smart_home_app/routes/app_routes.dart';
import 'package:smart_home_app/theme/app_spacing.dart';
import 'package:smart_home_app/widgets/primary_button.dart';
import 'package:smart_home_app/widgets/profile_header.dart';
import 'package:smart_home_app/widgets/responsive_center.dart';
import 'package:smart_home_app/widgets/settings_group.dart';
import 'package:smart_home_app/widgets/settings_tile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  static const double _wideBreakpoint = 720;

  @override
  Widget build(BuildContext context) {
    const user = MockData.user;

    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileHeader(user: user),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Редагувати профіль',
          icon: Icons.edit_outlined,
          onPressed: () {},
        ),
      ],
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroup(
          title: 'Особисті дані',
          children: [
            SettingsTile(
              icon: Icons.phone,
              title: 'Телефон',
              subtitle: user.phone,
            ),
            SettingsTile(
              icon: Icons.home_work,
              title: 'Адреса будинку',
              subtitle: user.address,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const SettingsGroup(
          title: 'Налаштування',
          children: [
            SettingsTile(icon: Icons.notifications, title: 'Сповіщення'),
            SettingsTile(icon: Icons.security, title: 'Безпека'),
            SettingsTile(icon: Icons.devices, title: 'Мої пристрої'),
          ],
        ),
      ],
    );

    final logout = PrimaryButton(
      label: 'Вийти',
      icon: Icons.logout,
      isDestructive: true,
      onPressed: () => context.go(AppRoutes.login),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ResponsiveCenter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _wideBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      summary,
                      const SizedBox(height: AppSpacing.xl),
                      details,
                      const SizedBox(height: AppSpacing.lg),
                      logout,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: summary),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          details,
                          const SizedBox(height: AppSpacing.lg),
                          logout,
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
