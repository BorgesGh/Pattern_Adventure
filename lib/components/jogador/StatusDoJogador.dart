import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:jogo_tabuleiro/components/GameStateManager.dart';
import 'package:jogo_tabuleiro/utils/AssetsUrl.dart';

import 'Jogador.dart';

class StatusDoJogador {
  int _vidas = 3;
  int _pontuacao = 0; // Adicionada a declaração de _pontuacao
  int _perguntasTotais = 0;
  int _perguntasRespondidas = 0;

  late GameStateManager estadoDoJogo;

  // Getters
  int get vidas => _vidas;
  int get pontuacao => _pontuacao;
  int get perguntasTotais => _perguntasTotais;
  int get perguntasAcertadas => _perguntasRespondidas;

  StatusDoJogador() {
    FlameAudio.bgm.play(AssetsUrl.musica_normal);
  }

  void set perguntasTotais(int value) {
    _perguntasTotais = value;
  }
  void set perguntasAcertadas(int value) {
    _perguntasRespondidas = value;
  }

  bool get estaVivo => _vidas > 0;

  bool get respondeuTodasPerguntas => _perguntasRespondidas == _perguntasTotais && _perguntasTotais > 0;

  // Métodos
  void respondeuPergunta(bool acertou) {
    if (acertou) {
      _pontuacao += 100;
      FlameAudio.play(AssetsUrl.effect_acertou);

    } else {
      _vidas -= 1;
      if(!estaVivo){
        estadoDoJogo.changeState(GameState.GameOver); // Muda o estado do jogo para GameOver

      }
      FlameAudio.play(AssetsUrl.effect_errou);

    }
    _perguntasRespondidas++;
    if(_perguntasRespondidas >= _perguntasTotais / 2) {
      estadoDoJogo.changeState(GameState.Pesadelo); // Muda o estado do jogo para Pesadelo
      FlameAudio.bgm.play(AssetsUrl.musica_noite,volume: 0.30);
    }
  }

  void perguntaPesadelo(bool acertou){
    if (acertou) {
      _pontuacao += 200; // Pontuação maior para perguntas do Pesadelo
    } else {
      _vidas -= 1; // Perde uma vida se errar
    }
  }

  //Não resetar vidas para não
  void resetarStatus() {
    _pontuacao = 0;
    _perguntasTotais = 0;
    _perguntasRespondidas = 0;
    estadoDoJogo.changeState(GameState.playing);
    FlameAudio.bgm.play(AssetsUrl.musica_normal, volume: 0.30);

  }
}