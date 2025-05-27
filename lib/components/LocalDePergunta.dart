import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';

import '../domain/MapTile.dart';

class LocalDePergunta extends GameComponent {

  Color cor;
  Vector2 posicao;

  LocalDePergunta({required this.cor, required this.posicao});

  @override
  void onMount() {
    debugMode = true;
    super.onMount();
  }


  @override
  void render(Canvas canvas) {
    // canvas.drawRect(Rect.fromLTWH(MapTile.tileSize * posicao.x , MapTile.tileSize * posicao.y, MapTile.tileSize, MapTile.tileSize), Paint()..color = cor);
    canvas.drawCircle(posicao.toOffset(), MapTile.tileSize / 2, Paint()..color = cor.withOpacity(0.5));
  }

}