import 'package:flutter/material.dart';
import 'quiz_models.dart';

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> perguntas;
  final Color cor;
  final String titulo;

  const QuizPage({
    Key? key,
    required this.perguntas,
    required this.cor,
    required this.titulo,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int perguntaAtual = 0;
  int? respostaSelecionada;
  bool respondido = false;

  @override
  Widget build(BuildContext context) {
    final pergunta = widget.perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.cor,
        title: Text(widget.titulo),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pergunta ${perguntaAtual + 1} de ${widget.perguntas.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              pergunta.texto,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            for (int i = 0; i < pergunta.opcoes.length; i++)
              ListTile(
                title: Text(pergunta.opcoes[i]),
                leading: Radio<int>(
                  value: i,
                  groupValue: respostaSelecionada,
                  onChanged: respondido
                      ? null
                      : (valor) => setState(() {
                    respostaSelecionada = valor;
                  }),
                ),
              ),
            const SizedBox(height: 24),
            if (respondido)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    respostaSelecionada == pergunta.indiceCorreta
                        ? pergunta.feedbackCorreto
                        : pergunta.feedbackIncorreto,
                    style: TextStyle(
                      fontSize: 16,
                      color: respostaSelecionada == pergunta.indiceCorreta
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _proximaPergunta,
                    child: const Text('Próxima'),
                  )
                ],
              )
            else
              ElevatedButton(
                onPressed: respostaSelecionada != null ? _responder : null,
                child: const Text('Confirmar'),
              )
          ],
        ),
      ),
    );
  }

  void _responder() {
    setState(() {
      respondido = true;
    });
  }

  void _proximaPergunta() {
    if (perguntaAtual + 1 < widget.perguntas.length) {
      setState(() {
        perguntaAtual++;
        respostaSelecionada = null;
        respondido = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Fim do quiz!'),
          content: const Text('Parabéns por concluir o quiz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fecha diálogo
                Navigator.pop(context); // volta para tela anterior
              },
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }
}
