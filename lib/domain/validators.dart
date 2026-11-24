// Бізнес-правила валідації. Кожен метод повертає текст помилки
// або null, якщо значення коректне (сумісно з TextFormField.validator).
abstract final class Validators {
  static final RegExp _email = RegExp(
    r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );
  static final RegExp _digit = RegExp(r'\d');
  static final RegExp _letter = RegExp(r'[A-Za-zА-Яа-яІіЇїЄєҐґ]');

  static const int minPasswordLength = 8;
  static final RegExp _phone = RegExp(r'^\+380\d{9}$');

  static const int maxDeviceNameLength = 30;
  static const int minAddressLength = 5;
  static const int maxAddressLength = 100;

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Введіть імʼя';
    if (name.length < 2) return 'Імʼя занадто коротке';
    if (_digit.hasMatch(name)) return 'Імʼя не може містити цифри';
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Введіть email';
    if (!_email.hasMatch(email)) return 'Email має містити @ та домен';
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.length < minPasswordLength) {
      return 'Пароль — мінімум $minPasswordLength символів';
    }
    if (!_digit.hasMatch(password) || !_letter.hasMatch(password)) {
      return 'Пароль має містити літери та цифри';
    }
    return null;
  }

  static String? passwordConfirmation(String? value, String password) {
    return value == password ? null : 'Паролі не збігаються';
  }

  // Телефон необовʼязковий, але якщо заповнений — лише +380XXXXXXXXX.
  // Пробіли, дефіси та дужки ігноруються.
  static String? phone(String? value) {
    final phone = normalizePhone(value);
    if (phone.isEmpty) return null;
    if (!_phone.hasMatch(phone)) return 'Телефон у форматі +380XXXXXXXXX';
    return null;
  }

  static String normalizePhone(String? value) =>
      (value ?? '').replaceAll(RegExp(r'[\s\-()]'), '');

  // Адреса необовʼязкова, але якщо заповнена — від 5 до 100 символів.
  static String? address(String? value) {
    final address = value?.trim() ?? '';
    if (address.isEmpty) return null;
    if (address.length < minAddressLength) return 'Адреса занадто коротка';
    if (address.length > maxAddressLength) {
      return 'Максимум $maxAddressLength символів';
    }
    return null;
  }

  // Для логіну перевіряємо лише, що поле не порожнє.
  static String? required(String? value) {
    return (value ?? '').isEmpty ? 'Обовʼязкове поле' : null;
  }

  static String? deviceName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Введіть назву пристрою';
    if (name.length > maxDeviceNameLength) {
      return 'Максимум $maxDeviceNameLength символів';
    }
    return null;
  }
}
