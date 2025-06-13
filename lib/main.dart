import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_tabuleiro/repository/DbHelper.dart';
import 'package:jogo_tabuleiro/screens/Menu.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'game.dart';

Future<void> main() async {

  // Inicializa a FFI antes de usar qualquer funcionalidade do sqflite
  sqfliteFfiInit();

  // Configura a fábrica global para usar FFI
  // databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();

  // await deleteDatabase('perguntas.db'); // Deleta o banco de dados para testes

  var db = DbHelper(); // Inicializa o banco de dados

  await db.database;

  db.popularQuestoes();
  db.popularQuestoes2();
  db.popularBancoArrasto();

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
     home: const Scaffold(
       body: Menu(),
     ),
    );
  }

}