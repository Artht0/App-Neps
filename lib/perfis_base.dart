part of 'perfis_pages.dart';

/// Página para exibir textos longos (reaproveitada por todos os perfis)
class ConteudoDetalhadoPage extends StatelessWidget {
  final String titulo;
  final String conteudo;
  final Color cor;
  final String? videoUrl;

  const ConteudoDetalhadoPage({
    Key? key,
    required this.titulo,
    required this.conteudo,
    required this.cor,
    this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(titulo),
      backgroundColor: cor,
      centerTitle: true,
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          conteudo,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        if (videoUrl != null) ...[
          const SizedBox(height: 24),
          const Text(
            'Assista ao vídeo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
        ],
      ],
    ),
  );
}

/// Página "base" que os cinco perfis herdam, evitando repetição de UI
class PerfilBasePage extends StatelessWidget {
  final String titulo;
  final List<_MenuItem> menuItems;
  final Color cor;

  const PerfilBasePage({
    Key? key,
    required this.titulo,
    required this.menuItems,
    required this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(titulo),
      backgroundColor: cor,
      centerTitle: true,
    ),
    body: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (_, i) => ListTile(
        leading: Icon(menuItems[i].icone, color: cor),
        title: Text(menuItems[i].titulo),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => menuItems[i].page),
        ),
      ),
    ),
  );
}

class _MenuItem {
  final String titulo;
  final IconData icone;
  final Widget page;
  const _MenuItem(this.titulo, this.icone, this.page);
}