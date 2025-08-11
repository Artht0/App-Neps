// lib/home_page.dart
import 'package:flutter/material.dart';
import 'perfis_pages.dart'; // garante que PaisFaixaEtariaPage, EstudantesPage etc. existam

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de perfis exibidos na grade
    final List<_Perfil> perfis = [
      _Perfil('Pais', Colors.purple, Icons.family_restroom, PaisFaixaEtariaPage()),
      _Perfil('Estudantes', Colors.red, Icons.school, EstudantesPage()),
      _Perfil('Educadores', Colors.green, Icons.auto_stories, EducadoresPage()),
      _Perfil('Curiosos', Colors.amber, Icons.lightbulb, CuriososPage()),
      _Perfil('Instituições', Colors.blue, Icons.apartment, InstituicoesPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEEP'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Meu Perfil',
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // rota já existente no projeto
              Navigator.pushNamed(context, '/perfil');
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // mantém o padrão 2×N
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: perfis.length,
        itemBuilder: (context, i) => _CardPerfil(item: perfis[i]),
      ),
    );
  }
}

/// Modelo simples para compor os cartões do grid
class _Perfil {
  final String titulo;
  final Color cor;
  final IconData icone;
  final Widget pagina;

  _Perfil(this.titulo, this.cor, this.icone, this.pagina);
}

/// Cartão visual de cada perfil (mantém o estilo do app)
class _CardPerfil extends StatelessWidget {
  final _Perfil item;
  const _CardPerfil({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => item.pagina),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: item.cor.withOpacity(.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icone, size: 44, color: item.cor),
            const SizedBox(height: 10),
            Text(
              item.titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: item.cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
