import 'package:smart_home_app/domain/entities/user.dart';

// Помилка бізнес-логіки авторизації з повідомленням для користувача.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

// Контракт авторизації. UI залежить лише від цієї абстракції,
// тож локальне сховище можна замінити на REST API без змін в екранах.
abstract interface class IAuthRepository {
  // Кидає [AuthException], якщо дані невалідні або email зайнятий.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  // Кидає [AuthException], якщо email або пароль невірні.
  Future<User> login({required String email, required String password});

  // Повертає користувача поточної сесії або null.
  Future<User?> getCurrentUser();

  // Оновлює імʼя, телефон та адресу. Кидає [AuthException],
  // якщо дані невалідні.
  Future<User> updateProfile(ProfileDraft draft);

  Future<void> logout();
}
