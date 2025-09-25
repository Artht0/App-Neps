import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'splash_page.dart';
import 'onboarding_page.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'perfil_usuario_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<ThemeMode> _themeModeNotifier =
  ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NEEP',
          theme: buildLightTheme(),
          themeMode: ThemeMode.light,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashPage(),
            AppRoutes.onboarding: (context) => const OnboardingPage(),
            AppRoutes.auth: (context) => const AuthShell(),
            AppRoutes.home: (context) => const HomePage(),
            AppRoutes.perfil: (context) => const PerfilUsuarioShell(),
          },
        );
      },
    );
  }
}

class AuthShell extends StatefulWidget {
  const AuthShell({super.key});

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  String? _loggedUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedUser = prefs.getString(PrefKeys.loggedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loggedUser == null ? const AuthPage() : const PerfilUsuarioShell();
  }
}

class PerfilUsuarioShell extends StatelessWidget {
  const PerfilUsuarioShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const PerfilUsuarioPage();
  }
}
