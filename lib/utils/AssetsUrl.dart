class AssetsUrl {
  static const String joystick_background = 'assets/images/joystick_background.png';

  //Explicaçãoes

  static const String explicacao_1 = 'assets/images/explanations/explan_01.png';
  static const String explicacao_2 = 'assets/images/explanations/explan_02.png';

  //Sons e musicas

  static const String musica_normal = 'Soundtrack-normal.mp3';
  static const String musica_noite = 'Soundtrack-noite.mp3';

  static const String effect_acertou = 'Som-acerto-pergunta.wav';
  static const String effect_errou = 'Som-erro-pergunta.wav';

  static const String som_hit_inimigo = 'Som-hit-inimigo.wav';

  // Diagramas

  static const String diagrama_abstract_factory = 'assets/images/diagramas/AbstractFactory.png';
  static const String diagrama_adapter = 'assets/images/diagramas/Adapter.png';
  static const String diagrama_bridge = 'assets/images/diagramas/Bridge.png';
  static const String diagrama_decorator = 'assets/images/diagramas/Decorator.png';
  static const String diagrama_factory = 'assets/images/diagramas/Factory.png';
  static const String diagrama_observer = 'assets/images/diagramas/Observer.png';
  static const String diagrama_singleton = 'assets/images/diagramas/Singleton.png';
  static const String diagrama_state = 'assets/images/diagramas/State.png';
  static const String diagrama_strategy = 'assets/images/diagramas/Strategy.png';

  static Map<String, String> obterDiagramas() {
    return {
      'Abstract Factory': AssetsUrl.diagrama_abstract_factory,
      'Adapter': AssetsUrl.diagrama_adapter,
      'Bridge': AssetsUrl.diagrama_bridge,
      'Decorator': AssetsUrl.diagrama_decorator,
      'Factory': AssetsUrl.diagrama_factory,
      'Observer': AssetsUrl.diagrama_observer,
      'Singleton': AssetsUrl.diagrama_singleton,
      'State': AssetsUrl.diagrama_state,
      'Strategy': AssetsUrl.diagrama_strategy,
    };
  }


}