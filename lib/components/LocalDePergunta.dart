import 'dart:async';
import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/domain/Pergunta.dart';

import '../domain/MapTile.dart';

class LocalDePergunta extends SpriteComponent {

  Dificuldade dificuldade;
  Vector2 posicao;

  LocalDePergunta({required this.dificuldade, required this.posicao}) : super(
    priority: 1000,
    anchor: Anchor.center,
    position: posicao,
    size: Vector2.all(MapTile.tileSize),
  );


  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Molde Pergunta.png', srcSize: Vector2.all(MapTile.tileSize));
    return super.onLoad();
  }

  @override
  void onMount() {
    // debugMode = true;
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    // Desenha o círculo de fundo antes do sprite (fica por trás)
    canvas.drawCircle(
      (size / 2).toOffset(), // Centro relativo do componente
      MapTile.tileSize / 2,
      Paint()..color = _cor.withOpacity(0.5),
    );

    // Chama o render padrão do SpriteComponent (desenha o sprite)
    super.render(canvas);
  }

  Color get _cor {
    switch (dificuldade) {
      case Dificuldade.facil:
        return Colors.green;
      case Dificuldade.medio:
        return Colors.yellow;
      case Dificuldade.dificil:
        return Colors.red;
    }
  }

}