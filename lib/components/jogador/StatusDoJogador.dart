import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

class StatusDoJogador extends ChangeNotifier {
  int _vidas = 3;
  int _pontuacao = 0; // Adicionada a declaração de _pontuacao
  int _perguntasTotais = 0;
  int _perguntasRespondidas = 0;

  // Getters
  int get vidas => _vidas;
  int get pontuacao => _pontuacao;
  int get perguntasTotais => _perguntasTotais;
  int get perguntasAcertadas => _perguntasRespondidas;


  void set perguntasTotais(int value) {
    _perguntasTotais = value;
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
  void set perguntasAcertadas(int value) {
    _perguntasRespondidas = value;
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  bool get estaVivo => _vidas > 0;

  bool get respondeuTodasPerguntas => _perguntasRespondidas == _perguntasTotais;

  // Métodos
  void respondeuPergunta(bool acertou) {
    if (acertou) {
      _pontuacao += 100;
    } else {
      _vidas -= 1;
    }
    _perguntasRespondidas++;
    notifyListeners(); // Notifica os ouvintes sobre todas as mudanças
  }
  //Não resetar vidas para não
  void resetarStatus() {
    _pontuacao = 0;
    _perguntasTotais = 0;
    _perguntasRespondidas = 0;
    notifyListeners();
  }
}