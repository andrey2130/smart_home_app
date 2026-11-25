import 'package:go_router/go_router.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/repositories/device_repository.dart';
import 'package:smart_home_app/ui/screens/login_screen.dart';
import 'package:smart_home_app/ui/screens/main_screen.dart';
import 'package:smart_home_app/ui/screens/registration_screen.dart';
import 'package:smart_home_app/ui/screens/user_profile_screen.dart';

abstract final class AppRoutes {
  static const String login = '/login';
  static const String registration = '/login/registration';
  static const String main = '/main';
  static const String profile = '/main/profile';

  static const List<String> all = [login, registration, main, profile];

  static GoRouter createRouter({
    required IAuthRepository authRepository,
    required IDeviceRepository deviceRepository,
    String initialLocation = login,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: login,
          builder: (_, _) => LoginScreen(authRepository: authRepository),
          routes: [
            GoRoute(
              path: 'registration',
              builder: (_, _) =>
                  RegistrationScreen(authRepository: authRepository),
            ),
          ],
        ),
        GoRoute(
          path: main,
          builder: (_, _) => MainScreen(
            authRepository: authRepository,
            deviceRepository: deviceRepository,
          ),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (_, _) =>
                  UserProfileScreen(authRepository: authRepository),
            ),
          ],
        ),
      ],
    );
  }
}
