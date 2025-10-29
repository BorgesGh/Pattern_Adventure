

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

class Pesadelo extends SimpleEnemy {
  late Image pesadeloFace;
  bool entrouEmContatoComOPlayer = false;
  bool entrouNoJogo = false;
  static bool primeiraAparicao = true;

  StatusDoJogador statusDoJogador;
  GameStateManager estadoDoJogo;

  final Vector2 _foraDaTela = Vector2(-100, -100);

  Pesadelo({
    required this.statusDoJogador,
    required this.estadoDoJogo,
  }) : super(
    size: Vector2.all(MapTile.tileSize),
    animation: CharacterSpriteSheet(fileName: 'pesadelo.png').getAnimation(),
    speed: 10,
    position: Vector2(-100, -100),
  ) {
    priority = -1;
  }

  @override
  Future<void> onLoad() async {
    pesadeloFace = CharacterSpriteSheet.getRostoPesadelo();
    await super.onLoad();
    // ⚠️ Sem CollisionArea → atravessa tudo
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Mostra a primeira vez que aparece
    if (entrouNoJogo && primeiraAparicao) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
        );
      });
      primeiraAparicao = false;
    }

    // Ativa quando o jogo entra no estado Pesadelo

    if (estadoDoJogo.value == GameState.Pesadelo && !entrouNoJogo) {
      gameRef.lighting!.color = Colors.black.withOpacity(0.9);
      position = Vector2(
        gameRef.player!.position.x + (10 * MapTile.tileSize),
        gameRef.player!.position.y,
      );
      entrouNoJogo = true;
    }

    // Movimento + checagem de distância com o player
    if (!entrouEmContatoComOPlayer && gameRef.player != null && entrouNoJogo) {
      // Persegue o player (sem colisão)
      moveToPosition(gameRef.player!.position, speed: speed);

      // Detecta se encostou no player
      if (position.distanceTo(gameRef.player!.position) < MapTile.tileSize * 0.8) {
        entrouEmContatoComOPlayer = true;

        FlameAudio.play(AssetsUrl.som_hit_inimigo);
        DbHelper().buscarPerguntaAleatoria().then((perguntaArrasto) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => DialogArrasto(
              pergunta: perguntaArrasto!,
              onRespondido: (acertou) {
                statusDoJogador.perguntaPesadelo(acertou);
                position = _foraDaTela; // "desaparece" após interação
              },
            ),
          );
        });
      }
    }
  }
}
