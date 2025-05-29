import 'dart:async';
import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/domain/Pergunta.dart';

import '../domain/MapTile.dart';

class LocalDePergunta extends GameComponent with Sensor<Player> {
  final Dificuldade dificuldade;
  final Vector2 posicao;
  late SpriteComponent _spriteComponent;

  LocalDePergunta({
    required this.dificuldade,
    required this.posicao,
  }) {
    priority = 1000;
    anchor = Anchor.center;
    position = posicao;
    size = Vector2.all(MapTile.tileSize);
  }

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(
      'Molde Pergunta.png',
      srcSize: Vector2.all(MapTile.tileSize),
    );

    _spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
    );

    add(_spriteComponent); // Adiciona corretamente ao corpo do GameComponent

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Fundo colorido de acordo com a dificuldade
    canvas.drawCircle(
      (size / 2).toOffset(),
      size.x / 2,
      Paint()..color = _cor.withOpacity(0.5),
    );

    super.render(canvas);
  }

  @override
  void onContact(Player component) {
    // Ação quando o jogador entra no local
    debugPrint("Jogador entrou em uma pergunta de dificuldade ${dificuldade.name}");
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
