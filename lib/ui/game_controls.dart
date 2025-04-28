import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_tabuleiro/repository/question_repository.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state.isGameOver) {
          return ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(ChangeDifficulty(state.difficulty));
            },
            child: const Text('Recomeçar'),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vidas: ${state.lives}  |  Pontuação: ${state.score}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(RollDice());
              },
              child: const Text('Jogar Dado 🎲'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showQuestionDialog(context, state.difficulty);
              },
              child: const Text('Responder Pergunta 🧠'),
            ),
          ],
        );
      },
    );
  }

  void _showQuestionDialog(BuildContext context, Difficulty difficulty) {
    final questions = QuestionsRepository.getQuestions(difficulty);
    final question = (questions..shuffle()).first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(question.text),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return ElevatedButton(
                onPressed: () {
                  final correct = index == question.correctOptionIndex;
                  context.read<GameBloc>().add(AnswerQuestion(correct));
                  Navigator.pop(context);
                },
                child: Text(option),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
