import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class UserPrefs {
  UserPrefs._();

  static String userKey(String userId, String key) {
    return '${PrefKeys.kUserPrefix}$userId:$key';
  }

  static Future<String?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKeys.loggedUser);
  }

  static Future<void> setLoggedUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.loggedUser, userId);
  }

  static Future<void> setStringForUser(String userId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey(userId, key), value);
  }

  static Future<String?> getStringForUser(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey(userId, key));
  }

  static Future<void> setStringListForUser(String userId, String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(userKey(userId, key), value);
  }

  static Future<List<String>?> getStringListForUser(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(userKey(userId, key));
  }
}
