import 'dart:convert';
import 'dart:math';
import 'package:jogo_tabuleiro/domain/PerguntaArrasto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/Pergunta.dart';
import '../utils/AssetsUrl.dart';

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
    await db.execute('''
    CREATE TABLE questoes_arrasto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      caminhosImagens TEXT NOT NULL,
      ordemCorreta TEXT NOT NULL,
      alternativas TEXT NOT NULL
    )
  ''');

    popularQuestoes();
    popularQuestoes2();
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
      'questoes_arrasto',
      pergunta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PerguntaArrasto>> buscarPerguntasArrasto() async {
    final db = await database;
    final resultado = await db.query('questoes_arrasto');

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

  
  void popularQuestoes(){
      // 1. Abstract Factory
      inserirPergunta(Pergunta(
        pergunta: "Qual é o objetivo principal do padrão Abstract Factory?",
        alternativas: ["Instanciar uma classe específica diretamente", "Criar famílias de objetos relacionados sem expor classes concretas", "Implementar herança múltipla", "Serializar objetos"],
        indexSolucao: 1,
        solucao: "O padrão Abstract Factory permite criar famílias de objetos relacionados sem expor suas classes concretas.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como o Abstract Factory promove a independência de implementação?",
        alternativas: ["Usando herança para subclasses decidirem", "Através de uma fábrica abstrata que encapsula várias factory methods", "Utilizando singletons globais", "Com mixins"],
        indexSolucao: 1,
        solucao: "Ele utiliza uma fábrica abstrata que encapsula factory methods para criar diferentes objetos, promovendo desacoplamento.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quando você usaria Abstract Factory invés de Factory Method?",
        alternativas: ["Para criar apenas um tipo de objeto", "Para criar famílias de produtos relacionados", "Quando não há subclasses", "Para implementar proxy de objetos"],
        indexSolucao: 1,
        solucao: "Use Abstract Factory quando precisar criar famílias de objetos relacionados; Factory Method serve para criar um único tipo via herança.",
        dificuldade: Dificuldade.dificil,
      ));

      // 2. Adapter
      inserirPergunta(Pergunta(
        pergunta: "O que o padrão Adapter faz?",
        alternativas: ["Cria objetos em família", "Converte a interface de uma classe para outra", "Adiciona comportamento via herança", "Gerencia estados internos"],
        indexSolucao: 1,
        solucao: "O Adapter converte a interface de uma classe existente para outra que o cliente espera.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quais são as duas formas de implementar um Adapter?",
        alternativas: ["Factory e Abstract Factory", "Herança de classe e composição/encapsulamento", "Singleton e Prototype", "Decorator e Proxy"],
        indexSolucao: 1,
        solucao: "Você pode implementar Adapter por herança (class adapter) ou por composição (object adapter).",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual a diferença principal entre Adapter e Decorator?",
        alternativas: ["Adapter altera interface, Decorator adiciona comportamento", "Adapter cria objetos, Decorator observa objetos", "Ambos fazem a mesma coisa", "Decorator converte interfaces também"],
        indexSolucao: 0,
        solucao: "Adapter altera a interface de um objeto existente; Decorator adiciona responsabilidades sem mudar a interface.",
        dificuldade: Dificuldade.dificil,
      ));

      // 3. Bridge
      inserirPergunta(Pergunta(
        pergunta: "Qual a motivação do padrão Bridge?",
        alternativas: ["Converter interfaces incompatíveis", "Desacoplar abstração da implementação para variar ambos independentes", "Garantir instância única", "Notificar mudanças de estado"],
        indexSolucao: 1,
        solucao: "O Bridge desacopla abstração e implementação, permitindo que variem independentemente.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como o Bridge evita a explosão de subclasses?",
        alternativas: ["Usando Singleton", "Separa hierarquia de abstração e implementação via composição", "Utilizando herança múltipla", "Apenas documentando o código"],
        indexSolucao: 1,
        solucao: "Ao separar abstração e implementação, evita criar subclasses para cada combinação possível.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Dê um exemplo real de uso de Bridge com as hierarquias Abstraction e Implementor.",
        alternativas: ["Adapter entre APIs", "GUI com tema e componente independentes", "Singleton para configuração global", "Observer para eventos"],
        indexSolucao: 1,
        solucao: "Em uma GUI, a abstração é o componente (e.g. janela), e a implementação é a plataforma (Windows/Linux), variando separadamente.",
        dificuldade: Dificuldade.dificil,
      ));

      // 4. Decorator
      inserirPergunta(Pergunta(
        pergunta: "Qual a finalidade do padrão Decorator?",
        alternativas: ["Encapsular famílias de criação", "Adicionar responsabilidades a um objeto dinamicamente", "Garantir uma única instância", "Detectar mudanças de estado"],
        indexSolucao: 1,
        solucao: "Decorator permite adicionar responsabilidades a um objeto de forma dinâmica, sem alterar sua classe.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como adicionar comportamentos dinamicamente a uma pizza via Decorator?",
        alternativas: ["Criar subclasses para cada tipo", "Envolver o objeto pizza em decorators como queijo, calabresa etc.", "Usar factory para instanciar", "Usar static methods"],
        indexSolucao: 1,
        solucao: "Você encapsula a pizza com decorators como queijo, calabresa, cada um adicionando seu comportamento.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual a diferença entre Decorator e Proxy?",
        alternativas: ["Decorator altera comportamento, Proxy controla acesso", "Ambos fazem a mesma coisa", "Proxy cria objetos, Decorator observa", "Decorator converte interface"],
        indexSolucao: 0,
        solucao: "Decorator adiciona comportamento; Proxy controla acesso ou fornece substitutos.",
        dificuldade: Dificuldade.dificil,
      ));

      // 5. Factory Method
      inserirPergunta(Pergunta(
        pergunta: "O que é o padrão Factory Method?",
        alternativas: ["Um método que instancia objetos, deixando subclasses decidirem qual", "Fábrica de famílias de objetos", "Padrão para mudanças de estado", "Singleton com thread safety"],
        indexSolucao: 0,
        solucao: "Factory Method define um método para criar objetos, delegando a subclasses a decisão de qual classe instanciar.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quando usar Factory Method ao invés de instanciar diretamente?",
        alternativas: ["Quando for criar muitos objetos simples", "Quando subclasses devem decidir o tipo de objeto a criar", "Para aplicar padrão Observer", "Para criar singletons"],
        indexSolucao: 1,
        solucao: "Use Factory Method quando quiser que subclasses decidam qual objeto concreto criar.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual a diferença entre Factory Method e Abstract Factory?",
        alternativas: ["Factory Method cria um produto único; Abstract Factory cria famílias de produtos", "Ambos são idênticos", "Factory usa composição, Abstract herança", "Nenhuma diferença"],
        indexSolucao: 0,
        solucao: "Factory Method é para um único produto via herança; Abstract Factory para famílias de produtos via composição.",
        dificuldade: Dificuldade.dificil,
      ));

      // 6. Observer
      inserirPergunta(Pergunta(
        pergunta: "O que faz o padrão Observer?",
        alternativas: ["Garante criação única de objeto", "Define dependência um-para-muitos para notificações automáticas", "Encapsula famílias de objetos", "Controla acesso via proxy"],
        indexSolucao: 1,
        solucao: "Observer define uma relação um-para-muitos onde, quando um objeto muda, todos são notificados.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Dê um exemplo de uso do Observer em sistemas de pedidos.",
        alternativas: ["Pedido instancia inventário diretamente", "Inventário e envio se registram como observadores do pedido", "Pedido é singleton", "Pedido observa o inventário"],
        indexSolucao: 1,
        solucao: "No Observer, inventário e envio se registram como observadores e são notificados quando há novo pedido.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quais problemas podem surgir com muitos observadores e como mitigar?",
        alternativas: ["Nenhum; sempre seguro", "Pode haver vazamento de memória ou alta latência; use remoção e notificações assíncronas", "Faz single thread", "Sempre usar proxies"],
        indexSolucao: 1,
        solucao: "Com muitos observadores pode haver vazamento de memória ou lentidão; mitiga removendo observadores inativos e usando notificação assíncrona.",
        dificuldade: Dificuldade.dificil,
      ));

      // 7. Singleton
      inserirPergunta(Pergunta(
        pergunta: "Qual o propósito do padrão Singleton?",
        alternativas: ["Criar famílias de objetos", "Garantir que uma classe tenha apenas uma instância", "Observar mudanças de estado", "Adicionar funcionalidades dinamicamente"],
        indexSolucao: 1,
        solucao: "Singleton garante que apenas uma instância de uma classe exista durante a execução.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quais desvantagens do Singleton e como contorná-las?",
        alternativas: ["Não existem", "Torna testes difíceis e acoplamento; contornar com injeção de dependência", "Usar muito cache", "Só funciona em Java"],
        indexSolucao: 1,
        solucao: "Singleton pode dificultar testes e causar acoplamento; contorna-se usando injeção de dependência ou interfaces.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como implementar Singleton thread-safe?",
        alternativas: ["Com double-checked locking ou init-on-demand holder", "Só declarando estático", "Usando observer", "Com factory method"],
        indexSolucao: 0,
        solucao: "Use double-checked locking ou holder idiom para garantir thread-safety no Singleton.",
        dificuldade: Dificuldade.dificil,
      ));

      // 8. State
      inserirPergunta(Pergunta(
        pergunta: "O que o padrão State permite?",
        alternativas: ["Notificar múltiplos observadores", "Mudar comportamento de um objeto quando seu estado interno muda", "Converter interfaces", "Criar singletons"],
        indexSolucao: 1,
        solucao: "State permite que um objeto mude seu comportamento dependendo do seu estado interno.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como o State difere do Strategy?",
        alternativas: ["State usa herança, Strategy composição", "State permite mudança interna de estado, Strategy troca de algoritmo externamente", "São iguais", "Strategy observa estados"],
        indexSolucao: 1,
        solucao: "State altera comportamento internamente conforme o estado muda; Strategy escolhe algoritmo externamente.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Descreva um cenário em jogo onde State é aplicado.",
        alternativas: ["Jogo com menus estáticos", "IA de inimigo muda comportamento conforme próximo ao jogador", "Singleton para config", "Adapter para entrada"],
        indexSolucao: 1,
        solucao: "Por exemplo, um inimigo que muda de comportamento (patrulha, persegue, ataca) conforme o estado, implementa State.",
        dificuldade: Dificuldade.dificil,
      ));

      // 9. Strategy
      inserirPergunta(Pergunta(
        pergunta: "Qual é o objetivo do padrão Strategy?",
        alternativas: ["Garantir instância única", "Encapsular família de algoritmos e torná-los intercambiáveis", "Observar mudanças de objetos", "Converter interfaces"],
        indexSolucao: 1,
        solucao: "Strategy encapsula algoritmos distintos, permitindo trocá-los em tempo de execução.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quais classes compõem a estrutura do Strategy?",
        alternativas: ["Context, Strategy, ConcreteStrategy", "Singleton, Factory, Observer", "Adapter, Decorator, Proxy", "State, Context, Implementation"],
        indexSolucao: 0,
        solucao: "A estrutura típica inclui Context, Strategy (interface/abstrata) e várias ConcreteStrategy.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quando Strategy e State se confundem? Como escolher?",
        alternativas: ["Nunca se confundem", "Ambos trocam comportamento; use State quando o objeto muda internamente, Strategy quando escolha externa de algoritmo", "Use sempre Strategy", "Use Singleton primeiro"],
        indexSolucao: 1,
        solucao: "Eles se confundem porque ambos abstraem comportamento; escolha State para mudança em tempo de execução pelo próprio objeto, Strategy para variar algoritmo via injeção.",
        dificuldade: Dificuldade.dificil,
      ));

  }

  void popularQuestoes2(){
    void popularBanco(){
      // 1. Abstract Factory
      inserirPergunta(Pergunta(
        pergunta: "Em que situação faria sentido trocar uma Abstract Factory em tempo de execução?",
        alternativas: ["Quando queremos mudar o tema visual do jogo", "Nunca se costuma trocar factories", "Apenas em testes unitários", "Nunca no ciclo de vida do app"],
        indexSolucao: 0,
        solucao: "Trocar a factory permite alternar famílias de objetos, como mudar o tema (skins, efeitos) sem alterar o cliente.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual vantagem a Abstract Factory oferece sobre um simples switch-case para criação de objetos?",
        alternativas: ["Permite adicionar novos produtos sem editar o cliente", "É sempre mais rápido", "Evita loops", "Permite multi-threading"],
        indexSolucao: 0,
        solucao: "Ao usar Abstract Factory, adicionar novos produtos não requer alterações no cliente, respeitando o OCP.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual risco você enfrenta ao implementar Abstract Factory incorretamente?",
        alternativas: ["Duplicação de código se factories redundantes forem usadas", "Aumento de performance sem benefício", "Quebra de encapsulamento do singleton", "Interferência com o Garbage Collector"],
        indexSolucao: 0,
        solucao: "Criar várias factories redundantes sem necessidade pode gerar duplicação de código e complexidade desnecessária.",
        dificuldade: Dificuldade.dificil,
      ));

      // 2. Adapter
      inserirPergunta(Pergunta(
        pergunta: "Qual sinal indica que um Adapter pode ter sido mal utilizado?",
        alternativas: ["Cliente começa a conhecer métodos internos do adaptee", "O código fica mais modular", "Melhora a testabilidade", "Mantém compatibilidade antiga"],
        indexSolucao: 0,
        solucao: "Se o cliente acessa métodos do adaptee pelo adapter, o padrão foi mal aplicado.",
        dificuldade: Dificuldade.dificil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Em que caso usar Adapter é preferível ao escrever um novo wrapper completo?",
        alternativas: ["Quando já temos uma implementação que funciona parcialmente", "Quando precisamos de performance máxima", "Para multithreading", "Quando não queremos herança"],
        indexSolucao: 0,
        solucao: "Adapter reaproveita implementação existente, suficiente para adaptar o necessário sem reescrever tudo.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Por que a composição é preferida à herança no Adapter?",
        alternativas: ["Evita acoplamento rígido com o adaptee", "É sempre mais rápida", "Torça menos bytes na memória", "Permite múltiplas interfaces"],
        indexSolucao: 0,
        solucao: "Composição desacopla o adapter da classe adaptada, evitando dependência da hierarquia de herança.",
        dificuldade: Dificuldade.medio,
      ));

      // 3. Bridge
      inserirPergunta(Pergunta(
        pergunta: "Qual problema surge sem Bridge quando se combinam múltiplas abstrações e implementações?",
        alternativas: ["Explosão de subclasses", "Herança múltipla", "Deadlocks", "Perda de encapsulamento"],
        indexSolucao: 0,
        solucao: "Sem Bridge, criamos subclasses para cada combinação possível de abstração/implementação.",
        dificuldade: Dificuldade.facil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Bridge seria desnecessário se tivéssemos ___ ?",
        alternativas: ["herança múltipla funcional", "algoritmo genérico", "garbage collector", "inversão de controle"],
        indexSolucao: 0,
        solucao: "Com herança múltipla poderíamos derivar diretamente implementações específicas sem composição.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como Bridge ajuda em testes unitários?",
        alternativas: ["Mocka implementores separadamente", "Evita interfaces", "Torna tudo singleton", "Faz logs automáticos"],
        indexSolucao: 0,
        solucao: "Ao separar abstração e implementação, permite mockar a implementação sem mexer na abstração.",
        dificuldade: Dificuldade.dificil,
      ));

      // 4. Decorator
      inserirPergunta(Pergunta(
        pergunta: "Qual indício sugere que Decorator foi aplicado corretamente?",
        alternativas: ["O componente base não sabe dos decorators", "Sempre aumenta complexidade", "Reduz performance drasticamente", "Faz caching automático"],
        indexSolucao: 0,
        solucao: "Se o componente base funciona sem conhecer os decorators, então o padrão está bem aplicado.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Por que Decorator é preferível a subclassing em certos casos?",
        alternativas: ["Permite adicionar funções optional em qualquer combinação", "Menos linhas de código", "Garante instância apenas", "Facilita serialização"],
        indexSolucao: 0,
        solucao: "Decorator permite compor comportamentos optional dinamicamente, sem explodir hierarquia.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Que cuidado deve se tomar para não sobrecarregar decorators?",
        alternativas: ["Não produzir loops de wrappers desnecessários", "Sempre usar herança depois", "Evitar composition over inheritance", "Evitar interfaces"],
        indexSolucao: 0,
        solucao: "Encadear muitos decorators sem necessidade pode gerar wrappers profundos e difícil depuração.",
        dificuldade: Dificuldade.dificil,
      ));

      // 5. Factory Method
      inserirPergunta(Pergunta(
        pergunta: "Qual é a principal responsabilidade de um Creator no Factory Method?",
        alternativas: ["Delegar construção a subclasses", "Garantir thread safety", "Serializar objetos", "Gerar código de teste"],
        indexSolucao: 0,
        solucao: "Creator delega a criação de objetos para subclasses, sem saber a classe concreta.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Factory Method pode violar o princípio de Liskov se ___?",
        alternativas: ["subclasse retornar tipo inesperado", "usar composição", "envolver objeto", "usar static"],
        indexSolucao: 0,
        solucao: "Se a subclasse retornar tipo que não é substituível, LSP é violado.",
        dificuldade: Dificuldade.dificil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Em qual situação adicionar uma factory method não traz benefício real?",
        alternativas: ["quando só existe um produto concreto", "quando há família de produtos", "em multithreading", "em GUI"],
        indexSolucao: 0,
        solucao: "Se somente um produto é criado, a factory method adiciona complexidade sem ganho.",
        dificuldade: Dificuldade.medio,
      ));

      // 6. Observer
      inserirPergunta(Pergunta(
        pergunta: "Por que usar referências fracas em Observer?",
        alternativas: ["Evita memory leaks se observers não removidos", "Acelera notificações", "Evita deadlocks", "Não permite remoção manual"],
        indexSolucao: 0,
        solucao: "Referências fracas impedem leaks quando observers deixam de existir sem se desregistrar :contentReference[oaicite:1]{index=1}.",
        dificuldade: Dificuldade.dificil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Uma alternativa ao Observer para eventos simples é ___?",
        alternativas: ["callbacks diretos", "singleton", "adapter", "factory"],
        indexSolucao: 0,
        solucao: "Callbacks ou event emitters simples podem substituir Observer quando a lógica é simples.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Qual padrão garante que observers vejam estado consistente?",
        alternativas: ["notifyAll após mudança completa", "factory", "adapter", "decorator"],
        indexSolucao: 0,
        solucao: "Chamar notifyObservers depois de curso toda atualização garante consistência.",
        dificuldade: Dificuldade.facil,
      ));

      // 7. Singleton
      inserirPergunta(Pergunta(
        pergunta: "Como evitar criação acidental de múltiplas instâncias via serialização?",
        alternativas: ["implementar readResolve()", "usar deprecated", "usar new", "aplicar adapter"],
        indexSolucao: 0,
        solucao: "O método readResolve() garante que a instância desserializada seja a única existente :contentReference[oaicite:2]{index=2}.",
        dificuldade: Dificuldade.dificil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Em que situação um Singleton pode acabar mascarando má arquitetura?",
        alternativas: ["quando usado como variável global", "quando bem testado", "quando usado em logging", "quando lazy"],
        indexSolucao: 0,
        solucao: "Transformar um objeto em variável global via Singleton pode aumentar acoplamento do sistema.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quando implementar singleton via enum (Java)?",
        alternativas: ["Quando se quer prevenção automática contra reflexão e serialização", "Sempre causa exceção", "Não funciona em testes", "Só para DI"],
        indexSolucao: 0,
        solucao: "Enum previne reflexão e serialização que quebram o singleton.",
        dificuldade: Dificuldade.medio,
      ));

      // 8. State
      inserirPergunta(Pergunta(
        pergunta: "Como State pode substituir longos blocos if/switch?",
        alternativas: ["Cada estado tem sua lógica encapsulada", "Criando singletons", "Usando herança múltipla", "Evitar composition"],
        indexSolucao: 0,
        solucao: "State encapsula comportamento por estado, evitando condições espalhadas.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "State exige que os estados conheçam o Context?",
        alternativas: ["Somente se devem delegar transições", "Sempre", "Nunca", "Só em Singleton"],
        indexSolucao: 0,
        solucao: "Geralmente os estados referenciam o Context para poder fazer transições internas.",
        dificuldade: Dificuldade.dificil,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Por que usar State em jogos com IA de agentes?",
        alternativas: ["Permite comportamentos clonáveis e troca dinâmica conforme eventos", "Evita factory", "Melhora threading", "Simplifica singletons"],
        indexSolucao: 0,
        solucao: "Agentes podem trocar estados (patrulha, combate, fuga) sem ifs extensos.",
        dificuldade: Dificuldade.facil,
      ));

      // 9. Strategy
      inserirPergunta(Pergunta(
        pergunta: "Que vantagem Strategy oferece sobre if/else no runtime?",
        alternativas: ["Troca de algoritmo em execução sem recompilar", "Maior número de linhas", "Útil apenas em C++", "Garante thread safety"],
        indexSolucao: 0,
        solucao: "Strategy permite alternar algoritmos em tempo de execução via injeção de implementação.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Quando Strategy pode ser um exagero?",
        alternativas: ["Para apenas uma única implementação possível", "Quando se usam enums", "Em GUI", "Em serialização"],
        indexSolucao: 0,
        solucao: "Se não há variantes de algoritmo, usar Strategy adiciona abstração desnecessária.",
        dificuldade: Dificuldade.medio,
      ));
      inserirPergunta(Pergunta(
        pergunta: "Como Strategy difere de Command?",
        alternativas: ["Strategy encapsula algoritmo; Command encapsula ação com contexto e histórico", "São idênticos", "Strategy notifica observer", "Command converte interfaces"],
        indexSolucao: 0,
        solucao: "Strategy define algoritmo; Command representa operações (para log, undo, enfileiramento).",
        dificuldade: Dificuldade.dificil,
      ));
    }

  }

  void popularBancoArrasto() {
    final mapaDiagramas = AssetsUrl.obterDiagramas();

    final random = Random(DateTime.now().millisecondsSinceEpoch);

    final db = database;
    db.then((dbInstance) => dbInstance.delete('questoes_arrasto')); // Deletar todas as perguntas arrasto antes de popular
    // Para gerar novas combinações por gameplay

    for(int i = 0; i < 3;i++) { // Inserir pelo menos 3 perguntas
      // Embaralha as entradas e pega 3 diferentes
      final entradasEmbaralhadas = mapaDiagramas.entries.toList()
        ..shuffle(random);
      final selecionados = entradasEmbaralhadas.take(3).toList();

      // Prepara os dados da pergunta
      final caminhosImagens = selecionados.map((e) => e.value).toList();
      final alternativas = selecionados.map((e) => e.key).toList();
      final ordemCorreta = List.generate(3, (index) => index); // 0,1,2

      // Cria e insere a pergunta
      inserirPerguntaArrasto(
        PerguntaArrasto(
          caminhosImagens: caminhosImagens,
          ordemCorreta: ordemCorreta,
          alternativas: alternativas,
        ),
      );
    }
  }
}
