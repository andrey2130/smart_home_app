import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/data/local/prefs_auth_repository.dart';
import 'package:smart_home_app/data/local/prefs_device_repository.dart';
import 'package:smart_home_app/ui/routes/app_routes.dart';
import 'package:smart_home_app/ui/theme/app_theme.dart';

// Точка складання залежностей (composition root): лише тут
// вибираються конкретні реалізації репозиторіїв. Щоб перейти на
// REST API, достатньо підставити інші класи в цих двох рядках.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  const latency = Duration(milliseconds: 600);
  final authRepository = PrefsAuthRepository(prefs, latency: latency);
  final deviceRepository = PrefsDeviceRepository(prefs, latency: latency);

  // Якщо сесія збережена — одразу відкриваємо головний екран.
  final user = await authRepository.getCurrentUser();

  runApp(
    SmartHomeApp(
      router: AppRoutes.createRouter(
        authRepository: authRepository,
        deviceRepository: deviceRepository,
        initialLocation: user == null ? AppRoutes.login : AppRoutes.main,
      ),
    ),
  );
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Home',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
