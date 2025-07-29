import 'package:flutter/material.dart';

/// Modelo da pergunta do quiz
class QuizQuestion {
  final String texto;
  final List<String> opcoes;
  final int indiceCorreta;
  final String feedbackCorreto;
  final String feedbackIncorreto;

  QuizQuestion({
    required this.texto,
    required this.opcoes,
    required this.indiceCorreta,
    this.feedbackCorreto = '✔️ Correto!',
    this.feedbackIncorreto = '❌ Incorreto.',
  });
}

/// Página do Quiz
class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String titulo;

  const QuizPage({super.key, required this.questions, required this.titulo});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  int score = 0;
  bool showResult = false;
  bool showFeedback = false;
  late List<int> _order;

  @override
  void initState() {
    super.initState();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    _order = List<int>.generate(
      widget.questions[currentQuestionIndex].opcoes.length,
          (i) => i,
    )..shuffle();
  }

  void _answer(int tap) {
    if (selectedOptionIndex != null) return;
    final original = _order[tap];

    setState(() {
      selectedOptionIndex = tap;
      showFeedback = true;
      if (original ==
          widget.questions[currentQuestionIndex].indiceCorreta) score++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        if (currentQuestionIndex + 1 < widget.questions.length) {
          currentQuestionIndex++;
          selectedOptionIndex = null;
          showFeedback = false;
          _prepareQuestion();
        } else {
          showResult = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBase = isDark ? Colors.grey.shade800 : Colors.white;
    final borderBase = Colors.grey.withOpacity(.4);
    final correctBg = Colors.green.withOpacity(.25);
    final wrongBg = Colors.red.withOpacity(.25);

    if (showResult) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.titulo)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Quiz finalizado!\nVocê acertou $score de ${widget.questions.length} perguntas.',
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final q = widget.questions[currentQuestionIndex];
    final answered = selectedOptionIndex != null;
    final isCorrect =
        answered && _order[selectedOptionIndex!] == q.indiceCorreta;

    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.questions.length,
            ),
            const SizedBox(height: 16),
            Text(
              'Pergunta ${currentQuestionIndex + 1} de ${widget.questions.length}',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(q.texto, style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),

            // alternativas
            ...List.generate(q.opcoes.length, (i) {
              final ori = _order[i];
              final option = q.opcoes[ori];
              Color bg = cardBase;
              if (answered) {
                if (i == selectedOptionIndex) {
                  bg = isCorrect ? correctBg : wrongBg;
                } else if (ori == q.indiceCorreta) {
                  bg = correctBg.withOpacity(.6);
                }
              }

              return Card(
                color: bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: answered && i == selectedOptionIndex
                        ? (isCorrect ? Colors.green : Colors.red)
                        : borderBase,
                  ),
                ),
                child: ListTile(
                  title: Text(option, style: theme.textTheme.bodyLarge),
                  onTap: answered ? null : () => _answer(i),
                ),
              );
            }),

            if (showFeedback && answered) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isCorrect ? q.feedbackCorreto : q.feedbackIncorreto,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Perguntas específicas para o perfil "Instituições"
final List<QuizQuestion> quizInstituicoes = [
  QuizQuestion(
    texto: 'Qual a principal função de uma instituição de ensino?',
    opcoes: [
      'Transmitir conhecimento',
      'Reprimir comportamento',
      'Promover desigualdade',
      'Impedir a criatividade'
    ],
    indiceCorreta: 0,
    feedbackCorreto: '✔️ Isso mesmo!',
    feedbackIncorreto: '❌ A resposta correta é: Transmitir conhecimento.',
  ),
  QuizQuestion(
    texto: 'Qual destas é uma instituição social?',
    opcoes: ['Escola', 'Floresta', 'Empresa privada', 'Montanha'],
    indiceCorreta: 0,
    feedbackCorreto: '✔️ Muito bem!',
    feedbackIncorreto: '❌ A resposta correta é: Escola.',
  ),
];

// Quizzes por perfil
final quizPais = [
  QuizQuestion(
    texto: 'Qual é a principal necessidade de uma criança entre 0 a 3 anos?',
    opcoes: ['Autonomia', 'Vínculo seguro', 'Disciplina', 'Autoestima'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! O vínculo seguro com os cuidadores é a base para todo o desenvolvimento.',
    feedbackIncorreto: '❌ Ainda não. Nessa fase, o vínculo afetivo é o mais importante.',
  ),
  QuizQuestion(
    texto: 'Brincar para uma criança pequena é:',
    opcoes: ['Perda de tempo', 'Uma forma de punição', 'A principal forma de aprender', 'Apenas diversão'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Isso mesmo! É por meio do brincar que a criança aprende e desenvolve habilidades cognitivas e sociais.',
    feedbackIncorreto: '❌ Na verdade, o brincar é essencial para o desenvolvimento infantil.',
  ),
  QuizQuestion(
    texto: 'O que ajuda no desenvolvimento da linguagem infantil?',
    opcoes: ['Deixar a criança sozinha com vídeos', 'Conversar e ler para ela frequentemente', 'Falar apenas o necessário', 'Usar palavras difíceis'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! A interação com adultos e a leitura estimulam a linguagem.',
    feedbackIncorreto: '❌ A linguagem se desenvolve com interação real e afeto.',
  ),
  QuizQuestion(
    texto: 'Qual atitude favorece a autorregulação emocional da criança?',
    opcoes: ['Ignorar quando ela chora', 'Gritar com ela', 'Ajudar a nomear e validar os sentimentos', 'Distrair com doces'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Muito bem! Validar sentimentos é essencial para o desenvolvimento emocional.',
    feedbackIncorreto: '❌ Nomear emoções e acolher é o melhor caminho para o equilíbrio emocional.',
  ),
  QuizQuestion(
    texto: 'O que significa “educar com presença”?',
    opcoes: ['Estar fisicamente perto sempre', 'Oferecer brinquedos caros', 'Estar atento, ouvindo e acolhendo ativamente', 'Corrigir a criança o tempo todo'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Perfeito! Presença de qualidade significa atenção genuína e disponibilidade emocional.',
    feedbackIncorreto: '❌ Educar com presença é mais do que estar por perto: é acolher com atenção e escuta.',
  ),
];


final quizEstudantes = [
  QuizQuestion(
    texto: 'Qual é a estratégia mais eficaz para fixar conteúdo na memória?',
    opcoes: ['Estudar tudo de uma vez', 'Revisar em intervalos espaçados', 'Ouvir música enquanto estuda', 'Ficar lendo sem parar'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! A repetição espaçada melhora a retenção a longo prazo.',
    feedbackIncorreto: '❌ Revisar aos poucos é mais eficaz do que estudar tudo de uma vez.',
  ),
  QuizQuestion(
    texto: 'Estudantes que usam mapas mentais conseguem:',
    opcoes: ['Desenhar melhor', 'Organizar ideias com mais clareza', 'Decorar mais rápido', 'Evitar escrever'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Muito bem! Mapas mentais ajudam na organização do pensamento e compreensão global.',
    feedbackIncorreto: '❌ A função dos mapas mentais é facilitar o raciocínio e a memória.',
  ),
  QuizQuestion(
    texto: 'Qual dessas atitudes ajuda na concentração?',
    opcoes: ['Estudar em qualquer lugar', 'Deixar o celular por perto', 'Fazer pausas programadas', 'Estudar com TV ligada'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Isso mesmo! Pausas ajudam o cérebro a manter o foco por mais tempo.',
    feedbackIncorreto: '❌ Pausas curtas e estratégicas são aliadas da concentração.',
  ),
  QuizQuestion(
    texto: 'Estabelecer metas de estudo realistas ajuda porque:',
    opcoes: ['Evita frustrações', 'Economiza tempo', 'Dispensa esforço', 'É uma formalidade'],
    indiceCorreta: 0,
    feedbackCorreto: '✔️ Exato! Metas alcançáveis mantêm a motivação e ajudam no progresso.',
    feedbackIncorreto: '❌ Sem metas reais, é mais fácil se frustrar ou desistir.',
  ),
  QuizQuestion(
    texto: 'Qual dessas opções ajuda na motivação nos estudos?',
    opcoes: ['Recompensas e sentido pessoal', 'Pressão e cobrança', 'Estudar só para a nota', 'Competição com colegas'],
    indiceCorreta: 0,
    feedbackCorreto: '✔️ Correto! O cérebro responde melhor a recompensas e propósito.',
    feedbackIncorreto: '❌ A motivação verdadeira vem de dentro, com propósito e reconhecimento.',
  ),
];


final quizCuriosos = [
  QuizQuestion(
    texto: 'O que é “curiosidade epistemológica”?',
    opcoes: ['Desejo de controlar o mundo', 'Vontade de conhecer verdades profundas', 'Medo de errar', 'Necessidade de ser aceito'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! É a vontade de aprender por prazer e entendimento.',
    feedbackIncorreto: '❌ Curiosidade epistemológica é o desejo genuíno de saber.',
  ),
  QuizQuestion(
    texto: 'O que a ciência diz sobre quem é curioso?',
    opcoes: ['Aprende menos', 'Erra mais', 'Lembra melhor do que aprende', 'Evita riscos'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Isso mesmo! A curiosidade ativa a memória de longo prazo.',
    feedbackIncorreto: '❌ A curiosidade aumenta retenção e envolvimento.',
  ),
  QuizQuestion(
    texto: 'Qual habilidade está ligada à curiosidade?',
    opcoes: ['Comunicação passiva', 'Pensamento crítico', 'Memorização mecânica', 'Obediência'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Muito bem! A curiosidade leva à investigação e análise.',
    feedbackIncorreto: '❌ Curiosos pensam, questionam e refletem.',
  ),
  QuizQuestion(
    texto: 'Para estimular sua curiosidade, você pode:',
    opcoes: ['Evitar temas difíceis', 'Aceitar respostas prontas', 'Fazer perguntas sobre o mundo', 'Focar só no que já sabe'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Excelente! A curiosidade cresce com boas perguntas.',
    feedbackIncorreto: '❌ Perguntar é o primeiro passo para descobrir algo novo.',
  ),
  QuizQuestion(
    texto: 'O cérebro curioso reage como?',
    opcoes: ['Ignora estímulos', 'Libera dopamina', 'Desliga o raciocínio', 'Fica apático'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! A dopamina é liberada quando sentimos prazer em aprender.',
    feedbackIncorreto: '❌ Curiosidade ativa áreas de prazer no cérebro.',
  ),
];


final quizEducadores = [
  QuizQuestion(
    texto: 'Avaliação formativa serve para:',
    opcoes: ['Medir nota final', 'Punir o erro', 'Acompanhar o progresso durante o processo', 'Corrigir provas'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Exatamente! É uma avaliação contínua que orienta a aprendizagem.',
    feedbackIncorreto: '❌ Avaliação formativa é um acompanhamento, não um julgamento.',
  ),
  QuizQuestion(
    texto: 'Mediação pedagógica significa:',
    opcoes: ['Interromper o aluno', 'Dar respostas prontas', 'Ajudar o aluno a construir o conhecimento', 'Ignorar dificuldades'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Isso mesmo! Mediar é facilitar o processo sem entregar tudo pronto.',
    feedbackIncorreto: '❌ O educador media, não entrega conhecimento fechado.',
  ),
  QuizQuestion(
    texto: 'A empatia em sala de aula ajuda a:',
    opcoes: ['Impor autoridade', 'Melhorar o clima escolar', 'Reduzir rendimento', 'Criar competição'],
    indiceCorreta: 1,
    feedbackCorreto: '✔️ Correto! Relações empáticas criam ambientes seguros para aprender.',
    feedbackIncorreto: '❌ A empatia favorece vínculos e aprendizagem.',
  ),
  QuizQuestion(
    texto: 'Qual prática é mais inclusiva?',
    opcoes: ['Ensino padronizado', 'Provas únicas', 'Atividades diversificadas e acessíveis', 'Foco só em conteúdo'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Exatamente! Inclusão requer diversidade de práticas.',
    feedbackIncorreto: '❌ Cada aluno aprende de forma diferente: o ensino também deve ser.',
  ),
  QuizQuestion(
    texto: 'O que é ensino significativo?',
    opcoes: ['Decorar conteúdos', 'Estudar para prova', 'Relacionar o conteúdo à vida do aluno', 'Ensinar apenas o que cai no vestibular'],
    indiceCorreta: 2,
    feedbackCorreto: '✔️ Muito bem! O conhecimento só faz sentido quando é útil para a vida.',
    feedbackIncorreto: '❌ Ensino significativo conecta teoria e realidade.',
  ),
];

