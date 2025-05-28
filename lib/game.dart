import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/reader/tiled_asset_reader.dart';
import 'package:bonfire/widgets/bonfire_widget.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:jogo_tabuleiro/components/GameController.dart';
import 'package:jogo_tabuleiro/components/HudDoJogador.dart';
import 'package:jogo_tabuleiro/components/Player.dart';
import 'package:jogo_tabuleiro/domain/Atlas.dart';
import 'components/LocalDePergunta.dart';
import 'components/StatusDoJogador.dart';
import 'domain/MapTile.dart';
import 'domain/Mapa.dart';

class BoardGame extends StatefulWidget {
  BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  final GameController controller = GameController();

  final StatusDoJogador status = StatusDoJogador();

  int mapaAtual = 0;

  @override
  Widget build(BuildContext context) {

    // controller.atlas.atual = controller.getMapaPorIndice(mapaAtual);
    return MapNavigator( // O map navigator vai dar a possíbilidade de navegar entre mapas.
      initialMap: '/mapa-floresta',
      maps: {
        '/mapa-floresta':(context,args) => MapItem(
            id: 'map1',
            map: WorldMapByTiled(
              WorldMapReader.fromAsset(controller.atlas.mapas[0].caminhoDoArquivo),
            ),
          properties: {
            'mapa': controller.atlas.mapas[0],
            'caminhoPrincipal': controller.atlas.mapas[0].caminhoPrincipal,
          },
        ),
        '/mapa-agua':(context,args) => MapItem(
            id: 'map2',
            map: WorldMapByTiled(
              WorldMapReader.fromAsset(controller.atlas.mapas[1].caminhoDoArquivo),
            ),
          properties: {
            'mapa': controller.atlas.mapas[1],
            'caminhoPrincipal': controller.atlas.mapas[1].caminhoPrincipal,
          },
        ),
      },
      builder: (context, arguments, map) {

        return BonfireWidget(
          map: map.map,
          cameraConfig: CameraConfig(
              moveOnlyMapArea: true, // true
              initialMapZoomFit: InitialMapZoomFitEnum.fitWidth,
              initPosition: Mapa.centroDoMapa
          ),

          player: Jogador(
              position: map.properties['caminhoPrincipal'][0].position,
              size: Jogador.JogadorSize,
              mapa:  map.properties['mapa'],
              indexDePerguntas: controller.atlas.indiceDePerguntas,
              statusDoJogador: status
          ),

          onReady: (BonfireGameInterface gameRef) async {
            print("O Jogo está pronto!");

            setState(() {
              gameRef.map.removeWhere((c) => c is LocalDePergunta); // Retira as perguntas do mapa antigo
              controller.atlas.atual = controller.getMapaPorIndice(mapaAtual);
              controller.gerarPerguntas(gameRef);

            });
            //

            mapaAtual++;

            print("Mapa Atual: $mapaAtual");
          },

          hudComponents: [HudDoJogador(status)],

        );
      }
    );
  }
}

