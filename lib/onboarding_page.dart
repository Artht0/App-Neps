// lib/onboarding_page.dart
// Carrossel de introdução ao app – SEM gravar "visto"
part of app_main;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _current = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem('Bem-vindo',  'Descubra o poder da Psicologia Positiva.', Icons.emoji_people),
    _OnboardingItem('Curiosos',   'Explore temas fascinantes sobre o mundo.', Icons.lightbulb),
    _OnboardingItem('Estudantes', 'Melhore sua concentração e aprendizado.', Icons.school),
    _OnboardingItem('Pais',       'Dicas práticas para desenvolvimento infantil.', Icons.family_restroom),
    _OnboardingItem('Educadores','Ferramentas para engajar seus alunos.', Icons.auto_stories),
    _OnboardingItem('Instituições','Crie ambientes organizacionais saudáveis.', Icons.business),
  ];

  Future<void> _finish() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final item = _items[i];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 120, color: Colors.deepPurple),
                      const SizedBox(height: 32),
                      Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          item.text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                    (i) => Container(
                  margin: const EdgeInsets.all(6),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _current
                        ? Colors.deepPurple
                        : Colors.deepPurple.withOpacity(.3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _finish,
                child: const Text('Começar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String text;
  final IconData icon;
  const _OnboardingItem(this.title, this.text, this.icon);
}
