import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game.dart'; // Para usar o botão ElevatedButton
// Importe a página do jogo
// import 'caminho/board_game.dart'; // Ajuste conforme a sua estrutura

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Menu do Jogo'),
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => BoardGame()),
            );
          },
          child: const Text('Iniciar Jogo'),
        ),
      ),
    );
  }
}
