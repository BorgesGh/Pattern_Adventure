import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/Pergunta.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'perguntas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE perguntas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pergunta TEXT NOT NULL,
        alternativas TEXT NOT NULL,
        index_solucao INTEGER NOT NULL,
        solucao TEXT NOT NULL,
        dificuldade TEXT NOT NULL
      )
    ''');
  }

  Future<int> inserirPergunta(Pergunta pergunta) async {
    final db = await database;
    return await db.insert(
      'perguntas',
      {
        'pergunta': pergunta.pergunta,
        'alternativas': jsonEncode(pergunta.alternativas),
        'index_solucao': pergunta.indexSolucao,
        'solucao': pergunta.solucao,
        'dificuldade': pergunta.dificuldade.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pergunta>> buscarPerguntas() async {
    final db = await database;
    final resultado = await db.query('perguntas');

    return resultado.map((row) {
      return Pergunta(
        pergunta: row['pergunta'] as String,
        alternativas: List<String>.from(jsonDecode(row['alternativas'] as String)),
        indexSolucao: row['index_solucao'] as int,
        solucao: row['solucao'] as String,
        dificuldade: Dificuldade.values.firstWhere(
              (e) => e.name == (row['dificuldade'] as String),
        ),
      );
    }).toList();
  }


  void popularBanco(){
    inserirPergunta(
      Pergunta(
        pergunta: "Qual é a capital da França?",
        alternativas: ["Londres", "Paris", "Berlim", "Madri"],
        indexSolucao: 1,
        solucao: "Paris é a capital da França.",
        dificuldade: Dificuldade.facil,
      ),
    );

  }
}
