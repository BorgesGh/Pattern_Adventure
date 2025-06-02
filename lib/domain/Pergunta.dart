import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/game.dart';
enum Dificuldade {
  facil,
  medio,
  dificil
}

class Pergunta {
  final String pergunta;
  final List<String> alternativas;
  final int indexSolucao;
  final String solucao;
  final Dificuldade dificuldade;
  final String? headerImagem;     // Caminho opcional da imagem no header
  final String? solucaoImagem;    // Caminho opcional da imagem na solução

  Pergunta({
    required this.pergunta,
    required this.alternativas,
    required this.indexSolucao,
    required this.solucao,
    required this.dificuldade,
    this.headerImagem,
    this.solucaoImagem,
  });

  /// Serialização para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'pergunta': pergunta,
      'alternativas': alternativas.join('|'),
      'indexSolucao': indexSolucao,
      'solucao': solucao,
      'dificuldade': dificuldade.index,
      'headerImagem': headerImagem,
      'solucaoImagem': solucaoImagem,
    };
  }

  /// Criação a partir do banco de dados
  factory Pergunta.fromMap(Map<String, dynamic> map) {
    return Pergunta(
      pergunta: map['pergunta'],
      alternativas: (map['alternativas'] as String).split('|'),
      indexSolucao: map['indexSolucao'],
      solucao: map['solucao'],
      dificuldade: Dificuldade.values[map['dificuldade']],
      headerImagem: map['headerImagem'],
      solucaoImagem: map['solucaoImagem'],
    );
  }
}
