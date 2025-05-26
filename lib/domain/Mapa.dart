import 'package:bonfire/bonfire.dart';

class Mapa {

  String caminhoDoArquivo;
  String nomeMapa;
  List<Vector2> caminhoPrincipal;

  Mapa({
    required this.caminhoDoArquivo,
    required this.nomeMapa,
    required this.caminhoPrincipal,
  });

  void gerarPerguntas(){
    //TODO Gerar perguntas e adicionar no caminho do mapa
  }
}