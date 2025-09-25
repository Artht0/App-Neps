import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_prefs.dart';

class ViaStorage {
  ViaStorage._();

  static const String _kTop5 = 'via_top5';
  static const String _kUpdatedAt = 'via_updatedAt';

  static Future<List<String>> getTop5(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(UserPrefs.keyForUser(userId, _kTop5));
    if (raw == null || raw.isEmpty) return <String>[];
    try {
      return (json.decode(raw) as List).cast<String>();
    } catch (_) {
      return <String>[];
    }
  }

  static Future<void> setTop5(String userId, List<String> strengths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserPrefs.keyForUser(userId, _kTop5), json.encode(strengths));
    await prefs.setString(
      UserPrefs.keyForUser(userId, _kUpdatedAt),
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  static Future<DateTime?> getUpdatedAt(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(UserPrefs.keyForUser(userId, _kUpdatedAt));
    return s == null ? null : DateTime.tryParse(s);
  }
}
