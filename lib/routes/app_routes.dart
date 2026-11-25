import 'package:go_router/go_router.dart';
import 'package:smart_home_app/screens/login_screen.dart';
import 'package:smart_home_app/screens/main_screen.dart';
import 'package:smart_home_app/screens/registration_screen.dart';
import 'package:smart_home_app/screens/user_profile_screen.dart';

abstract final class AppRoutes {
  static const String login = '/login';
  static const String registration = '/login/registration';
  static const String main = '/main';
  static const String profile = '/main/profile';

  static const List<String> all = [login, registration, main, profile];

  static GoRouter createRouter({String initialLocation = login}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: login,
          builder: (_, _) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'registration',
              builder: (_, _) => const RegistrationScreen(),
            ),
          ],
        ),
        GoRoute(
          path: main,
          builder: (_, _) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (_, _) => const UserProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
