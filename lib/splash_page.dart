import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'onboarding_page.dart';
import 'auth_page.dart';
import 'perfil_usuario_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      _checkNextRoute();
    });
  }

  Future<void> _checkNextRoute() async {
    final prefs = await SharedPreferences.getInstance();

    final onboardingDone = prefs.getBool(PrefKeys.onboardingDone) ?? false;
    final loggedUser = prefs.getString(PrefKeys.loggedUser) ?? '';

    Widget nextPage;
    if (!onboardingDone) {
      nextPage = const OnboardingPage();
    } else if (loggedUser.isEmpty) {
      nextPage = const AuthPage();
    } else {
      nextPage = const PerfilUsuarioPage(); // ou HomePage se preferir
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextPage),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔆 Logo circular com borda dourada
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary,
                      width: 4,
                    ),
                  ),
                  child: const Icon(
                    Icons.star,
                    size: 50,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 24),
                // 🔆 Título com shimmer fake
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.yellow.shade600,
                      Colors.orange.shade400,
                      Colors.yellow.shade600,
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'NEPS',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seu app de forças e perfis',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}