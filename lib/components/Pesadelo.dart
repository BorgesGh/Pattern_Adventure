

// import 'package:bonfire/bonfire.dart';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/npc/enemy/simple_enemy.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/GameStateManager.dart';
import 'package:jogo_tabuleiro/components/jogador/Jogador.dart';
import 'package:jogo_tabuleiro/components/jogador/StatusDoJogador.dart';
import 'package:jogo_tabuleiro/repository/DbHelper.dart';
import 'package:jogo_tabuleiro/utils/AssetsUrl.dart';
import 'package:jogo_tabuleiro/widgets/DialogExplicativa.dart';

import '../domain/MapTile.dart';
import '../utils/CharacterSpriteSheet.dart';
import '../widgets/DialogArrasto.dart';

class Pesadelo extends SimpleEnemy{

  late Image pesadeloFace;
  bool entrouEmContatoComOPlayer = false;
  bool entrouNoJogo = false;
  static bool primeiraAparicao = true; // Deixo como estático para que o valor seja guardado na classe, não no objeto

  StatusDoJogador statusDoJogador;
  GameStateManager estadoDoJogo;

  final Vector2 _foraDaTela = Vector2(-100, -100);

  Pesadelo({required this.statusDoJogador, required this.estadoDoJogo}) :super(
    size: Vector2.all(MapTile.tileSize),
    animation: CharacterSpriteSheet(fileName: 'pesadelo.png').getAnimation(),
    speed: 30,
    position: Vector2(-100, -100),
  ){
    priority = -1;
  }

  @override
  Future<void> onLoad() {
    pesadeloFace = CharacterSpriteSheet.getRostoPesadelo();

    return super.onLoad();
  }


  @override
  void update(double dt) {
    super.update(dt);

    if(entrouNoJogo && primeiraAparicao){
      WidgetsBinding.instance.addPostFrameCallback((_) { // eperar o context estar pronto
        TalkDialog.show(
          gameRef.context,
          [
            Say(
              person: pesadeloFace,
              personSayDirection: PersonSayDirection.RIGHT,
              text: [
                const TextSpan(
                  text: "Olá meu camarada!\n",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
            Say(
              person: pesadeloFace,
              personSayDirection: PersonSayDirection.RIGHT,
              text: [
                const TextSpan(
                  text: "Pelo visto você não estudou né... Mas que pena.\n",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
            Say(
              person: pesadeloFace,
              personSayDirection: PersonSayDirection.RIGHT,
              text: [
                const TextSpan(
                  text: "Você não sabe de nada né?\n",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                const TextSpan(
                  text: "Singleton, State, Decorator...\n",
                  style: TextStyle(color: Colors.white, fontSize: 30,fontFamily: 'Courier New', fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Say(
              person: pesadeloFace,
              personSayDirection: PersonSayDirection.RIGHT,
              text: [
                const TextSpan(
                  text: "Você irá se arrepender de não ter estudado!!\n",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),
            // ... restante dos diálogos
          ],
        ).then((_) {
          showDialog(context: context,
              builder: (_) {
                return Dialogexplicativa(
                  imageUrl: AssetsUrl.explicacao_2,
                  explanation: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Esse é o Pesadelo, ele é a própria encarnação das aulas de padrões de projeto que você não prestou atenção.\n'
                                    'Ele vai te perseguir e se te pegar, irá fazer você responder uma pergunta com ',
                            ),
                            TextSpan(
                                text: 'Análise de diagramas de classe.\n',
                                style:  TextStyle(fontSize: 20, color: Colors.cyan)
                            ),
                            TextSpan(
                                text: 'Tome muito cuidado com ele...',
                            )
                          ]
                      )),
                  onClose: (){

                  },
                );
              });
          }
        );
      });

      primeiraAparicao = false;
    }

    if(estadoDoJogo.value == GameState.Pesadelo && !entrouNoJogo) {
      gameRef.lighting!.color = Colors.black.withOpacity(0.9); // Deixa o jogo de noite
      position = Vector2(gameRef.player!.position.x + (3 * MapTile.tileSize) ,gameRef.player!.position.y); // Reseta a posição do Pesadelo
      entrouNoJogo = true; // Marca que já entrou no jogo
    }

    if (!entrouEmContatoComOPlayer) {
      moveToPosition(gameRef.player!.position,speed: speed);
      seeAndMoveToPlayer(
        visionAngle: 80,
        runOnlyVisibleInScreen: false,
        radiusVision: MapTile.tileSize * 30,
        closePlayer: (player) async {
          FlameAudio.play(AssetsUrl.som_hit_inimigo);
          final perguntaArrasto = await DbHelper().buscarPerguntaAleatoria();
          entrouEmContatoComOPlayer = true; // Marca que já falou

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => DialogArrasto(

              pergunta: perguntaArrasto!,
              onRespondido: (acertou) {
                // Mostra feedback
                statusDoJogador.perguntaPesadelo(acertou);
                position = _foraDaTela;
              },
            ),
          );
        }
      );
      return;
    }
  }
}