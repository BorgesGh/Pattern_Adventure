import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:jogo_tabuleiro/game.dart';

class Pergunta extends GameComponent{


  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(BoardGame.tileSize, BoardGame.tileSize, BoardGame.tileSize, BoardGame.tileSize), Paint()..color = const Color(0xFF0000FF));
  }
}