

// import 'package:bonfire/bonfire.dart';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/npc/enemy/simple_enemy.dart';
import 'package:flutter/cupertino.dart';

import '../domain/MapTile.dart';
import '../utils/CharacterSpriteSheet.dart';

class Pesadelo extends SimpleEnemy with PathFinding, BlockMovementCollision {

  late Image pesadeloFace;

  Pesadelo({required super.position}) :super(
    size: Vector2.all(MapTile.tileSize),
    animation: CharacterSpriteSheet(fileName: 'pesadelo.png').getAnimation(),
    speed: 20
  );

  @override
  Future<void> onLoad() {
    pesadeloFace = CharacterSpriteSheet.getRostoPesadelo();

    return super.onLoad();
  }

  @override
  void onMount() {
    add(RectangleHitbox(
      size: Vector2.all(MapTile.tileSize),
      position: Vector2(0, 0),
    ));
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    seeAndMoveToPlayer( // Fazer o Pesadelo correr atrás do jogado e quando tocar nele, executar algo
      closePlayer: (player) {
        print("Peguei");
      },
      radiusVision: MapTile.tileSize * 10,
    );
  }

}