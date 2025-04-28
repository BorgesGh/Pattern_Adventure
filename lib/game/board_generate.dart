import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:jogo_tabuleiro/game/board_game.dart';

class BoardGenerate extends Component with HasGameRef<BoardGame> {
  List<Offset> squarePositions = [];

  List<Offset> generateSquarePositions(
      Vector2 screenSize, Vector2 boardSize, double tileSize, double padding) {
    // Calcula quantas linhas e colunas cabem no boardSize
    final int rows = (boardSize.y / (tileSize + padding)).floor();
    final int columns = (boardSize.x / (tileSize + padding)).floor();

    // Agora calcula o tamanho real que o tabuleiro vai ocupar
    final boardWidth = columns * (tileSize + padding) - padding;
    final boardHeight = rows * (tileSize + padding) - padding;

    // Calcula o ponto de início para centralizar o tabuleiro na tela
    final startX = (screenSize.x - boardWidth) / 2;
    final startY = (screenSize.y - boardHeight) / 2;

    squarePositions.clear();

    // Borda superior
    for (int i = 0; i < columns; i++) {
      squarePositions.add(Offset(startX + i * (tileSize + padding), startY));
    }

    // Borda direita
    for (int i = 1; i < rows - 1; i++) {
      squarePositions.add(Offset(
        startX + boardWidth - tileSize,
        startY + i * (tileSize + padding),
      ));
    }

    // Borda inferior
    List<Offset> bottomRow = [];
    for (int i = 0; i < columns; i++) {
      bottomRow.add(Offset(
        startX + i * (tileSize + padding),
        startY + boardHeight - tileSize,
      ));
    }
    bottomRow = bottomRow.reversed.toList();
    squarePositions.addAll(bottomRow);

    // Borda esquerda
    List<Offset> leftColumn = [];
    for (int i = 1; i < rows - 1; i++) {
      leftColumn.add(Offset(
        startX,
        startY + i * (tileSize + padding),
      ));
    }
    leftColumn = leftColumn.reversed.toList();
    squarePositions.addAll(leftColumn);

    return squarePositions;
  }

  List<Offset> getSquarePositions() {
    return squarePositions;
  }
}
