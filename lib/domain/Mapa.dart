import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/MapTile.dart';

class Mapa {

  static Vector2 centroDoMapa =  Vector2(15 * MapTile.tileSize, 9 * MapTile.tileSize);

  String caminhoDoArquivo;
  String nomeMapa;
  List<MapTile> caminhoPrincipal;

  get caminhoPrincipalVector2 => caminhoPrincipal.map((m) => m.position).toList();

  Mapa({
    required this.caminhoDoArquivo,
    required this.nomeMapa,
    required this.caminhoPrincipal,
  });

  void gerarPerguntas(){
    //TODO Gerar perguntas e adicionar no caminho do mapa
  }
}