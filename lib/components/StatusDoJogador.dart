import 'package:flutter/cupertino.dart';

class StatusDoJogador extends ChangeNotifier {
  int _vidas = 3;
  int _pontuacao = 0;

  int get vidas => _vidas;
  int get pontuacao => _pontuacao;

  void acertouPergunta() {
    _pontuacao += 100;
    notifyListeners();
  }

  void errouPergunta() {
    _vidas -= 1;
    notifyListeners();
  }

  bool get estaVivo => _vidas > 0;
}
