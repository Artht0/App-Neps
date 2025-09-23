import 'package:flutter/material.dart';

class PrefKeys {
  static const onboardingDone = 'onboardingDone';
  static const loggedUser = 'loggedUser';
  static const isDarkTheme = 'isDarkTheme';
  static const themeMode = 'themeMode';
  static const kUserPrefix = 'user_';
}

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const home = '/home';
  static const perfil = '/perfil';
}

class AppColors {
  static const primary = Color(0xFF00A9A5); // Verde água vibrante
  static const secondary = Color(0xFFFFCA3A); // Amarelo ensolarado
  static const background = Color(0xFFFFFDF6); // Creme claro
  static const surface = Color(0xFFFFFFFF); // Branco (cards, caixas)
  static const textPrimary = Color(0xFF333333); // Texto padrão
  static const textSecondary = Color(0xFF666666); // Texto secundário
  static const error = Color(0xFFFF595E); // Erros
  static const success = Color(0xFF8AC926); // Sucesso
}

ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    background: AppColors.background,
    surface: AppColors.surface,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
    ),
  );
}

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
  );
}
