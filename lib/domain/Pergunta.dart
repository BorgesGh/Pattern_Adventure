import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/game.dart';

enum Dificuldade {
  facil,
  medio,
  dificil
}

class Pergunta extends GameComponent{

  late String pergunta;
  late List<String> alternativas;
  late int indexSolucao;
  late String solucao;
  late Dificuldade dificuldade;

  Pergunta({
    required this.pergunta,
    required this.alternativas,
    required this.indexSolucao,
    required this.solucao,
    required this.dificuldade,
  });
}