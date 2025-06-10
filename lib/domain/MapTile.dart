import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/Pergunta.dart';

class MapTile{

  static const double tileSize = 32.0; // Tamanho do tile em pixels

  late Vector2 position;

  Pergunta? pergunta;

  MapTile({Vector2? position, this.pergunta}) {
    this.position = position ?? Vector2.zero();
  }

  List<Vector2> toVector2List() {
    return [position];
  }
}