import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../../domain/MapTile.dart';
import 'StatusDoJogador.dart';

class HudDoJogador extends GameComponent {
  final StatusDoJogador status;


  HudDoJogador(this.status);

  @override
  void render(Canvas canvas) {
    //TODO fazer fundo da informaçãos ou posicionar de acorodo com a tela para ficar fixo.
    TextPaint tp = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Arial',
      ),
    );

    tp.render(canvas, 'Vidas: ${status.vidas}', Vector2(1 * MapTile.tileSize, 6 * MapTile.tileSize));
    tp.render(canvas, 'Perguntas: ${status.perguntasAcertadas}/ ${status.perguntasTotais}',Vector2(1 * MapTile.tileSize, 5 * MapTile.tileSize));

    super.render(canvas);
  }
}
