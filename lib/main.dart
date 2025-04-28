import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame/game.dart';
import 'package:jogo_tabuleiro/bloc/game_bloc.dart';
import 'package:jogo_tabuleiro/game/board_game.dart';
import 'package:jogo_tabuleiro/game/board_generate.dart';
import 'package:jogo_tabuleiro/ui/game_controls.dart';

void main() {
  runApp(const BoardGameApp());
}

class BoardGameApp extends StatelessWidget {
  const BoardGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    final boardService = BoardGenerate();
    boardService.generateSquarePositions(
        Vector2(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2),
        Vector2(MediaQuery.of(context).size.width * 0.7,
            MediaQuery.of(context).size.height * 0.5),
        30.0,
        5.0); // Tamanho da tela e tamanho do quadrado

    return BlocProvider(
      create: (_) => GameBloc(boardService),
      child: MaterialApp(
        title: 'Board Game Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: BoardGameScreen(),
      ),
    );
  }
}

class BoardGameScreen extends StatelessWidget {
  final boardService = BoardGenerate(); // Instância do BoardService
  BoardGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BoardGame(context.read<GameBloc>());
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GameControls(),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   body: GameWidget(game: game),
    // );
  }
}
