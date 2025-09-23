import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'via_storage.dart';
import 'constants.dart';


class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({super.key});

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  String? _userId;
  List<String> _selectedForcas = [];
  DateTime? _updatedAt;
  bool _isLoading = true;

  final List<String> _todasAsForcas = [
    'Criatividade',
    'Curiosidade',
    'Julgamento',
    'Amor ao aprendizado',
    'Perspectiva',
    'Coragem',
    'Perseverança',
    'Honestidade',
    'Entusiasmo',
    'Amor',
    'Bondade',
    'Inteligência social',
    'Justiça',
    'Liderança',
    'Trabalho em equipe',
    'Perdão',
    'Modéstia',
    'Prudência',
    'Autorregulação',
    'Apreciação da beleza',
    'Gratidão',
    'Esperança',
    'Humor',
    'Espiritualidade',
  ];

  @override
  void initState() {
    super.initState();
    _carregarUsuarioEForcas();
  }

  Future<void> _carregarUsuarioEForcas() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(PrefKeys.loggedUser);
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final forcasSalvas = await ViaStorage.getTop5(userId);
    final updatedAt = await ViaStorage.getUpdatedAt(userId);

    setState(() {
      _userId = userId;
      _selectedForcas = forcasSalvas;
      _updatedAt = updatedAt;
      _isLoading = false;
    });
  }

  Future<void> _salvarForcas() async {
    if (_userId == null) return;
    await ViaStorage.setTop5(_userId!, _selectedForcas);
    final updatedAt = await ViaStorage.getUpdatedAt(_userId!);
    setState(() => _updatedAt = updatedAt);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forças salvas com sucesso!')),
    );
  }

  void _toggleForca(String forca) {
    setState(() {
      if (_selectedForcas.contains(forca)) {
        _selectedForcas.remove(forca);
      } else {
        if (_selectedForcas.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você só pode escolher 5 forças.'),
            ),
          );
        } else {
          _selectedForcas.add(forca);
        }
      }
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.loggedUser);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil do Usuário'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Perfil'),
              Tab(text: 'Minhas forças'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPerfilTab(),
            _buildForcasTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.account_circle, size: 40),
              const SizedBox(width: 12),
              Text(
                'ID do usuário:\n$_userId',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Forças selecionadas: ${_selectedForcas.length} de 5',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Última edição: ${_updatedAt != null ? _formatarData(_updatedAt!) : 'Nunca'}',
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForcasTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Escolha suas 5 principais forças:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: _todasAsForcas.map((forca) {
                final selecionada = _selectedForcas.contains(forca);
                return GestureDetector(
                  onTap: () => _toggleForca(forca),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selecionada
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selecionada
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        forca,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selecionada ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedForcas.length == 5 ? _salvarForcas : null,
            child: const Text('Salvar forças'),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    final y = data.year.toString();
    return '$d/$m/$y';
  }
}
