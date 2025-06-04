

// import 'package:bonfire/bonfire.dart';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/npc/enemy/simple_enemy.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/GameStateManager.dart';
import 'package:jogo_tabuleiro/components/jogador/Player.dart';
import 'package:jogo_tabuleiro/components/jogador/StatusDoJogador.dart';

import '../domain/MapTile.dart';
import '../utils/CharacterSpriteSheet.dart';
import '../widgets/DialogArrasto.dart';

class Pesadelo extends SimpleEnemy with PathFinding {

  late Image pesadeloFace;
  bool entrouEmContatoComOPlayer = false;
  bool entrouNoJogo = false;
  bool primeiraAparicao = true;


  List<MapTile> caminho = [];
  StatusDoJogador statusDoJogador;
  GameStateManager estadoDoJogo;

  final Vector2 _foraDaTela = Vector2(-100, -100);

  Pesadelo({required this.caminho, required this.statusDoJogador, required this.estadoDoJogo}) :super(
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
            // ... restante dos diálogos
          ],
        );
      });
      primeiraAparicao = false;
    }

    if(estadoDoJogo.value == GameState.Pesadelo && !entrouNoJogo) {
      gameRef.lighting!.color = Colors.black.withOpacity(0.9); // Deixa o jogo de noite
      position = caminho[1].position; // Reseta a posição do Pesadelo
      entrouNoJogo = true; // Marca que já entrou no jogo
    }

    if (!entrouEmContatoComOPlayer) {
      moveToPosition(gameRef.player!.position);
      seeAndMoveToPlayer(
        visionAngle: 80,
        runOnlyVisibleInScreen: false,
        closePlayer: (player) {
          entrouEmContatoComOPlayer = true; // Marca que já falou

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => DialogArrasto(
              imagens: [
                Image.asset('assets/images/character/player-feliz.png', width: 80, height: 80),
                Image.asset('assets/images/character/player-triste.png', width: 80, height: 80),
                Image.asset('assets/images/character/player-neutro.png', width: 80, height: 80),
              ],
              ordemCorreta: const [2, 0, 1], // Índices corretos para cada posição
              onRespondido: (acertou) {
                // Mostra feedback
                statusDoJogador.perguntaPesadelo(acertou);
                position = _foraDaTela;
              },
            ),
          );

        },
        radiusVision: MapTile.tileSize * 30,
      );

      return;
    }
  }
}