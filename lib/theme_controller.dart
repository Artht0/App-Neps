// lib/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();
  static final instance = ThemeController._();

  final isDark = ValueNotifier<bool>(false);

  Future<void> init(bool initial) async => isDark.value = initial;

  Future<void> toggle() async {
    isDark.value = !isDark.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', isDark.value);
  }
}
