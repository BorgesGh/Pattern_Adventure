import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/screens/PaginaReferencia.dart';

import '../game.dart'; // Para usar o botão ElevatedButton
// Importe a página do jogo
// import 'caminho/board_game.dart'; // Ajuste conforme a sua estrutura

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: const EdgeInsets.only(left: 40),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/character/Banner-jogo.png'), // Substitua pelo caminho da sua imagem de fundo
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: const LinearBorder(),
              ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => PadroesProjetoGame()),
              );
            },
            child: const Text('Iniciar Jogo',style: TextStyle(color: Colors.white),)),

            const SizedBox(height: 20), // Espaço entre os botões

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: const LinearBorder(),
              ),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => const Paginareferencia()),
                  );
                },
                child: const Text('Referencias', style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
