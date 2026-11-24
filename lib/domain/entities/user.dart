// Авторизований користувач. Пароль сюди не потрапляє —
// він живе лише всередині сховища у вигляді хешу.
class User {
  const User({
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });

  final String name;
  final String email;

  // Необовʼязкові дані, які користувач додає в профілі.
  final String? phone;
  final String? address;

  String get initials => name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  String get firstName => name.split(' ').first;

  // Email незмінний, решта полів береться з форми профілю.
  User withProfile(ProfileDraft draft) => User(
    name: draft.name,
    email: email,
    phone: draft.phone,
    address: draft.address,
  );
}

// Дані з форми редагування профілю. null — поле не заповнене.
typedef ProfileDraft = ({String name, String? phone, String? address});
