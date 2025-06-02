import 'dart:async';
import 'dart:ui';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/player.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/jogador/HudDoJogador.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/widgets/BalaoDica.dart';

import '../../domain/Mapa.dart';
import '../../game.dart';
import '../../utils/CharacterSpriteSheet.dart';
import '../../widgets/DialogPergunta.dart';
import 'StatusDoJogador.dart';

enum PlayerState {
  intro,
  playing,
  death
}

class Jogador extends SimplePlayer with PathFinding, BlockMovementCollision {

  Mapa mapa;
  List<int> indexDePerguntas = [];
  List<MapTile> caminho = [];
  StatusDoJogador statusDoJogador;
  PlayerState estado;
  late Image rostoNeutro;
  late Image rostoFeliz;
  late Image rostoTriste;

  Jogador({
    required Vector2 position,
    required this.mapa,
    required this.indexDePerguntas,
    required this.statusDoJogador,
    required this.estado,
  }) : super(
    animation: CharacterSpriteSheet(fileName: 'player.png').getAnimation(),
    speed: 40,
    position: Vector2(position.x - MapTile.tileSize / 2, position.y - MapTile.tileSize / 2),
    size: Vector2.all(MapTile.tileSize),
  ) {
    caminho = mapa.caminhoPrincipal; // atribui o caminho do mapa ao jogador

  }

  @override
  Future<void> onLoad() {
    rostoFeliz = CharacterSpriteSheet.getRostoFeliz();
    rostoNeutro = CharacterSpriteSheet.getRostoNeutro();
    rostoTriste = CharacterSpriteSheet.getRostoTriste();

    add(RectangleHitbox(
      size: Vector2.all(MapTile.tileSize - 8),
      position: Vector2.all(MapTile.tileSize / 4),
    ));


    return super.onLoad();
  }

  @override
  Future<void> onMount() async {
    // debugMode = true;

    // if(estado == PlayerState.intro){
    //   final completerDialogoIntro = Completer<void>();
    //
    //   _intro(completerDialogoIntro);
    //
    //   await completerDialogoIntro.future;
    //
    // }

    statusDoJogador.addListener(() {
      if (!statusDoJogador.estaVivo) {
        estado = PlayerState.death;
        print("O jogador morreu!");
        // Adicione lógica adicional aqui, como exibir uma tela de fim de jogo.
      }
      else if(statusDoJogador.respondeuTodasPerguntas){
        MapNavigator.of(context).toNamed('/mapa-agua');
        statusDoJogador.resetarStatus();
      }
    });

    super.onMount();
  }

  void _intro(Completer completerTalk) {
    TalkDialog.show(gameRef.context, [
      Say(
        person: rostoNeutro,
        text: [
          const TextSpan(
            text: "Onde eu estou?\n",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ],
      ),
      Say(
        person: rostoNeutro,
        text: [
          const TextSpan(
            text: 'Eu estava na minha cama agora mesmo e derrepente...\n',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
      Say(
        person: rostoNeutro,
        text: [
          const TextSpan(
            text: 'Acho que eu estava sonhando, semana que vem tinha prova de padrões de projeto\n',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
      Say(
        person: rostoTriste,
        text: [
          const TextSpan(
            text: 'Droga! Eu sabia que não ia dar tempo para estudar!\n',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
      Say(
        person: rostoNeutro,
        text: [
          const TextSpan(
            text: 'Tudo bem.. Eu vejo isso depois. Mas primeiro preciso sair daqui.\n',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      )]).then((_){
      completerTalk.complete();
    });

  }
}
