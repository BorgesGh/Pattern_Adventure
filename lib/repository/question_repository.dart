import '../bloc/game_state.dart';
import '../models/question.dart';

class QuestionsRepository {
  static List<Question> getQuestions(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return [
          Question(
            text: 'Quanto é 2 + 2?',
            options: ['3', '4', '5'],
            correctOptionIndex: 1,
          ),
          Question(
            text: 'Qual é a cor do céu em um dia limpo?',
            options: ['Verde', 'Azul', 'Vermelho'],
            correctOptionIndex: 1,
          ),
        ];
      case Difficulty.medium:
        return [
          Question(
            text: 'Quem descobriu o Brasil?',
            options: [
              'Cristóvão Colombo',
              'Pedro Álvares Cabral',
              'Dom Pedro II'
            ],
            correctOptionIndex: 1,
          ),
          Question(
            text: 'Qual é o maior planeta do sistema solar?',
            options: ['Terra', 'Júpiter', 'Saturno'],
            correctOptionIndex: 1,
          ),
        ];
      case Difficulty.hard:
        return [
          Question(
            text: 'Qual é a raiz quadrada de 256?',
            options: ['14', '15', '16'],
            correctOptionIndex: 2,
          ),
          Question(
            text: 'Em que ano aconteceu a Revolução Francesa?',
            options: ['1789', '1804', '1750'],
            correctOptionIndex: 0,
          ),
        ];
    }
  }
}
