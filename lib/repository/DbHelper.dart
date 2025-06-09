import 'dart:convert';
import 'dart:math';
import 'package:jogo_tabuleiro/domain/PerguntaArrasto.dart';
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
      version: 2,
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
      dificuldade INTEGER NOT NULL,
      header_imagem TEXT,
      solucao_imagem TEXT
    )
  ''');
    // TODO: Por algum motivo o HeaderImagem não está salvando corretamente no banco de dados.
    await db.execute('''
    CREATE TABLE perguntas_arrasto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      caminhosImagens TEXT NOT NULL,
      ordemCorreta TEXT NOT NULL,
      alternativas TEXT NOT NULL
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

  Future<int> inserirPerguntaArrasto(PerguntaArrasto pergunta) async {
    final db = await database;
    return await db.insert(
      'perguntas_arrasto',
      pergunta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PerguntaArrasto>> buscarPerguntasArrasto() async {
    final db = await database;
    final resultado = await db.query('perguntas_arrasto');

    return resultado.map((row) {
      return PerguntaArrasto.fromMap(row);
    }).toList();
  }

  Future<PerguntaArrasto?> buscarPerguntaAleatoria() async {
    final db = await database;

    // Primeiro conta quantas perguntas existem
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM perguntas_arrasto');
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) return null;

    // Gera um offset aleatório
    final random = Random();
    final offset = random.nextInt(count);

    // Busca 1 pergunta com o offset aleatório
    final resultado = await db.rawQuery(
        'SELECT * FROM perguntas_arrasto LIMIT 1 OFFSET ?',
        [offset]
    );

    if (resultado.isEmpty) return null;

    return PerguntaArrasto.fromMap(resultado.first);
  }

  void popularBanco(){
    inserirPergunta(
      Pergunta(
        pergunta: "Qual é a capital da França?",
        alternativas: ["Londres", "Paris", "Berlim", "Madri"],
        indexSolucao: 0,
        solucao: "Paris é a capital da França.",
        dificuldade: Dificuldade.facil,
        headerImagem: "assets/images/diagramas/teste1.png", // Caminho opcional da imagem no header
      ),
    );
    buscarPerguntas().then((perguntas) {
      for (var pergunta in perguntas) {
        print("Pergunta: ${pergunta.pergunta}");
        print("Alternativas: ${pergunta.alternativas}");
        print("Solução: ${pergunta.solucao}");
        print("Header Image: ${pergunta.headerImagem}");
      }
    });
  }

  void popularBancoArrasto() {
    inserirPerguntaArrasto(
      PerguntaArrasto(
        caminhosImagens: ["assets/images/diagramas/teste1.png", "assets/images/diagramas/teste2.png", "assets/images/diagramas/teste3.png"],
        ordemCorreta: [0, 1, 2],
        alternativas: ["Relação de carro", "Relação de pessoa", "Herança"], // Add Nomes dos padrões de projeto
      ),
    );
  }
}
