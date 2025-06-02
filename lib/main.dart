import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_tabuleiro/repository/DbHelper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'game.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa a FFI antes de usar qualquer funcionalidade do sqflite
  sqfliteFfiInit();

  // Configura a fábrica global para usar FFI
  databaseFactory = databaseFactoryFfi;

  var db = await DbHelper(); // Inicializa o banco de dados
  // db.popularBanco();

  runApp(const BoardGameApp());

  // TODO: Setar a orientação da tela em LandScape (Deitado)
  DeviceOrientation.landscapeLeft;
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
     home: Scaffold(
       body: BoardGame(),
     ),
    );
  }

}


