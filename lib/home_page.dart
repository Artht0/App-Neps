// lib/home_page.dart
// TelaInicial com escolha de perfil.
part of app_main;

class TelaInicial extends StatelessWidget {
  TelaInicial({super.key});

  final List<_Perfil> perfis = [
    _Perfil('Pais',          Colors.purple, Icons.family_restroom, PaisFaixaEtariaPage()),
    _Perfil('Estudantes',    Colors.red,    Icons.school,          EstudantesPage()),
    _Perfil('Educadores',    Colors.green,  Icons.auto_stories,    EducadoresPage()),
    _Perfil('Curiosos',      Colors.amber,  Icons.lightbulb,       CuriososPage()),
    _Perfil('Instituições',  Colors.blue,   Icons.business,        InstituicoesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha seu perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Meu Perfil',
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        children: perfis
            .map((p) => _CardPerfil(perfil: p))
            .toList(),
      ),
    );
  }
}

class _Perfil {
  final String titulo;
  final Color cor;
  final IconData icone;
  final Widget page;
  _Perfil(this.titulo, this.cor, this.icone, this.page);
}

class _CardPerfil extends StatelessWidget {
  final _Perfil perfil;
  const _CardPerfil({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => perfil.page),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: perfil.cor.withOpacity(.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(perfil.icone, size: 48, color: perfil.cor),
            const SizedBox(height: 12),
            Text(perfil.titulo,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: perfil.cor)),
          ],
        ),
      ),
    );
  }
}
