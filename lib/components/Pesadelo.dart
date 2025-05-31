

// import 'package:bonfire/bonfire.dart';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/npc/enemy/simple_enemy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/MapTile.dart';
import '../utils/CharacterSpriteSheet.dart';

class Pesadelo extends SimpleEnemy with PathFinding {

  late Image pesadeloFace;
  bool entrouEmContatoComOPlayer = false;

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

    if (!entrouEmContatoComOPlayer) {
      moveToPosition(gameRef.player!.position);
      seeAndMoveToPlayer(
        visionAngle: 80,
        runOnlyVisibleInScreen: false,
        closePlayer: (player) {
          entrouEmContatoComOPlayer = true; // Marca que já falou

          TalkDialog.show(
            gameRef.context,
            [
              Say(
                person: pesadeloFace,
                personSayDirection: PersonSayDirection.RIGHT,
                text: [
                  const TextSpan(
                    text: "Peguei!\n",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ],
          );
        },
        radiusVision: MapTile.tileSize * 30,
      );

      return;
    }




    // seeAndMoveToPlayer(// Fazer o Pesadelo correr atrás do jogado e quando tocar nele, executar algo
    //   visionAngle: 80,
    //   runOnlyVisibleInScreen: false,
    //
    //
    //   closePlayer: (player) {
    //     if(entrouEmContatoComOPlayer) return;
    //     entrouEmContatoComOPlayer = true;
    //
    //   },
    //   radiusVision: MapTile.tileSize * 30,
    // );
  }

}