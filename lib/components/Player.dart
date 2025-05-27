import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/player.dart';
import 'package:flame/events.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';

import '../domain/Mapa.dart';
import '../game.dart';
import 'DialogPergunta.dart';

class Jogador extends SimplePlayer with PathFinding {
  static var JogadorSize = Vector2.all(MapTile.tileSize);

  Mapa mapa;
  List<int> indexDePerguntas = [];
  List<MapTile> caminho = [];

  Jogador({
    required super.position,
    required super.size,
    required this.mapa,
    required this.indexDePerguntas,
  }) {
    caminho = mapa.caminhoPrincipal; // atribui o caminho do mapa ao jogador
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      JogadorSize.x / 2,
      Paint()..color = const Color(0xFF00FF00),
    );
    super.render(canvas);
  }

  @override
  void onMount() {
    // debugMode = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (caminho.isNotEmpty) {
        _seguirCaminhoDefinido(caminho, indexDePerguntas);
      }
    });

    super.onMount();
  }

  Future<void> _seguirCaminhoDefinido(
      List<MapTile> caminho,
      List<int> indicesDeParada,
      ) async {
    const double velocidade = 50; // pixels por segundo
    const double intervalo = 0.016; // segundos (aprox. 60 FPS)

    for (int i = 0; i < caminho.length; i++) {
      final destino = caminho[i].position;

      while ((position - destino).length > 1.0) {
        final direcao = (destino - position).normalized();

        position += direcao * velocidade * intervalo;

        await Future.delayed(
          Duration(milliseconds: (intervalo * 1000).toInt()),
        );
      }

      // Corrige a posição final para evitar erros de aproximação
      position = destino;

      if (indicesDeParada.contains(i)) {
        print('Parado no ponto de pergunta $i: $destino');
        await Future.delayed(const Duration(seconds: 2));

        // Aqui você pode abrir uma pergunta, exibir algo, etc.
      }

      // Pequena pausa opcional entre os movimentos
      // await Future.delayed(const Duration(milliseconds: 300));
    }

    print("Caminho finalizado!");
  }
}
