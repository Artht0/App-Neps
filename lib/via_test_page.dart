import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'strengths.dart'; // lista allStrengths
import 'constants.dart'; // define PrefKeys

class ViaTestPage extends StatefulWidget {
  const ViaTestPage({super.key});

  @override
  State<ViaTestPage> createState() => _ViaTestPageState();
}

class _ViaTestPageState extends State<ViaTestPage> {
  final List<Strength> _selecionadas = [];

  /// Alterna a seleção de uma força (adiciona ou remove)
  void _alternarSelecao(Strength forca) {
    setState(() {
      final jaSelecionada = _selecionadas.any((f) => f.nome == forca.nome);

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

  /// Salva as forças selecionadas localmente por usuário logado
  Future<void> _salvarForcas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(PrefKeys.loggedUser) ?? 'anon';
    final nomes = _selecionadas.map((s) => s.nome).toList();

    await prefs.setStringList(PrefKeys.viaTop5(email), nomes);
    await prefs.setBool('via_test_done', false); // limpa flag para reprocessar

    if (!mounted) return;
    Navigator.pop(context); // volta para a tela anterior
  }

  /// Abre o site oficial do Teste VIA em navegador externo
  Future<void> _abrirSiteVia() async {
    final url = Uri.parse('https://www.viacharacter.org/survey/account/register');

    final canOpen = await canLaunchUrl(url);
    if (!canOpen) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível verificar o navegador.')),
      );
      return;
    }

    final success = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o site no navegador.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha suas 5 forças'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Você pode visitar o site oficial ou selecionar manualmente suas 5 principais forças pessoais abaixo:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Botão para abrir o site do VIA
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: _abrirSiteVia,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Fazer Teste Oficial no Site'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          // Grid com as 24 forças para seleção manual
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3,
              padding: const EdgeInsets.all(12),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: allStrengths.map((forca) {
                final selecionado = _selecionadas.contains(forca);

                return GestureDetector(
                  onTap: () => _alternarSelecao(forca),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selecionado ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      forca.nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selecionado ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Botão para salvar as escolhas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: _selecionadas.length == 5 ? _salvarForcas : null,
              child: const Text('Salvar escolhas'),
            ),
          ),
        ],
      ),
    );
  }
}
