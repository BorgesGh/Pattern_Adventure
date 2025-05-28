import 'dart:async';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/player.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/HudDoJogador.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';

import '../domain/Mapa.dart';
import '../game.dart';
import '../utils/CharacterSpriteSheet.dart';
import '../widgets/DialogPergunta.dart';
import 'StatusDoJogador.dart';

class Jogador extends SimplePlayer with PathFinding {
  static var JogadorSize = Vector2.all(MapTile.tileSize);

  Mapa mapa;
  List<int> indexDePerguntas = [];
  List<MapTile> caminho = [];
  StatusDoJogador statusDoJogador;

  Jogador({
    required Vector2 position,
    required super.size,
    required this.mapa,
    required this.indexDePerguntas,
    required this.statusDoJogador,

  }) : super(
    animation: CharacterSpriteSheet(fileName: 'player.png').getAnimation(),
    speed: 40,
    position: Vector2(position.x - MapTile.tileSize / 2, position.y - MapTile.tileSize / 2),
  ) {
    caminho = mapa.caminhoPrincipal; // atribui o caminho do mapa ao jogador
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

    // TalkDialog.show(context,
    //     [
    //       Say(text: [
    //         const TextSpan(
    //           text: "Que parada ein meu nobre aventureiro!\n",
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //       ] )
    //     ],
    // );

    for (int i = 0; i < caminho.length; i++) {
      final destino = Vector2(caminho[i].position.x - MapTile.tileSize / 2, caminho[i].position.y - MapTile.tileSize / 2) ;
      final pergunta = caminho[i].pergunta;


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
        print("Parado no ponto de pergunta ${i} em $destino");

        // Espera a resposta da pergunta antes de continuar
        final completer = Completer<void>();

        await showDialog(
          context: gameRef.context, // <- você precisa ter acesso a esse contexto!
          barrierDismissible: false,
          builder: (context) {
            return DialogPergunta(
              pergunta: pergunta!, // <- instância da classe Pergunta
              texturaBotao: 'assets/images/back-madeira.jpg',
              texturaDialog: 'backgrounds/caixa_dialogo_madeira.png',
              onRespondido: (bool acertou) {
                // Você pode lidar com o resultado aqui
                if (acertou) {
                  statusDoJogador.acertouPergunta();
                } else {
                  statusDoJogador.errouPergunta();
                }
                 completer.complete();
              },
            );
          },
        );

        await completer.future; // Espera até o jogador responder
      }

      // Pequena pausa opcional entre os movimentos
      // await Future.delayed(const Duration(milliseconds: 300));
    }

    print("Caminho finalizado!");
    MapNavigator.of(context).toNamed('/mapa-agua'); // Muda para o próximo mapa após completar o caminho
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawCircle(
  //     Offset.zero,
  //     JogadorSize.x / 2,
  //     Paint()..color = const Color(0xFF00FF00),
  //   );
  //   super.render(canvas);
  // }
}
