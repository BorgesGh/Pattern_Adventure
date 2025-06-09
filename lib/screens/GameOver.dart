import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Menu.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Game Over'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fim de Jogo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
                  return const Menu(); // Volta para o menu
                })); // Volta para o menu
              },
              color: CupertinoColors.activeBlue,
              child: const Text('Voltar ao Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
