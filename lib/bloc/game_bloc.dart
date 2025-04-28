import 'dart:math';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_tabuleiro/game/board_generate.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final Random _random = Random();
  final BoardGenerate boardService; // Instância do BoardService

  GameBloc(this.boardService) : super(const GameState()) {
    on<RollDice>(_onRollDice);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<ChangeDifficulty>(_onChangeDifficulty);
  }

  void _onRollDice(RollDice event, Emitter<GameState> emit) {
    final positions = boardService
        .getSquarePositions(); // Usando BoardService para obter as posições
    final currentPositionIndex = state.position; // Posição atual
    final newPositionIndex =
        (currentPositionIndex + _random.nextInt(3) + 1) % positions.length;

    // Emite o novo estado com a nova posição
    emit(state.copyWith(position: newPositionIndex));
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<GameState> emit) {
    if (event.correct) {
      emit(state.copyWith(score: state.score + 10));
    } else {
      final newLives = state.lives - 1;
      if (newLives <= 0) {
        emit(state.copyWith(lives: 0, isGameOver: true));
      } else {
        emit(state.copyWith(lives: newLives));
      }
    }
  }

  void _onChangeDifficulty(ChangeDifficulty event, Emitter<GameState> emit) {
    emit(state.copyWith(difficulty: event.difficulty));
  }
}
