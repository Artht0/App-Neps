import 'package:flutter/material.dart';

import 'perfil_usuario_page.dart';
import 'perfis_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[

      _MenuItem(
        title: 'Pais',
        subtitle: 'Apoio para famílias',
        icon: Icons.family_restroom,
        color: Colors.orange,
        page: PaisFaixaEtariaPage(),
      ),

      _MenuItem(
        title: 'Estudantes',
        subtitle: 'Descubra seu potencial',
        icon: Icons.school,
        color: Colors.blue,
        page: EstudantesPage(),
      ),

      _MenuItem(
        title: 'Educadores',
        subtitle: 'Ferramentas e recursos',
        icon: Icons.menu_book,
        color: Colors.purple,
        page: EducadoresPage(),
      ),

      _MenuItem(
        title: 'Curiosos',
        subtitle: 'Aprenda mais sobre si',
        icon: Icons.lightbulb,
        color: Colors.green,
        page: CuriososPage(),
      ),

      _MenuItem(
        title: 'Instituições',
        subtitle: 'Gestão e aplicação',
        icon: Icons.apartment,
        color: Colors.redAccent,
        page: InstituicoesPage(),
      ),

      _MenuItem(
        title: 'Meu Perfil',
        subtitle: 'Gerencie sua conta',
        icon: Icons.person,
        color: Colors.cyan,
        page: const PerfilUsuarioPage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text(
          'NEPS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),

          itemBuilder: (context, index) {
            return _AnimatedMenuCard(item: items[index], index: index);
          },
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}

class _AnimatedMenuCard extends StatefulWidget {
  final _MenuItem item;
  final int index;

  const _AnimatedMenuCard({required this.item, required this.index});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = CurvedAnimation(parent: _controller, curve: Curves.decelerate);

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => widget.item.page),
            );
          },
          child: Card(
            elevation: 8, // 🔥 cards flutuantes
            shadowColor: widget.item.color.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: widget.item.color.withOpacity(0.15),
                    radius: 28,
                    child: Icon(
                      widget.item.icon,
                      color: widget.item.color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
