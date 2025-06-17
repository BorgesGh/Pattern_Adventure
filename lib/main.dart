import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_tabuleiro/repository/DbHelper.dart';
import 'package:jogo_tabuleiro/screens/Menu.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'game.dart';

Future<void> main() async {

  // Inicializa a FFI antes de usar qualquer funcionalidade do sqflite
  sqfliteFfiInit();

  // definir factory quando o dispositivo for desktop
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    databaseFactory = databaseFactoryFfi;
  }

  // deleteDatabase('perguntas.db'); // Deletar o banco de dados para testes

  WidgetsFlutterBinding.ensureInitialized();

  var db = DbHelper(); // Inicializa o banco de dados
  await db.database;

  // db.popularQuestoes();

  db.popularBancoArrasto(); // Aleatorizar as perguntas de diagramas

  runApp(const BoardGameApp());

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
