//TODO Fazer a Dialog que tem a pegunta e as opções, além de paginação e etc.
import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:jogo_tabuleiro/domain/Pergunta.dart';

class Dialogpergunta extends GameComponent{

  late Pergunta pergunta;
  Dialogpergunta({required this.pergunta});

  @override
  void onMount() {

    TextComponent(
      text: pergunta.pergunta,
      position: Vector2.zero(),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );

    super.onMount();
  }

}