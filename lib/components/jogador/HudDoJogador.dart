import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../../domain/MapTile.dart';
import 'StatusDoJogador.dart';

class HudDoJogador extends GameComponent {
  final StatusDoJogador status;


  HudDoJogador(this.status);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Acesso ao tamanho da tela
    final screenSize = gameRef.size;

    // Margens em relação à borda da tela
    const double marginLeft = 16;
    const double marginTop = 16;

    TextPaint tp = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Arial',
      ),
    );

    // Renderizar texto de vidas
    tp.render(
      canvas,
      'Vidas: ${status.vidas}',
      Vector2(marginLeft, marginTop),
    );

    // Renderizar texto de perguntas
    tp.render(
      canvas,
      'Perguntas: ${status.perguntasAcertadas}/${status.perguntasTotais}',
      Vector2(marginLeft, marginTop + 30), // 30 pixels abaixo
    );
  }
}
