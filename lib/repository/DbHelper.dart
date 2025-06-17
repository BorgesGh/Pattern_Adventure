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
        'header_imagem': pergunta.headerImagem ?? '',
        'solucao_imagem': pergunta.solucaoImagem ?? '',
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
        headerImagem: row['header_imagem'] as String?,
        solucaoImagem: row['solucao_imagem'] as String?,
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
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM questoes_arrasto');
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) return null;

    // Gera um offset aleatório
    final random = Random();
    final offset = random.nextInt(count);

    // Busca 1 pergunta com o offset aleatório
    final resultado = await db.rawQuery(
        'SELECT * FROM questoes_arrasto LIMIT 1 OFFSET ?',
        [offset]
    );

    if (resultado.isEmpty) return null;

    return PerguntaArrasto.fromMap(resultado.first);
  }


  void popularQuestoes(){
    // 1. Abstract Factory
    inserirPergunta(Pergunta(
      pergunta: "Qual é o objetivo principal do padrão Abstract Factory?",
      alternativas: ["Implementar herança múltipla", "Criar famílias de objetos relacionados sem expor classes concretas", "Serializar objetos", "Instanciar uma classe específica diretamente"],
      indexSolucao: 1,
      solucao: "O padrão Abstract Factory permite criar famílias de objetos relacionados sem expor suas classes concretas.",
      headerImagem: AssetsUrl.diagrama_abstract_factory,
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como o Abstract Factory promove a independência de implementação?",
      alternativas: ["Utilizando singletons globais", "Através de uma fábrica abstrata que encapsula várias factory methods", "Com mixins", "Usando herança para subclasses decidirem"],
      indexSolucao: 1,
      solucao: "Ele utiliza uma fábrica abstrata que encapsula factory methods para criar diferentes objetos, promovendo desacoplamento.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quando você usaria Abstract Factory invés de Factory Method?",
      alternativas: ["Quando não há subclasses", "Para implementar proxy de objetos", "Para criar famílias de produtos relacionados", "Para criar apenas um tipo de objeto"],
      indexSolucao: 2,
      solucao: "Use Abstract Factory quando precisar criar famílias de objetos relacionados; Factory Method serve para criar um único tipo via herança.",
      dificuldade: Dificuldade.dificil,
    ));

    // 2. Adapter
    inserirPergunta(Pergunta(
      pergunta: "O que o padrão Adapter faz?",
      alternativas: ["Gerencia estados internos", "Adiciona comportamento via herança", "Converte a interface de uma classe para outra", "Cria objetos em família"],
      indexSolucao: 2,
      solucao: "O Adapter converte a interface de uma classe existente para outra que o cliente espera.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quais são os tipos de escopo do padrão Adapter?",
      alternativas: ["De encapsulamento e de herança múltipla", "De método default e método linear", "De classe e de objeto", "De interface e de atributo"],
      indexSolucao: 2,
      solucao: "Você pode implementar Adapter por herança (class adapter) ou por composição (object adapter).",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual a diferença principal entre Adapter e Decorator?",
      alternativas: ["Decorator converte interfaces também", "Ambos fazem a mesma coisa", "Adapter altera interface, Decorator adiciona comportamento", "Adapter cria objetos, Decorator observa objetos"],
      indexSolucao: 2,
      solucao: "Adapter altera a interface de um objeto existente; Decorator adiciona responsabilidades sem mudar a interface.",
      dificuldade: Dificuldade.dificil,
    ));

    // 3. Bridge
    inserirPergunta(Pergunta(
      pergunta: "Qual a motivação do padrão Bridge?",
      alternativas: ["Notificar mudanças de estado", "Garantir instância única", "Desacoplar abstração da implementação para variar ambos independentes", "Converter interfaces incompatíveis"],
      indexSolucao: 2,
      solucao: "O Bridge desacopla abstração e implementação, permitindo que variem independentemente.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como o Bridge evita a explosão de subclasses?",
      alternativas: ["Utilizando herança múltipla", "Apenas documentando o código", "Usando Singleton", "Separa hierarquia de abstração e implementação via composição"],
      indexSolucao: 3,
      solucao: "Ao separar abstração e implementação, evita criar subclasses para cada combinação possível.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Dê um exemplo real de uso de Bridge com as hierarquias Abstraction e Implementor.",
      alternativas: ["Observer para eventos", "Singleton para configuração global", "Adapter entre APIs", "GUI com tema e componente independentes"],
      indexSolucao: 3,
      solucao: "Em uma GUI, a abstração é o componente (e.g. janela), e a implementação é a plataforma (Windows/Linux), variando separadamente.",
      dificuldade: Dificuldade.dificil,
    ));

    // 4. Decorator
    inserirPergunta(Pergunta(
      pergunta: "Qual a finalidade do padrão Decorator?",
      alternativas: ["Garantir uma única instância", "Detectar mudanças de estado", "Adicionar responsabilidades a um objeto dinamicamente", "Encapsular famílias de criação"],
      indexSolucao: 2,
      solucao: "Decorator permite adicionar responsabilidades a um objeto de forma dinâmica, sem alterar sua classe.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como adicionar comportamentos dinamicamente a uma pizza via Decorator?",
      alternativas: ["Usar static methods", "Envolver o objeto pizza em decorators como queijo, calabresa etc.", "Criar subclasses para cada tipo", "Usar factory para instanciar"],
      indexSolucao: 1,
      solucao: "Você encapsula a pizza com decorators como queijo, calabresa, cada um adicionando seu comportamento.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual a diferença entre Decorator e Proxy?",
      alternativas: ["Proxy cria objetos, Decorator observa", "Decorator converte interface", "Decorator altera comportamento, Proxy controla acesso", "Ambos fazem a mesma coisa"],
      indexSolucao: 2,
      solucao: "Decorator adiciona comportamento; Proxy controla acesso ou fornece substitutos.",
      dificuldade: Dificuldade.dificil,
    ));

    // 5. Factory Method
    inserirPergunta(Pergunta(
      pergunta: "O que é o padrão Factory Method?",
      alternativas: ["Padrão para mudanças de estado", "Fábrica de famílias de objetos", "Um método que instancia objetos, deixando subclasses decidirem qual", "Singleton com thread safety"],
      indexSolucao: 2,
      solucao: "Factory Method define um método para criar objetos, delegando a subclasses a decisão de qual classe instanciar.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quando usar Factory Method ao invés de instanciar diretamente?",
      alternativas: ["Para aplicar padrão Observer", "Para criar singletons", "Quando subclasses devem decidir o tipo de objeto a criar", "Quando for criar muitos objetos simples"],
      indexSolucao: 2,
      solucao: "Use Factory Method quando quiser que subclasses decidam qual objeto concreto criar.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual a diferença entre Factory Method e Abstract Factory?",
      alternativas: ["Factory usa composição, Abstract herança", "Factory Method cria um produto único; Abstract Factory cria famílias de produtos", "Nenhuma diferença", "Ambos são idênticos"],
      indexSolucao: 1,
      solucao: "Factory Method é para um único produto via herança; Abstract Factory para famílias de produtos via composição.",
      dificuldade: Dificuldade.dificil,
    ));

    // 6. Observer
    inserirPergunta(Pergunta(
      pergunta: "O que faz o padrão Observer?",
      alternativas: ["Controla acesso via proxy", "Define dependência um-para-muitos para notificações automáticas", "Encapsula famílias de objetos", "Garante criação única de objeto"],
      indexSolucao: 1,
      solucao: "Observer define uma relação um-para-muitos onde, quando um objeto muda, todos são notificados.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Dê um exemplo de uso do Observer em sistemas de pedidos.",
      alternativas: ["Pedido é singleton", "Inventário e envio se registram como observadores do pedido", "Pedido observa o inventário", "Pedido instancia inventário diretamente"],
      indexSolucao: 1,
      solucao: "No Observer, inventário e envio se registram como observadores e são notificados quando há novo pedido.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quais problemas podem surgir com muitos observadores e como mitigar?",
      alternativas: ["Sempre usar proxies", "Pode haver vazamento de memória ou alta latência; use remoção e notificações assíncronas", "Faz single thread", "Nenhum; sempre seguro"],
      indexSolucao: 1,
      solucao: "Com muitos observadores pode haver vazamento de memória ou lentidão; mitiga removendo observadores inativos e usando notificação assíncrona.",
      dificuldade: Dificuldade.dificil,
    ));

    // 7. Singleton
    inserirPergunta(Pergunta(
      pergunta: "Qual o propósito do padrão Singleton?",
      alternativas: ["Observar mudanças de estado", "Garantir que uma classe tenha apenas uma instância", "Adicionar funcionalidades dinamicamente", "Criar famílias de objetos"],
      indexSolucao: 1,
      solucao: "Singleton garante que apenas uma instância de uma classe exista durante a execução.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quais desvantagens do Singleton e como contorná-las?",
      alternativas: ["Só funciona em Java", "Torna testes difíceis e acoplamento; contornar com injeção de dependência", "Usar muito cache", "Não existem"],
      indexSolucao: 1,
      solucao: "Singleton pode dificultar testes e causar acoplamento; contorna-se usando injeção de dependência ou interfaces.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como implementar Singleton thread-safe?",
      alternativas: ["Usando observer", "Com factory method", "Com double-checked locking ou init-on-demand holder", "Só declarando estático"],
      indexSolucao: 2,
      solucao: "Use double-checked locking ou holder idiom para garantir thread-safety no Singleton.",
      dificuldade: Dificuldade.dificil,
    ));

    // 8. State
    inserirPergunta(Pergunta(
      pergunta: "O que o padrão State permite?",
      alternativas: ["Criar singletons", "Converter interfaces", "Mudar comportamento de um objeto quando seu estado interno muda", "Notificar múltiplos observadores"],
      indexSolucao: 2,
      solucao: "State permite que um objeto mude seu comportamento dependendo do seu estado interno.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como o State difere do Strategy?",
      alternativas: ["Strategy observa estados", "State usa herança, Strategy composição", "State permite mudança interna de estado, Strategy troca de algoritmo externamente", "São iguais"],
      indexSolucao: 2,
      solucao: "State altera comportamento internamente conforme o estado muda; Strategy escolhe algoritmo externamente.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Descreva um cenário em jogo onde State é aplicado.",
      alternativas: ["Singleton para config", "IA de inimigo muda comportamento conforme próximo ao jogador", "Adapter para entrada", "Jogo com menus estáticos"],
      indexSolucao: 1,
      solucao: "Por exemplo, um inimigo que muda de comportamento (patrulha, persegue, ataca) conforme o estado, implementa State.",
      dificuldade: Dificuldade.dificil,
    ));

    // 9. Strategy
    inserirPergunta(Pergunta(
      pergunta: "Qual é o objetivo do padrão Strategy?",
      alternativas: ["Observar mudanças de objetos", "Encapsular família de algoritmos e torná-los intercambiáveis", "Converter interfaces", "Garantir instância única"],
      indexSolucao: 1,
      solucao: "Strategy encapsula algoritmos distintos, permitindo trocá-los em tempo de execução.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quais classes compõem a estrutura do Strategy?",
      alternativas: ["State, Context, Implementation", "Context, Strategy, ConcreteStrategy", "Adapter, Decorator, Proxy", "Singleton, Factory, Observer"],
      indexSolucao: 1,
      solucao: "A estrutura típica inclui Context, Strategy (interface/abstrata) e várias ConcreteStrategy.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quando Strategy e State se confundem? Como escolher?",
      alternativas: ["Use Singleton primeiro", "Nunca se confundem", "Use sempre Strategy", "Ambos trocam comportamento; use State quando o objeto muda internamente, Strategy quando escolha externa de algoritmo"],
      indexSolucao: 3,
      solucao: "Eles se confundem porque ambos abstraem comportamento; escolha State para mudança em tempo de execução pelo próprio objeto, Strategy para variar algoritmo via injeção.",
      dificuldade: Dificuldade.dificil,
    ));
  }

  void popularQuestoes2(){
    // 1. Abstract Factory
    inserirPergunta(Pergunta(
      pergunta: "Em que situação faria sentido trocar uma Abstract Factory em tempo de execução?",
      alternativas: ["Apenas em testes unitários", "Quando queremos mudar o tema visual do jogo", "Nunca no ciclo de vida do app", "Nunca se costuma trocar factories"],
      indexSolucao: 1,
      solucao: "Trocar a factory permite alternar famílias de objetos, como mudar o tema (skins, efeitos) sem alterar o cliente.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual vantagem a Abstract Factory oferece sobre um simples switch-case para criação de objetos?",
      alternativas: ["Permite multi-threading", "É sempre mais rápido", "Permite adicionar novos produtos sem editar o cliente", "Evita loops"],
      indexSolucao: 2,
      solucao: "Ao usar Abstract Factory, adicionar novos produtos não requer alterações no cliente, respeitando o OCP.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual risco você enfrenta ao implementar Abstract Factory incorretamente?",
      alternativas: ["Interferência com o Garbage Collector", "Aumento de performance sem benefício", "Duplicação de código se factories redundantes forem usadas", "Quebra de encapsulamento do singleton"],
      indexSolucao: 2,
      solucao: "Criar várias factories redundantes sem necessidade pode gerar duplicação de código e complexidade desnecessária.",
      dificuldade: Dificuldade.dificil,
    ));

    // 2. Adapter
    inserirPergunta(Pergunta(
      pergunta: "Qual sinal indica que um Adapter pode ter sido mal utilizado?",
      alternativas: ["O código fica mais modular", "Cliente começa a conhecer métodos internos do adaptee", "Melhora a testabilidade", "Mantém compatibilidade antiga"],
      indexSolucao: 1,
      solucao: "Se o cliente acessa métodos do adaptee pelo adapter, o padrão foi mal aplicado.",
      dificuldade: Dificuldade.dificil,
    ));
    inserirPergunta(Pergunta(
        pergunta: "Em que caso usar Adapter é preferível ao escrever um novo wrapper (componente que encapsula outro objeto ou sistema) completo?",
        alternativas: ["Para multithreading", "Quando já temos uma implementação que funciona parcialmente", "Quando precisamos de performance máxima", "Quando não queremos herança"],
        indexSolucao: 1,
        solucao: "Adapter reaproveita implementação existente, suficiente para adaptar o necessário sem reescrever tudo.",
        dificuldade: Dificuldade.medio,
        headerImagem: AssetsUrl.diagrama_pergunta_adapter_wrapper
    ));
    inserirPergunta(Pergunta(
      pergunta: "Por que a composição é preferida à herança no Adapter?",
      alternativas: ["Permite múltiplas interfaces", "É sempre mais rápida", "Evita acoplamento rígido com o adaptee", "Torça menos bytes na memória"],
      indexSolucao: 2,
      solucao: "Composição desacopla o adapter da classe adaptada, evitando dependência da hierarquia de herança.",
      dificuldade: Dificuldade.medio,
    ));

    // 3. Bridge
    inserirPergunta(Pergunta(
      pergunta: "Qual problema surge sem Bridge quando se combinam múltiplas abstrações e implementações?",
      alternativas: ["Deadlocks", "Explosão de subclasses", "Perda de encapsulamento", "Herança múltipla"],
      indexSolucao: 1,
      solucao: "Sem Bridge, criamos subclasses para cada combinação possível de abstração/implementação.",
      dificuldade: Dificuldade.facil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Bridge seria desnecessário se tivéssemos ___ ?",
      alternativas: ["garbage collector", "herança múltipla funcional", "inversão de controle", "algoritmo genérico"],
      indexSolucao: 1,
      solucao: "Com herança múltipla poderíamos derivar diretamente implementações específicas sem composição.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como Bridge ajuda em testes unitários?",
      alternativas: ["Torna tudo singleton", "Mocka, ou seja, adiciona fixamente os dados dos implementores separadamente", "Faz logs automáticos", "Evita interfaces"],
      indexSolucao: 1,
      solucao: "Ao separar abstração e implementação, permite mockar a implementação sem mexer na abstração.",
      dificuldade: Dificuldade.dificil,
    ));

    // 4. Decorator
    inserirPergunta(Pergunta(
      pergunta: "Qual indício sugere que Decorator foi aplicado corretamente?",
      alternativas: ["Reduz performance drasticamente", "Faz caching automático", "O componente base não sabe dos decorators", "Sempre aumenta complexidade"],
      indexSolucao: 2,
      solucao: "Se o componente base funciona sem conhecer os decorators, então o padrão está bem aplicado.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Por que Decorator é preferível a subclassing em certos casos?",
      alternativas: ["Facilita serialização", "Menos linhas de código", "Permite adicionar funções optional em qualquer combinação", "Garante instância apenas"],
      indexSolucao: 2,
      solucao: "Decorator permite compor comportamentos optional dinamicamente, sem explodir hierarquia.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Que cuidado deve se tomar para não sobrecarregar decorators?",
      alternativas: ["Evitar interfaces", "Não produzir loops de wrappers desnecessários", "Sempre usar herança depois", "Evitar composition over inheritance"],
      indexSolucao: 1,
      solucao: "Encadear muitos decorators sem necessidade pode gerar wrappers profundos e difícil depuração.",
      dificuldade: Dificuldade.dificil,
    ));

    // 5. Factory Method
    inserirPergunta(Pergunta(
      pergunta: "Qual é a principal responsabilidade de um Creator no Factory Method?",
      alternativas: ["Serializar objetos", "Delegar construção a subclasses", "Gerar código de teste", "Garantir thread safety"],
      indexSolucao: 1,
      solucao: "Creator delega a criação de objetos para subclasses, sem saber a classe concreta.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Factory Method pode violar o princípio de Liskov se ___?",
      alternativas: ["envolver objeto", "subclasse retornar tipo inesperado", "usar static", "usar composição"],
      indexSolucao: 1,
      solucao: "Se a subclasse retornar tipo que não é substituível, LSP é violado.",
      dificuldade: Dificuldade.dificil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Em qual situação adicionar uma factory method não traz benefício real?",
      alternativas: ["quando há família de produtos", "em multithreading", "quando só existe um produto concreto", "em GUI"],
      indexSolucao: 2,
      solucao: "Se somente um produto é criado, a factory method adiciona complexidade sem ganho.",
      dificuldade: Dificuldade.medio,
    ));

    // 6. Observer
    inserirPergunta(Pergunta(
      pergunta: "Por que usar referências fracas em Observer?",
      alternativas: ["Não permite remoção manual", "Evita memory leaks, ou seja, objetos serão liberados da memória após não serem mais necessários", "Acelera notificações", "Evita deadlocks"],
      indexSolucao: 1,
      solucao: "Referências fracas impedem leaks quando observers deixam de existir sem se desregistrar.",
      dificuldade: Dificuldade.dificil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Uma alternativa ao Observer para eventos simples é ___?",
      alternativas: ["singleton", "callbacks diretos", "factory", "adapter"],
      indexSolucao: 1,
      solucao: "Callbacks ou event emitters simples podem substituir Observer quando a lógica é simples.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual estratégia garante que observers vejam estado consistente?",
      alternativas: ["A inclusão de um Adapter", "O uso de um Decorator", "NotifyAll (notificar a todos) após mudança completa", "A criação de objetos usando Factory"],
      indexSolucao: 2,
      solucao: "Chamar notifyObservers depois de curso toda atualização garante consistência.",
      dificuldade: Dificuldade.facil,
    ));

    // 7. Singleton
    inserirPergunta(Pergunta(
      pergunta: "Em que situação um Singleton pode acabar mascarando má arquitetura?",
      alternativas: ["quando usado em logging", "quando lazy", "quando usado como variável global", "quando bem testado"],
      indexSolucao: 2,
      solucao: "Transformar um objeto em variável global via Singleton pode aumentar acoplamento do sistema.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Qual padrão de projeto mais se assemelha com a descrição: \'Durante o uso do sistema, é necessário que seja registrado Logs de tudo que ocorre, ou seja durante todo o funcionamento do programa é necessário que essa funcionalidade esteja ativa e com a mesma instância.\'?",
      alternativas: ["Padrão Adapter", "Nenhum dos anteriores", "Padrão Singleton", "Padrão State"],
      indexSolucao: 2,
      solucao: "Enum previne reflexão e serialização que quebram o singleton.",
      dificuldade: Dificuldade.medio,
    ));

    // 8. State
    inserirPergunta(Pergunta(
      pergunta: "Como State pode substituir longos blocos if/switch?",
      alternativas: ["Usando herança múltipla", "Cada estado tem sua lógica encapsulada", "Criando singletons", "Evitar composition"],
      indexSolucao: 1,
      solucao: "State encapsula comportamento por estado, evitando condições espalhadas.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "No padrão State, como os Estados (State) normalmente interagem com o Contexto (Context)?",
      alternativas: ["Só interagem com o Contexto em padrões", "Referenciam o Contexto para gerenciar transições de estado", "O Contexto sempre delega toda a lógica para os Estados", "Nunca acessam o Contexto diretamente"],
      indexSolucao: 1,
      solucao: "Geralmente os estados referenciam o Context para poder fazer transições internas.",
      dificuldade: Dificuldade.dificil,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Por que usar State em jogos com IA de agentes?",
      alternativas: ["Simplifica singletons", "Permite comportamentos clonáveis e troca dinâmica conforme eventos", "Melhora threading", "Evita factory"],
      indexSolucao: 1,
      solucao: "Agentes podem trocar estados (patrulha, combate, fuga) sem ifs extensos.",
      dificuldade: Dificuldade.facil,
    ));

    // 9. Strategy
    inserirPergunta(Pergunta(
      pergunta: "Que vantagem Strategy oferece sobre if/else no runtime?",
      alternativas: ["Garante thread safety", "Maior número de linhas", "Troca de algoritmo em execução sem recompilar", "Útil apenas em C++"],
      indexSolucao: 2,
      solucao: "Strategy permite alternar algoritmos em tempo de execução via injeção de implementação.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Quando Strategy pode ser um exagero?",
      alternativas: ["Em serialização", "Para apenas uma única implementação possível", "Em GUI", "Quando se usam enums"],
      indexSolucao: 1,
      solucao: "Se não há variantes de algoritmo, usar Strategy adiciona abstração desnecessária.",
      dificuldade: Dificuldade.medio,
    ));
    inserirPergunta(Pergunta(
      pergunta: "Como Strategy difere de Command?",
      alternativas: ["Command converte interfaces", "Strategy notifica observer", "Strategy encapsula algoritmo; Command encapsula ação com contexto e histórico", "São idênticos"],
      indexSolucao: 2,
      solucao: "Strategy define algoritmo; Command representa operações (para log, undo, enfileiramento).",
      dificuldade: Dificuldade.dificil,
    ));
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
