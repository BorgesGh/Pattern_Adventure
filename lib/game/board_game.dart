import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/game/board.dart';
import 'package:jogo_tabuleiro/game/board_generate.dart';
import '../bloc/game_bloc.dart';

class BoardGame extends FlameGame {
  final GameBloc bloc;
  final boardWorld = Board();

  BoardGame(this.bloc);

  @override
  Color backgroundColor() => const Color(0xFFEFEFEF);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    debugMode = true;
    world.add(boardWorld);
  }
}
