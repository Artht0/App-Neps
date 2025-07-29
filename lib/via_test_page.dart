import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'strengths.dart'; // define a classe Strength e allStrengths
import 'constants.dart';

class ViaTestPage extends StatefulWidget {
  const ViaTestPage({super.key});

  @override
  State<ViaTestPage> createState() => _ViaTestPageState();
}

class _ViaTestPageState extends State<ViaTestPage> {
  final List<Strength> _selecionadas = [];
  Future<void> _salvarForcas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(PrefKeys.loggedUser) ?? 'anon';
    final nomes = _selecionadas.map((s) => s.nome).toList();

    await prefs.setStringList(PrefKeys.viaTop5(email), nomes);
    await prefs.setBool('via_test_done', false); // limpa a flag

    if (!mounted) return;
    Navigator.pop(context);
  }


  void _alternarSelecao(Strength forca) {
    setState(() {
      final jaSelecionada =
      _selecionadas.any((f) => f.nome == forca.nome);

      if (jaSelecionada) {
        _selecionadas.removeWhere((f) => f.nome == forca.nome);
      } else {
        if (_selecionadas.length < 5) {
          _selecionadas.add(forca);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Você só pode escolher 5 forças.')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha suas 5 forças'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Toque para selecionar suas 5 principais forças. '
                  'Essas informações ficarão salvas no seu perfil.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              childAspectRatio: 3.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: allStrengths.map((forca) {
                final selecionada = _selecionadas
                    .any((f) => f.nome == forca.nome);
                return GestureDetector(
                  onTap: () => _alternarSelecao(forca),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: selecionada
                          ? Colors.purple.withOpacity(.85)
                          : isDark
                          ? Colors.grey[900]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selecionada
                            ? Colors.purple
                            : Colors.grey.withOpacity(.4),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Center(
                      child: Text(
                        forca.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selecionada
                              ? Colors.white
                              : isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _selecionadas.length == 5 ? _salvarForcas : null,
              icon: const Icon(Icons.check),
              label: const Text('Salvar minhas forças'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          )
        ],
      ),
    );
  }
}
