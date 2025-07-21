import 'package:flutter/material.dart';

import 'jogador/Jogador.dart';

enum GameState {
  intro,
  playing,
  Pesadelo,
  GameOver
}


class GameStateManager extends ValueNotifier<GameState> {
  GameStateManager(super.value);

  void changeState(GameState newState) {
    print("Trocou o estado: $newState");
    if (value != newState) {
      value = newState;
      notifyListeners();
    }
  }
}