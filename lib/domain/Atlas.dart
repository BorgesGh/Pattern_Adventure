import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/Mapa.dart';
import 'package:jogo_tabuleiro/game.dart';

class Atlas {
  static final Atlas _instancia = Atlas._interno();

  late List<Mapa> mapas;
  late Mapa atual;

  factory Atlas() {
    return _instancia;
  }

  Atlas._interno() {
    carregarMapas();
    atual = mapas[0]; // Define o primeiro mapa como o atual
  }

  void carregarMapas() {
    mapas = [
      Mapa(
        caminhoDoArquivo: 'tiled/Mapa-Floresta.json',
        nomeMapa: 'Floresta',
        caminhoPrincipal: [
          // De (0, 12) até (9, 12)
          Vector2(0 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(1 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(2 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(3 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(4 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(5 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(6 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(7 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(8 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(9 * BoardGame.tileSize, 13 * BoardGame.tileSize),
          Vector2(10 * BoardGame.tileSize, 13 * BoardGame.tileSize),

          // De (9, 12) até (9, 9)
          Vector2(10 * BoardGame.tileSize, 12 * BoardGame.tileSize),
          Vector2(10 * BoardGame.tileSize, 11 * BoardGame.tileSize),
          Vector2(10 * BoardGame.tileSize, 10 * BoardGame.tileSize),

          // De (9, 9) até (20, 9)
          Vector2(10 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(11 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(12 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(13 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(14 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(15 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(16 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(17 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(18 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(19 * BoardGame.tileSize, 10 * BoardGame.tileSize),
          Vector2(20 * BoardGame.tileSize, 10 * BoardGame.tileSize),

          // De (20, 9) até (20, 7)
          Vector2(20 * BoardGame.tileSize, 9 * BoardGame.tileSize),
          Vector2(20 * BoardGame.tileSize, 8 * BoardGame.tileSize),

          // De (20, 7) até (25, 7)
          Vector2(21 * BoardGame.tileSize, 8 * BoardGame.tileSize),
          Vector2(22 * BoardGame.tileSize, 8 * BoardGame.tileSize),
          Vector2(23 * BoardGame.tileSize, 8 * BoardGame.tileSize),
          Vector2(24 * BoardGame.tileSize, 8 * BoardGame.tileSize),
          Vector2(25 * BoardGame.tileSize, 8 * BoardGame.tileSize),
        ],
      ),
    ];
  }
}
