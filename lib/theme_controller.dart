import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ThemeController {
  ThemeController._(this._prefs);

  final SharedPreferences _prefs;

  static Future<ThemeController> instance() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeController._(prefs);
  }

  String get currentModeString =>
      _prefs.getString(PrefKeys.themeMode) ?? 'system';

  ThemeMode get currentMode {
    switch (currentModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setModeString(String mode) async {
    await _prefs.setString(PrefKeys.themeMode, mode);
  }

  static ThemeMode parseMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
