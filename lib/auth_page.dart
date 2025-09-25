import 'package:flutter/material.dart';
import 'constants.dart';
import 'user_prefs.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regPass2Ctrl = TextEditingController();

  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regPass2Ctrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final pass = _loginPassCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _showSnack('Preencha e-mail e senha.');
      return;
    }

    setState(() => _isBusy = true);
    try {
      final ok = await UserPrefs.validateLogin(email, pass);
      if (!ok) {
        _showSnack('E-mail ou senha inválidos.');
        return;
      }

      await UserPrefs.setLoggedUser(email);
      if (!mounted) return;

      _showSnack('Bem-vindo!');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _handleRegister() async {
    final email = _regEmailCtrl.text.trim();
    final pass = _regPassCtrl.text;
    final pass2 = _regPass2Ctrl.text;

    if (email.isEmpty || pass.isEmpty || pass2.isEmpty) {
      _showSnack('Preencha todos os campos.');
      return;
    }
    if (pass.length < 4) {
      _showSnack('A senha deve ter pelo menos 4 caracteres.');
      return;
    }
    if (pass != pass2) {
      _showSnack('As senhas não conferem.');
      return;
    }

    setState(() => _isBusy = true);
    try {
      final already = await UserPrefs.exists(email);
      if (already) {
        _showSnack('Este e-mail já está cadastrado.');
        return;
      }

      final ok = await UserPrefs.register(email, pass);
      if (!ok) {
        _showSnack('Falha ao registrar. Tente novamente.');
        return;
      }

      await UserPrefs.setLoggedUser(email);
      if (!mounted) return;

      _showSnack('Cadastro concluído!');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Autenticação'),
        bottom: TabBar(
          controller: _tabController, // ✅ agora tem controller
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Cadastro'),
          ],
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isBusy,
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController, // ✅ agora também aqui
              children: [
                _buildLoginTab(),
                _buildRegisterTab(),
              ],
            ),
            if (_isBusy)
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: LinearProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _loginEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _loginPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Entrar'),
              onPressed: _handleLogin,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _regEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regPass2Ctrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar senha',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.app_registration),
              label: const Text('Cadastrar'),
              onPressed: _handleRegister,
            ),
          ),
        ],
      ),
    );
  }
}
