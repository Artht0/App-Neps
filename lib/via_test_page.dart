import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'via_storage.dart';

class ViaTestPage extends StatefulWidget {
  const ViaTestPage({super.key});

  @override
  State<ViaTestPage> createState() => _ViaTestPageState();
}

class _ViaTestPageState extends State<ViaTestPage> {
  final _ctrl = TextEditingController();
  String _userId = '';
  List<String> _top5 = <String>[];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(PrefKeys.loggedUser) ?? '';
    _userId = uid;
    if (uid.isNotEmpty) {
      _top5 = await ViaStorage.getTop5(uid);
    }
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (_userId.isEmpty) return;
    final parts = _ctrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length > 5) {
      _show('Informe no máximo 5 forças separadas por vírgula.');
      return;
    }
    await ViaStorage.setTop5(_userId, parts);
    _top5 = await ViaStorage.getTop5(_userId);
    if (mounted) setState(() {});
    _show('Salvo!');
  }

  void _show(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste VIA')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_userId.isEmpty)
              const Text('Nenhum usuário logado.')
            else ...[
              Text('Usuário: $_userId'),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  labelText: 'Digite suas forças (até 5), separadas por vírgula',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _save, child: const Text('Salvar top 5')),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _top5.isEmpty ? 'Sem forças salvas.' : 'Top 5: ${_top5.join(', ')}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
