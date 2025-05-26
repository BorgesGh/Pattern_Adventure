import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/player.dart';
import 'package:flame/events.dart';

import 'game.dart';

class Jogador extends SimplePlayer with PathFinding {
  static var JogadorSize = Vector2.all(32);

  Jogador({required super.position, required super.size});

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      JogadorSize.x / 2,
      Paint()
        ..color = const Color(0xFF00FF00)
    );
    super.render(canvas);
  }

  @override
  void onMount() {
    debugMode = true;

    moveAlongThePath([
      Vector2(10 * BoardGame.tileSize, 15 * BoardGame.tileSize),
      Vector2(20 * BoardGame.tileSize, 15 * BoardGame.tileSize),
      Vector2(20 * BoardGame.tileSize, 10 * BoardGame.tileSize),
      Vector2(10 * BoardGame.tileSize, 10 * BoardGame.tileSize),
      Vector2(10 * BoardGame.tileSize, 15 * BoardGame.tileSize),
    ]);

    super.onMount();
  }

}