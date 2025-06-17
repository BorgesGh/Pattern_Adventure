import 'dart:async';
import 'dart:ui';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/GameStateManager.dart';
import 'package:jogo_tabuleiro/components/jogador/HudDoJogador.dart';
import 'package:jogo_tabuleiro/domain/Atlas.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/utils/AssetsUrl.dart';
import 'package:jogo_tabuleiro/widgets/DialogExplicativa.dart';

import '../../domain/Mapa.dart';
import '../../game.dart';
import '../../screens/GameOver.dart';
import '../../utils/CharacterSpriteSheet.dart';
import '../../widgets/DialogPergunta.dart';
import 'StatusDoJogador.dart';

enum GameState {
  intro,
  playing,
  Pesadelo,
  GameOver
}

class Jogador extends SimplePlayer with PathFinding, BlockMovementCollision, Lighting {

  Mapa mapa;
  StatusDoJogador statusDoJogador;
  GameStateManager estado;
  bool iniciouNovoMapa = false;
  late Image rostoNeutro;
  late Image rostoFeliz;
  late Image rostoTriste;

  Jogador({
    required Vector2 position,
    required this.mapa,
    required this.statusDoJogador,
    required this.estado,
  }) : super(
    animation: CharacterSpriteSheet(fileName: 'player.png').getAnimation(),
    speed: 40,
    position: Vector2(position.x - MapTile.tileSize / 2, position.y - MapTile.tileSize / 2),
    size: Vector2.all(MapTile.tileSize),

  ) {
    priority = 1000;
    setupLighting(
      LightingConfig(
        radius: width * 1.5,
        color: Colors.transparent,
        // blurBorder: 20, // this is a default value
        // type: LightingType.circle, // this is a default value
        // useComponentAngle: false, // this is a default value. When true, light rotates together when a component changes its `angle` param.
      ),
    );
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

    if(estado.value == GameState.intro){
      final completerDialogoIntro = Completer<void>();
      _intro(completerDialogoIntro);
      await completerDialogoIntro.future;

    }
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
            text: 'Eu estava na minha cama agora mesmo e de repente...\n',
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
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              Dialogexplicativa(
                  explanation: RichText(text: const TextSpan(
                    text: 'Olá jogador, você está preso nesse sonho e o seu objetivo é responder corretamente todas as perguntas para passar na prova.\n',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Cada pergunta possui uma cor e sua respectiva dificuldade: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: 'Facil ,',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      TextSpan(
                        text: 'Médio, ',
                        style: TextStyle(fontSize: 20, color: Colors.yellow),
                      ),
                      TextSpan(
                        text: 'Difícil.\n',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      TextSpan(
                        text: 'Pense muito bem em qual pergunta você vai responder, pois se errar, você perderá uma vida.\n',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: 'Boa Sorte.\n',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan, fontFamily: 'Courier New'),
                      ),
                    ],
                  )),
                  imageUrl: AssetsUrl.explicacao_1,
                  onClose: (){
                    completerTalk.complete();
                  }));
    });

  }

  @override
  void update(double dt) {
    if (!statusDoJogador.estaVivo || estado.value == GameState.GameOver) {
      estado.changeState(GameState.GameOver);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const GameOver(),
        ));
        removeFromParent();
      });
    }
    else if(statusDoJogador.respondeuTodasPerguntas && !iniciouNovoMapa) {
      iniciouNovoMapa = true;
      statusDoJogador.resetarStatus();
      String nomeMapaAtual = Atlas().atual.nomeMapa;
      print("Mapa Atual: $nomeMapaAtual");
      switch (nomeMapaAtual) {
        case 'Floresta':
          WidgetsBinding.instance.addPostFrameCallback((_) {
            MapNavigator.of(context).toNamed("/Mapa-Agua");
            FlameAudio.bgm.play(AssetsUrl.musica_normal, volume: 0.30);
          });
          break;
        case 'Mapa-Agua':
          estado.changeState(GameState.GameOver);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const GameOver(),
            ));
            removeFromParent();
          });
          break;
        default:
          estado.changeState(GameState.playing);
      }
    }
    super.update(dt);
  }
}
