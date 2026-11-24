import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/validators.dart';

// Реалізація [IAuthRepository] на shared_preferences.
// Користувачі зберігаються як JSON:
// email -> {name, passwordHash, phone?, address?}.
// Пароль ніколи не зберігається у відкритому вигляді — лише SHA-256 хеш.
class PrefsAuthRepository implements IAuthRepository {
  const PrefsAuthRepository(this._prefs, {this.latency = Duration.zero});

  final SharedPreferences _prefs;

  // Штучна затримка, щоб на UI був помітний індикатор завантаження.
  final Duration latency;

  static const String _usersKey = 'auth.users';
  static const String _sessionKey = 'auth.session';

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    final error =
        Validators.name(name) ??
        Validators.email(email) ??
        Validators.password(password);
    if (error != null) throw AuthException(error);

    final key = _normalize(email);
    final users = _readUsers();
    if (users.containsKey(key)) {
      throw const AuthException('Користувач з таким email вже існує');
    }

    final user = User(name: name.trim(), email: key);
    users[key] = {'name': user.name, 'passwordHash': _hash(key, password)};
    await _writeUsers(users);
    await _prefs.setString(_sessionKey, key);
    return user;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(latency);
    final key = _normalize(email);
    final record = _readUsers()[key];
    if (record == null || record['passwordHash'] != _hash(key, password)) {
      throw const AuthException('Невірний email або пароль');
    }
    await _prefs.setString(_sessionKey, key);
    return _toUser(key, record);
  }

  @override
  Future<User?> getCurrentUser() async {
    final email = _prefs.getString(_sessionKey);
    final record = email == null ? null : _readUsers()[email];
    if (email == null || record == null) return null;
    return _toUser(email, record);
  }

  @override
  Future<User> updateProfile(ProfileDraft draft) async {
    await Future<void>.delayed(latency);
    final error =
        Validators.name(draft.name) ??
        Validators.phone(draft.phone) ??
        Validators.address(draft.address);
    if (error != null) throw AuthException(error);

    final user = await getCurrentUser();
    if (user == null) throw const AuthException('Сесія завершилась');

    final phone = Validators.normalizePhone(draft.phone);
    final address = draft.address?.trim() ?? '';
    final updated = user.withProfile((
      name: draft.name.trim(),
      phone: phone.isEmpty ? null : phone,
      address: address.isEmpty ? null : address,
    ));

    final users = _readUsers();
    users[user.email] = {
      ...?users[user.email],
      'name': updated.name,
      'phone': updated.phone,
      'address': updated.address,
    };
    await _writeUsers(users);
    return updated;
  }

  @override
  Future<void> logout() => _prefs.remove(_sessionKey);

  User _toUser(String email, Map<String, Object?> record) => User(
    name: record['name'] as String,
    email: email,
    phone: record['phone'] as String?,
    address: record['address'] as String?,
  );

  String _normalize(String email) => email.trim().toLowerCase();

  String _hash(String email, String password) =>
      sha256.convert(utf8.encode('$email:$password')).toString();

  Map<String, Map<String, Object?>> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (email, data) => MapEntry(email, Map<String, Object?>.from(data as Map)),
    );
  }

  Future<void> _writeUsers(Map<String, Map<String, Object?>> users) =>
      _prefs.setString(_usersKey, jsonEncode(users));
}
