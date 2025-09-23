import 'package:flutter/material.dart';

import 'perfil_usuario_page.dart';
import 'via_test_page.dart';
import 'perfis_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(
        title: 'Teste VIA',
        icon: Icons.psychology_alt_rounded,
        page: const ViaTestPage(),
        color: const Color(0xFFFDD835), // Amarelo ouro
      ),
      _MenuItem(
        title: 'Pais e Faixa Etária',
        icon: Icons.family_restroom_rounded,
        page: PaisFaixaEtariaPage(),
        color: const Color(0xFF4285F4), // Azul
      ),
      _MenuItem(
        title: 'Estudantes',
        icon: Icons.school_rounded,
        page: EstudantesPage(),
        color: const Color(0xFFFB8C00), // Laranja
      ),
      _MenuItem(
        title: 'Educadores',
        icon: Icons.menu_book_rounded,
        page: EducadoresPage(),
        color: const Color(0xFF43A047), // Verde
      ),
      _MenuItem(
        title: 'Curiosos',
        icon: Icons.lightbulb_rounded,
        page: CuriososPage(),
        color: const Color(0xFF8E24AA), // Roxo
      ),
      _MenuItem(
        title: 'Instituições',
        icon: Icons.apartment_rounded,
        page: InstituicoesPage(),
        color: const Color(0xFFE53935), // Vermelho
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Fundo areia suave
      body: SafeArea(
        child: Stack(
          children: [
            // Botão de perfil no canto superior direito
            Positioned(
              top: 12,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PerfilUsuarioPage()),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF388E3C), // Verde folha
                  radius: 22,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com ícone e título
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFF388E3C), size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Bem-vindo ao NEEP!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Escolha um dos perfis abaixo para começar sua jornada. Cada caminho traz conteúdos únicos para você explorar.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF444444)),
                  ),
                  const SizedBox(height: 20),

                  // Menu em grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.88, // Preenche mais vertical
                      children: items.map((item) => _HomeCard(item: item)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Widget page;
  final Color color;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.page,
    required this.color,
  });
}

class _HomeCard extends StatelessWidget {
  final _MenuItem item;

  const _HomeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => item.page),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 48, color: item.color),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: item.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
