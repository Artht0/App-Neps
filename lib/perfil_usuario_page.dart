import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_controller.dart';
import 'constants.dart';

class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({super.key});

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  late SharedPreferences _prefs;
  String _email = 'anon';
  String _nome = 'Usuário';
  List<String> _forcas = [];
  String? _avatar;

  final List<String> _avatarsDisponiveis = [
    'avatar1.png',
    'avatar2.png',
    'avatar3.png',
    'avatar4.png',
    'avatar5.png',
    'avatar6.png',
    'avatar7.png',
    'avatar8.png',
    'avatar9.png',
    'avatar10.png',
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    _prefs = await SharedPreferences.getInstance();
    final email = _prefs.getString(PrefKeys.loggedUser) ?? 'anon';
    final nome = _prefs.getString('nome') ?? 'Usuário';
    final forcas = _prefs.getStringList(PrefKeys.viaTop5(email)) ?? [];
    final avatar = _prefs.getString('avatar');

    setState(() {
      _email = email;
      _nome = nome;
      _forcas = forcas;
      _avatar = avatar;
    });
  }

  Future<void> _editarNome() async {
    final controller = TextEditingController(text: _nome);
    final novoNome = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Salvar')),
        ],
      ),
    );
    if (novoNome != null && novoNome.isNotEmpty) {
      await _prefs.setString('nome', novoNome);
      setState(() => _nome = novoNome);
    }
  }

  Future<void> _escolherAvatar() async {
    final selecionado = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Escolha um avatar'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _avatarsDisponiveis.map((avatar) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, avatar),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/avatars/$avatar'),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (selecionado != null) {
      await _prefs.setString('avatar', selecionado);
      setState(() => _avatar = selecionado);
    }
  }

  Future<void> _logout() async {
    await _prefs.remove(PrefKeys.loggedUser);
    await _prefs.remove(PrefKeys.seenOnboarding);
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _escolherAvatar,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _avatar != null
                          ? AssetImage('assets/avatars/$_avatar') as ImageProvider
                          : null,
                      child: _avatar == null
                          ? const Icon(Icons.account_circle, size: 120, color: cor)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_nome, style: Theme.of(context).textTheme.headlineSmall),
                  Text(_email, style: Theme.of(context).textTheme.bodyMedium),
                  TextButton.icon(
                    onPressed: _editarNome,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar nome'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_forcas.isNotEmpty) ...[
              const Text('Minhas 5 forças VIA:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ..._forcas.map((f) => Text('• $f')),
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
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
