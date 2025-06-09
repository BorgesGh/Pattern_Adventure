import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';
import 'package:jogo_tabuleiro/domain/Mapa.dart';
import 'package:jogo_tabuleiro/domain/Pergunta.dart';
import 'package:jogo_tabuleiro/game.dart';
import 'package:jogo_tabuleiro/repository/DbHelper.dart';
import 'package:sqflite/sqflite.dart';

class Atlas {
  static final Atlas _instancia = Atlas._interno();

  List<int> indiceDePerguntas = [];
  late List<Mapa> mapas;
  late Mapa atual;

  factory Atlas() {
    return _instancia;
  }

  Atlas._interno() {
    carregarMapas();
    atual = mapas[0]; // Define o primeiro mapa como o atual
  }

  void carregarMapas() {
    mapas = [
      Mapa(
        caminhoDoArquivo: 'tiled/Mapa-Floresta.json',
        nomeMapa: 'Floresta',
        caminhoPrincipal: [
          // De (1, 12) até (9, 12)
          MapTile(position: Vector2(1 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(2 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(3 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(4 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(5 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(6 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(7 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(8 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(9 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(9.5 * MapTile.tileSize, 13 * MapTile.tileSize)),

// De (9, 12) até (9, 9)
          MapTile(position: Vector2(9.5 * MapTile.tileSize, 12 * MapTile.tileSize)),
          MapTile(position: Vector2(9.5 * MapTile.tileSize, 11 * MapTile.tileSize)),
          MapTile(position: Vector2(9.5 * MapTile.tileSize, 9.5 * MapTile.tileSize)),

// De (9, 9) até (20, 9)
          MapTile(position: Vector2(9.5 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(11 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(12 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(13 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(14 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(15 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(16 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(17 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(18 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(19 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(20 * MapTile.tileSize, 9.5 * MapTile.tileSize)),

// De (20, 9) até (20, 7)
          MapTile(position: Vector2(20 * MapTile.tileSize, 9 * MapTile.tileSize)),
          MapTile(position: Vector2(20 * MapTile.tileSize, 8 * MapTile.tileSize)),

// De (20, 7) até (25, 7)
          MapTile(position: Vector2(21 * MapTile.tileSize, 8 * MapTile.tileSize)),
          MapTile(position: Vector2(22 * MapTile.tileSize, 8 * MapTile.tileSize)),
          MapTile(position: Vector2(23 * MapTile.tileSize, 8 * MapTile.tileSize)),
          MapTile(position: Vector2(24 * MapTile.tileSize, 8 * MapTile.tileSize)),
          MapTile(position: Vector2(25 * MapTile.tileSize, 8 * MapTile.tileSize)),

        ],
      ),
      Mapa(
        caminhoDoArquivo: 'tiled/Mapa-agua.json',
        nomeMapa: "Mapa-Agua",
        caminhoPrincipal: [
          // De (4, 9) até (21, 9)
          MapTile(position: Vector2(4 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(5 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(6 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(7 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(8 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(9 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(10 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(11 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(12 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(13 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(14 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(15 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(16 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(17 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(18 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(19 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(20 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 9.5 * MapTile.tileSize)),

// De (21, 9) até (21, 14)
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 9.5 * MapTile.tileSize)),
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 11 * MapTile.tileSize)),
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 12 * MapTile.tileSize)),
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 13 * MapTile.tileSize)),
          MapTile(position: Vector2(21.5 * MapTile.tileSize, 14 * MapTile.tileSize)),

        ],
      )
    ];
  }

  Future<void> gerarAreasDePergunta() async {
    final db = DbHelper();

    indiceDePerguntas.clear();

    var caminhos = atual.caminhoPrincipal;

    // Busca todas as perguntas do banco
    final todasPerguntas = await db.buscarPerguntas();


    // Embaralha a lista para obter perguntas aleatórias
    todasPerguntas.shuffle();

    print("Tamanho do Vetor de caminhos: ${caminhos.length}");

    // Índice para acessar perguntas aleatórias da lista
    int perguntaIndex = 0;

    caminhos.asMap().forEach((index, caminho) {
      final bool podeInserir = Random.secure().nextInt(100) < 20 && caminho.pergunta == null && index > 2;

      if (podeInserir && perguntaIndex < todasPerguntas.length) {
        caminho.pergunta = todasPerguntas[perguntaIndex];
        indiceDePerguntas.add(index);
        perguntaIndex++; // Avança para a próxima pergunta
      } else {
        caminho.pergunta = null;
      }
    });
  }

  String getProximoMapa(){
    var mapa = mapas[(mapas.indexOf(atual) + 1) % mapas.length];
    return mapa.caminhoDoArquivo.split('/').last; // Corta apenas para o nome do mapa
  }

}