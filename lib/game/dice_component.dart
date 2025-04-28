import 'dart:math';
import 'package:flame/components.dart';

class DiceComponent extends SpriteComponent with HasGameRef {
  final Random _random = Random();
  int currentFace = 1;

  DiceComponent() : super(size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('dice_$currentFace.png');
  }

  Future<void> roll() async {
    currentFace = _random.nextInt(6) + 1;
    sprite = await Sprite.load('dice_$currentFace.png');
  }
}
