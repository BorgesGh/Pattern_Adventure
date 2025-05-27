import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/base/layer.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/DialogPergunta.dart';
import 'package:jogo_tabuleiro/components/LocalDePergunta.dart';
import 'package:jogo_tabuleiro/domain/Mapa.dart';

import '../domain/Atlas.dart';

class GameController extends GameComponent{

  var atlas = Atlas();
  var pontuacao = 0;


  @override
  void onMount() {
    print(gameRef.map);

    atlas.gerarAreasDePergunta(); // Randomizar onde terá perguntas no mapa

    for (var element in atlas.atual.caminhoPrincipal) {
      if(element.pergunta != null) {
        // gameRef.add(Dialogpergunta(pergunta: element.pergunta!));
        gameRef.map.add(
          LocalDePergunta(
            cor: Colors.red,
            posicao: element.position,
          ),
        );
      }
    }
    super.onMount();
  }

  Vector2 getPosicaoInicial(){
    return atlas.atual.caminhoPrincipal[0].position;
  }

  Mapa getProximoMapa(){
    return atlas.atual;
  }

  Mapa getMapaPorIndice(int indice) {
    if (indice < atlas.mapas.length) {
      return atlas.mapas[indice];
    } else {
      throw Exception("Mapa não encontrado para o índice: $indice");
    }
  }
}