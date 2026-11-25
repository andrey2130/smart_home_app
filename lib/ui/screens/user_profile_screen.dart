import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/ui/routes/app_routes.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/app_snack_bar.dart';
import 'package:smart_home_app/ui/widgets/edit_profile_sheet.dart';
import 'package:smart_home_app/ui/widgets/primary_button.dart';
import 'package:smart_home_app/ui/widgets/profile_header.dart';
import 'package:smart_home_app/ui/widgets/responsive_center.dart';
import 'package:smart_home_app/ui/widgets/settings_group.dart';
import 'package:smart_home_app/ui/widgets/settings_tile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const double _wideBreakpoint = 720;
  static const String _notSet = 'Не вказано';

  User? _user;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    widget.authRepository.getCurrentUser().then((user) {
      if (mounted) setState(() => _user = user);
    });
  }

  Future<void> _editProfile(User user) async {
    final draft = await showEditProfileSheet(context, user);
    if (draft == null || !mounted) return;
    setState(() => _isSaving = true);
    try {
      final updated = await widget.authRepository.updateProfile(draft);
      if (!mounted) return;
      setState(() => _user = updated);
      showAppSnackBar(context, 'Профіль оновлено');
    } on AuthException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    await widget.authRepository.logout();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ResponsiveCenter(
                  child: LayoutBuilder(
                    builder: (context, constraints) => _buildLayout(
                      user,
                      isWide: constraints.maxWidth >= _wideBreakpoint,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLayout(User user, {required bool isWide}) {
    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeader(user: user),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Редагувати профіль',
          icon: Icons.edit_outlined,
          isLoading: _isSaving,
          onPressed: () => _editProfile(user),
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
              icon: Icons.person,
              title: 'Імʼя',
              subtitle: user.name,
            ),
            SettingsTile(
              icon: Icons.email,
              title: 'Email',
              subtitle: user.email,
            ),
            SettingsTile(
              icon: Icons.phone,
              title: 'Телефон',
              subtitle: user.phone ?? _notSet,
            ),
            SettingsTile(
              icon: Icons.home_work,
              title: 'Адреса будинку',
              subtitle: user.address ?? _notSet,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Вийти',
          icon: Icons.logout,
          isDestructive: true,
          onPressed: _logout,
        ),
      ],
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          summary,
          const SizedBox(height: AppSpacing.xl),
          details,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: summary),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 3, child: details),
      ],
    );
  }
}
