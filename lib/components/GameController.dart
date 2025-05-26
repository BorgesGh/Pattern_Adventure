import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:jogo_tabuleiro/domain/Mapa.dart';

import '../domain/Atlas.dart';

class GameController extends GameComponent{

  var atlas = Atlas();


  @override
  void onMount() {
    print(gameRef.map);
    super.onMount();
  }


  Vector2 getPosicaoInicial(){
    return atlas.atual.caminhoPrincipal[0];
  }


  Mapa getProximoMapa(){
    return atlas.atual;
  }

}