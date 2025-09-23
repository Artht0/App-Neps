import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'splash_page.dart';
import 'onboarding_page.dart';
import 'auth_page.dart';
import 'perfil_usuario_page.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();

    final modeStr = prefs.getString(PrefKeys.themeMode);
    if (modeStr != null) {
      switch (modeStr) {
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        default:
          _themeMode.value = ThemeMode.system;
      }
    } else {
      final isDark = prefs.getBool(PrefKeys.isDarkTheme) ?? false;
      _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    final onboardingDone = prefs.getBool(PrefKeys.onboardingDone) ?? false;
    final loggedUser = prefs.getString(PrefKeys.loggedUser);

    if (!onboardingDone) {
      _initialRoute = AppRoutes.onboarding;
    } else if (loggedUser == null || loggedUser.isEmpty) {
      _initialRoute = AppRoutes.auth;
    } else {
      _initialRoute = AppRoutes.home;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return MaterialApp(
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: _themeMode.value,
        home: const SizedBox.shrink(),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,
          initialRoute: _initialRoute,
          routes: {
            AppRoutes.splash: (_) => const SplashPage(),
            AppRoutes.onboarding: (_) => const OnboardingPage(),
            AppRoutes.auth: (_) => const AuthPage(),
            AppRoutes.perfil: (_) => const PerfilUsuarioPage(),
            AppRoutes.home: (_) => const HomePage(), // ← ESSENCIAL
          },
        );
      },
    );
  }
}
