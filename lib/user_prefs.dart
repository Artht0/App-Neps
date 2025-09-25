import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class UserPrefs {
  UserPrefs._();

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static String _userPrefix(String userId) {
    return '${PrefKeys.kUserPrefix}$userId:';
  }

  static String _passHashKey(String userId) => '${_userPrefix(userId)}passwordHash';
  static String _saltKey(String userId) => '${_userPrefix(userId)}salt';

  /// Verifica se já existe cadastro
  static Future<bool> exists(String email) async {
    final prefs = await _prefs();
    final userId = normalizeEmail(email);
    return prefs.containsKey(_passHashKey(userId));
  }

  /// Cria um novo cadastro. Retorna false se já existir.
  static Future<bool> register(String email, String password) async {
    final prefs = await _prefs();
    final userId = normalizeEmail(email);

    if (await exists(email)) return false;

    // Gera sal aleatório
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);

    final ok1 = await prefs.setString(_saltKey(userId), salt);
    final ok2 = await prefs.setString(_passHashKey(userId), hash);

    return ok1 && ok2;
  }

  /// Valida login comparando hash
  static Future<bool> validateLogin(String email, String password) async {
    final prefs = await _prefs();
    final userId = normalizeEmail(email);

    final salt = prefs.getString(_saltKey(userId));
    final savedHash = prefs.getString(_passHashKey(userId));

    if (salt == null || savedHash == null) return false;

    final inputHash = _hashPassword(password, salt);
    return savedHash == inputHash;
  }

  static Future<void> setLoggedUser(String email) async {
    final prefs = await _prefs();
    final userId = normalizeEmail(email);
    await prefs.setString(PrefKeys.loggedUser, userId);
  }

  static Future<String?> getLoggedUser() async {
    final prefs = await _prefs();
    return prefs.getString(PrefKeys.loggedUser);
  }

  static Future<void> logout() async {
    final prefs = await _prefs();
    await prefs.remove(PrefKeys.loggedUser);
  }

  static String keyForUser(String userId, String key) {
    return '${_userPrefix(userId)}$key';
  }

  /// Helpers internos
  static String _generateSalt([int length = 16]) {
    final rand = Random.secure();
    final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }
}
