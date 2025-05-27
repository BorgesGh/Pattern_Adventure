import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/mixins/sensor.dart';
import 'package:jogo_tabuleiro/components/Player.dart';

class TrocaMapaSensor extends GameComponent with Sensor {
  final VoidCallback onTrocaMapa;

  TrocaMapaSensor({
    required this.onTrocaMapa,
    required Vector2 position,
    required Vector2 size,
  });

  @override
  void onContact(GameComponent component) {
    if (component is Jogador) {
      onTrocaMapa();
    }
  }
}
