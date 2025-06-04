import 'package:flutter/material.dart';

import 'jogador/Player.dart';

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