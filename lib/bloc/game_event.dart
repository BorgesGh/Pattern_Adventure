import 'package:equatable/equatable.dart';
import 'package:jogo_tabuleiro/bloc/game_state.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RollDice extends GameEvent {}

class AnswerQuestion extends GameEvent {
  final bool correct;
  AnswerQuestion(this.correct);

  @override
  List<Object> get props => [correct];
}

class ChangeDifficulty extends GameEvent {
  final Difficulty difficulty;
  ChangeDifficulty(this.difficulty);

  @override
  List<Object> get props => [difficulty];
}
