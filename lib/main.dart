import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(const BoardGameApp());

  // TODO: Setar a orientação da tela em LandScape (Deitado)
}

class BoardGameApp extends StatelessWidget {
  const BoardGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Board Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: const Scaffold(
       body: BoardGame(),
     ),
    );
  }

}


