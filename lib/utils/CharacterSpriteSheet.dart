import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';

class CharacterSpriteSheet{
  final String path;
  CharacterSpriteSheet({required String fileName}) : path = 'character/$fileName';

  SimpleDirectionAnimation getAnimation(){
    return SimpleDirectionAnimation(
        idleRight: getIdleRight,
        runRight: getRunRight,

    );
  }

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
        amount: 3,
        stepTime: 0.5,
        textureSize: Vector2.all(MapTile.tileSize),
        texturePosition: Vector2(0,MapTile.tileSize + 5)
    ),
  );
}