import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_controller.dart';
import 'constants.dart';

class PerfilUsuarioPage extends StatelessWidget {
  const PerfilUsuarioPage({super.key});

  Future<void> _logout(BuildContext ctx) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.loggedUser);
    await prefs.remove(PrefKeys.seenOnboarding);
    Navigator.of(ctx).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const cor = Colors.purple;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: cor,
        centerTitle: true,
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (_, snap) {
          final prefs  = snap.data;
          final email  = prefs?.getString(PrefKeys.loggedUser) ?? 'anon';
          final list   = prefs?.getStringList(PrefKeys.viaTop5(email)) ?? [];
          final nome   = prefs?.getString('nome') ?? 'Usuário';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.account_circle, size: 120, color: cor),
                      const SizedBox(height: 12),
                      Text(nome,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(email,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (list.isNotEmpty) ...[
                  const Text('Minhas 5 forças VIA:',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...list.map((f) => Text('• $f')),
                  const SizedBox(height: 32),
                ],
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.dark_mode),
                  label: const Text('Alternar tema'),
                  onPressed: ThemeController.instance.toggle,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
