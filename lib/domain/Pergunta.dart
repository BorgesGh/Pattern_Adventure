import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/game.dart';

class Pergunta extends GameComponent{

  late String pergunta;
  late String solucao;

  Pergunta({
    required this.pergunta,
    required this.solucao,
  });
}