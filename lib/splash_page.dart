// lib/splash_page.dart
// Sempre exibe o Onboarding ao abrir o app
part of app_main;

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Future<Widget> _next() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getString(PrefKeys.loggedUser) != null;

    // Sempre exibe o onboarding antes
    return const OnboardingPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _next(),
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snap.data!;
      },
    );
  }
}
