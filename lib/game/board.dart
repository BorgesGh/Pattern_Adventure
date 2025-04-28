import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/game/board_game.dart';
import 'package:jogo_tabuleiro/game/board_generate.dart';

class Board extends PositionComponent with HasGameRef<BoardGame> {
  final BoardGenerate boardService = BoardGenerate();

  Board() : super(size: Vector2(0, 0)) {
    // Define o tamanho do componente
    anchor = Anchor.center; // Define o ponto de ancoragem
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    debugMode = true;

    // Agora gera as posições dos quadrados
    boardService.generateSquarePositions(
        Vector2(0, 0), Vector2(game.size.x, game.size.y), 30.0, 5.0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    debugMode = true;

    final paint = Paint();
    const double tileSize = 30.0; // Tamanho dos quadrados
    const double padding = 5.0; // Padding entre os quadrados

    final List<Offset> squarePositions = boardService.getSquarePositions();

    // Desenhar os quadrados
    for (int i = 0; i < squarePositions.length; i++) {
      paint.color = getColorForTile(i);
      final rect = Rect.fromLTWH(
        squarePositions[i].dx,
        squarePositions[i].dy,
        tileSize,
        tileSize,
      );
      canvas.drawRect(rect, paint);
    }

    // Desenha a posição atual (círculo)
    final current = game.bloc.state.position;
    paint.color = Colors.black;
    final x = squarePositions[current].dx;
    final y = squarePositions[current].dy;
    canvas.drawCircle(Offset(x + tileSize / 2, y + tileSize / 2), 10, paint);
  }

  Color getColorForTile(int i) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
    return colors[i % colors.length];
  }
}
