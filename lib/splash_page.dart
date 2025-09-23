import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _timer = Timer(const Duration(milliseconds: 1800), _decideRoute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _decideRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(PrefKeys.onboardingDone) ?? false;
    final loggedUser = prefs.getString(PrefKeys.loggedUser);

    debugPrint('[Splash] onboardingDone: $onboardingDone');
    debugPrint('[Splash] loggedUser: $loggedUser');

    String route;

    if (!onboardingDone) {
      route = AppRoutes.onboarding;
    } else if (loggedUser == null || loggedUser.isEmpty) {
      route = AppRoutes.auth;
    } else {
      route = AppRoutes.home;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorPrimary = theme.colorScheme.primary;
    final colorSecondary = theme.colorScheme.secondary;

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _anim, curve: Curves.easeIn),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 3),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorPrimary.withOpacity(0.15),
                        colorPrimary.withOpacity(0.35)
                      ],
                    ),
                  ),
                  child: const Icon(Icons.explore_rounded, size: 64),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) {
                    final t = _anim.value;
                    return ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment(-1 + t * 2, 0),
                          end: Alignment(1 + t * 2, 0),
                          colors: [
                            colorSecondary.withOpacity(0.2),
                            colorSecondary,
                            colorSecondary.withOpacity(0.2),
                          ],
                          stops: const [0.2, 0.5, 0.8],
                        ).createShader(rect);
                      },
                      child: Text(
                        'NEPS',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Seu app de forças e perfis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
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
