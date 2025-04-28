import 'package:equatable/equatable.dart';

enum Difficulty { easy, medium, hard }

class GameState extends Equatable {
  final int position;
  final int lives;
  final int score;
  final Difficulty difficulty;
  final bool isGameOver;

  const GameState({
    this.position = 0,
    this.lives = 3,
    this.score = 0,
    this.difficulty = Difficulty.easy,
    this.isGameOver = false,
  });

  GameState copyWith({
    int? position,
    int? lives,
    int? score,
    Difficulty? difficulty,
    bool? isGameOver,
  }) {
    return GameState(
      position: position ?? this.position,
      lives: lives ?? this.lives,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  @override
  List<Object> get props => [position, lives, score, difficulty, isGameOver];
}
