import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/reader/tiled_asset_reader.dart';
import 'package:bonfire/widgets/bonfire_widget.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogo_tabuleiro/components/GameController.dart';
import 'package:jogo_tabuleiro/components/Pesadelo.dart';
import 'package:jogo_tabuleiro/components/jogador/HudDoJogador.dart';
import 'package:jogo_tabuleiro/components/jogador/Jogador.dart';
import 'package:jogo_tabuleiro/domain/Atlas.dart';
import 'components/GameStateManager.dart';
import 'components/LocalDePergunta.dart';
import 'components/jogador/StatusDoJogador.dart';
import 'domain/MapTile.dart';
import 'domain/Mapa.dart';

class PadroesProjetoGame extends StatefulWidget {
  PadroesProjetoGame({super.key});

  @override
  State<PadroesProjetoGame> createState() => _PadroesProjetoGameState();
}

class _PadroesProjetoGameState extends State<PadroesProjetoGame> {
  final GameStateManager estadoManager = GameStateManager(GameState.intro);
  final StatusDoJogador status = StatusDoJogador();
  final GameController controller = GameController();
  int mapaAtual = 0;


  @override
  void initState() {
    controller.status = status;
    controller.status.estadoDoJogo = estadoManager;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<GameState>(
      valueListenable: estadoManager,
      builder: (context, estado, child) {
        return MapNavigator(
          initialMap: '/mapa-floresta',
          maps: {
            '/Mapa-Floresta': (context, args) => MapItem(
              id: 'map1',
              map: WorldMapByTiled(
                WorldMapReader.fromAsset(controller.atlas.mapas[0].caminhoDoArquivo),
              ),
              properties: {
                'mapa': controller.atlas.mapas[0],
                'caminhoPrincipal': controller.atlas.mapas[0].caminhoPrincipal,
              },
            ),
            '/Mapa-Agua': (context, args) => MapItem(
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
                  moveOnlyMapArea: true,
                  initialMapZoomFit: InitialMapZoomFitEnum.fitWidth,
                  initPosition: Mapa.centroDoMapa
              ),
              player: Jogador(
                position: map.properties['caminhoPrincipal'][0].position,
                mapa: map.properties['mapa'],
                statusDoJogador: status,
                estado: estadoManager,
              ),
              components: [
                Pesadelo(
                  statusDoJogador: status,
                  estadoDoJogo: estadoManager,
                ),
              ],
              playerControllers: [
                Joystick(
                  directional: JoystickDirectional(
                    spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
                    spriteKnobDirectional: Sprite.load('joystick_knob.png'),
                    size: 100,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).padding.left + 20,
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                    ),
                  ),
                ),
              ],
              onReady: (BonfireGameInterface gameRef) async {
                setState(() {
                  gameRef.map.removeWhere((c) => c is LocalDePergunta);
                  controller.atlas.atual = controller.getMapaPorIndice(mapaAtual);
                  controller.gerarPerguntas(gameRef);
                });
                mapaAtual++;
              },
              hudComponents: [HudDoJogador(status)],
              lightingColorGame: Colors.transparent,
            );
          },
        );
      },
    );
  }
}
