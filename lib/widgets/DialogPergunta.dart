import 'dart:math' as math; // Importe a biblioteca math
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/Pergunta.dart'; // Certifique-se que o caminho está correto

class DialogPergunta extends StatefulWidget {
  final Pergunta pergunta;
  final void Function(bool acertou) onRespondido;

  const DialogPergunta({
    super.key,
    required this.pergunta,
    required this.onRespondido,
  });

  @override
  State<DialogPergunta> createState() => _DialogPerguntaState();
}

class _DialogPerguntaState extends State<DialogPergunta>
    with SingleTickerProviderStateMixin {
  bool respondeu = false;
  bool acertou = false;
  bool mostrarFeedback = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();
  }

  void responder(int index) {
    if (respondeu) return;

    setState(() {
      respondeu = true;
      acertou = index == widget.pergunta.indexSolucao;
      mostrarFeedback = true;
    });
  }

  void fecharFeedback() {
    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onRespondido(acertou);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // --- Lógica para responsividade do tamanho do diálogo ---
    // Percentuais para ocupar "quase toda a tela" em mobile
    const double mobileWidthPercentage = 0.90; // 90% da largura da tela
    const double mobileHeightPercentage = 0.80; // 80% da altura da tela (ajuste conforme necessário)

    // Tamanhos máximos para desktop
    const double desktopMaxWidth = 550.0;
    const double desktopMaxHeight = 700.0; // Ajustado para um bom tamanho de diálogo desktop

    // Calcula a largura desejada baseada na porcentagem da tela
    double desiredWidth = screenSize.width * mobileWidthPercentage;
    // Calcula a altura desejada baseada na porcentagem da tela
    double desiredHeight = screenSize.height * mobileHeightPercentage;

    // Aplica o tamanho máximo para desktop, sem exceder o tamanho da tela
    // Garante que a largura do diálogo não exceda desktopMaxWidth nem 95% da largura da tela
    double finalDialogWidth = math.min(desiredWidth, desktopMaxWidth);
    finalDialogWidth = math.min(finalDialogWidth, screenSize.width * 0.95); // Garante uma margem mínima

    // Garante que a altura do diálogo não exceda desktopMaxHeight nem 95% da altura da tela
    double finalDialogHeight = math.min(desiredHeight, desktopMaxHeight);
    finalDialogHeight = math.min(finalDialogHeight, screenSize.height * 0.95); // Garante uma margem mínima
    // --- Fim da lógica de responsividade do tamanho ---

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20), // Padding interno do diálogo
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            width: finalDialogWidth,   // Largura responsiva
            height: finalDialogHeight, // Altura responsiva
            child: mostrarFeedback ? _buildFeedback() : _buildPergunta(),
          ),
        ),
      ),
    );
  }

  Widget _buildPergunta() {
    return Column(
      // mainAxisSize: MainAxisSize.min, // Removido para permitir que Expanded funcione corretamente
      children: [
        Expanded(
          flex: 2, // Ajuste o flex para dar mais ou menos espaço para a pergunta
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8.0), // Espaço para não colar no grid
            child: Text(
              widget.pergunta.pergunta,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18, // Ajuste o tamanho da fonte se necessário
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12), // Espaçamento reduzido ligeiramente
        Expanded(
          flex: 3, // Ajuste o flex para dar mais ou menos espaço para as alternativas
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height > 0.6)
                ? 2.8 // Aspect ratio para telas mais largas (desktop-like) ou paisagem
                : 2.2, // Aspect ratio para telas mais estreitas (mobile retrato) - ajuste conforme o visual
            // physics: const NeverScrollableScrollPhysics(), // Pode ser necessário se o conteúdo do GridView for maior que o espaço
            shrinkWrap: true, // Adicionado para garantir que o GridView não tente ser infinito
            children:
            List.generate(widget.pergunta.alternativas.length, (index) {
              return GestureDetector(
                onTap: () => responder(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: respondeu
                          ? (index == widget.pergunta.indexSolucao
                              ? Colors.green.shade700
                              : Colors.red.shade700)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.pergunta.alternativas[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14, // Ajuste o tamanho da fonte se necessário
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    final bool isCorrect = acertou;
    final String feedbackMessage = isCorrect ? "🎉 Você acertou!" : "❌ Você errou!";
    final Color feedbackColor = isCorrect ? Colors.green.shade700 : Colors.red.shade700;
    final String buttonText = isCorrect ? "Próximo" : "Entendi";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch, // Para o botão ocupar a largura
      children: [
        Text(
          feedbackMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, // Ajuste o tamanho da fonte se necessário
              fontWeight: FontWeight.bold,
              color: feedbackColor),
        ),
        const SizedBox(height: 16),
        if (!isCorrect) ...[
          Flexible( // Adicionado Flexible para o texto da explicação
            child: SingleChildScrollView( // Permite rolagem se a explicação for longa
              child: Text(
                "Explicação: ${widget.pergunta.solucao}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? Colors.green : Colors.blueGrey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          onPressed: fecharFeedback,
          child: Text(buttonText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}