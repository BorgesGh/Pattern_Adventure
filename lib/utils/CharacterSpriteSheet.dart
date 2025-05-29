import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';

class CharacterSpriteSheet{
  final String path;
  CharacterSpriteSheet({required String fileName}) : path = 'character/$fileName';

  SimpleDirectionAnimation getAnimation(){
    return SimpleDirectionAnimation(
        idleRight: getIdleRight,
        runRight: getRunRight,
        runUp: getRunUp,
        idleUp: getIdleUp,
        runDown: getRunDown,
        idleDown: getIdleDown

    );
  }

  //Movimentos para a: DIREITA (Não é obrigatório fazer para a esquerda, pois a Engine espelha o movimento para a direita)
  Future<SpriteAnimation> get getRunRight => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.2,
      textureSize: Vector2.all(MapTile.tileSize),
      texturePosition: Vector2(0, (MapTile.tileSize * 1) + 5),
    ),
  );
  Future<SpriteAnimation> get getIdleRight => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.5,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(MapTile.tileSize,MapTile.tileSize + 5)
    ),
  );

  //Movimentos para: CIMA
  Future<SpriteAnimation> get getIdleUp => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.5,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(MapTile.tileSize,MapTile.tileSize + 5)
    ),
  );
  Future<SpriteAnimation> get getRunUp => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(0,3)
    ),
  );

  //Movimentos para: BAIXO
  Future<SpriteAnimation> get getIdleDown => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.5,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(MapTile.tileSize,(2 * MapTile.tileSize) + 10)
    ),
  );

  Future<SpriteAnimation> get getRunDown => SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(0, (2 * MapTile.tileSize) + 11)
    ),
  );



  static Image getRostoNeutro() {
    return Image.asset('assets/images/character/player-neutro.png',height: 100);
  }
  static Image getRostoFeliz() {
    return Image.asset('assets/images/character/player-feliz.png',height: 100);
  }
  static Image getRostoTriste() {
    return Image.asset('assets/images/character/player-triste.png',height: 100);
  }
}