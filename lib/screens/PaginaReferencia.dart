import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paginareferencia extends StatelessWidget {
  const Paginareferencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referências'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Referências utilizadas no jogo:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Livro "A Arte da Guerra" de Sun Tzu',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Jogo "Xadrez" - Estratégia e tática',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Filme "Senhor dos Anéis" - Batalhas épicas',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
