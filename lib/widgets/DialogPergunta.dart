import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/Pergunta.dart';
class DialogPergunta extends StatefulWidget {
  final Pergunta pergunta;
  final void Function(bool acertou) onRespondido;
  final String texturaBotao;
  final String texturaDialog;

  const DialogPergunta({
    super.key,
    required this.pergunta,
    required this.onRespondido,
    required this.texturaBotao,
    required this.texturaDialog,
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
    Navigator.of(context).pop();
    widget.onRespondido(acertou);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.brown.shade700, width: 4),
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height:MediaQuery.of(context).size.height * 0.6,
            child: mostrarFeedback
                ? _buildFeedback()
                : _buildPergunta(),
          ),
        ),
      ),
    );
  }

  Widget _buildPergunta() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.pergunta.pergunta,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...List.generate(widget.pergunta.alternativas.length, (index) {
          return GestureDetector(
            onTap: () => responder(index),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.texturaBotao),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(widget.pergunta.alternativas[index],
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFeedback() {
    if (acertou) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("🎉 Você acertou!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: fecharFeedback,
            child: const Text("Próximo"),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("❌ Você errou!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 12),
          Text("Explicação: ${widget.pergunta.solucao}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: fecharFeedback,
            child: const Text("Entendi"),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

