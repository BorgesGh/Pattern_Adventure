import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/reader/tiled_asset_reader.dart';
import 'package:bonfire/widgets/bonfire_widget.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:jogo_tabuleiro/components/GameController.dart';
import 'package:jogo_tabuleiro/components/HudDoJogador.dart';
import 'package:jogo_tabuleiro/components/Player.dart';
import 'package:jogo_tabuleiro/domain/Atlas.dart';

import 'components/StatusDoJogador.dart';
import 'components/TrocaMapaSensor.dart';
import 'domain/MapTile.dart';
import 'domain/Mapa.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  final GameController controller = GameController();
  final StatusDoJogador status = StatusDoJogador();
  late Jogador jogador;
  int mapaAtual = 0;

  @override
  void initState() {
    super.initState();
    carregarMapa();
  }

  void carregarMapa() {
    var mapa = controller.getMapaPorIndice(mapaAtual);
    jogador = Jogador(
      position: controller.getPosicaoInicial(),
      size: Jogador.JogadorSize,
      mapa: mapa,
      indexDePerguntas: controller.atlas.indiceDePerguntas,
      statusDoJogador: status,
    );
  }

  void trocarMapa() {
    setState(() {
      mapaAtual++;
      carregarMapa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapa = controller.getMapaPorIndice(mapaAtual);

    return BonfireWidget(
      map: WorldMapByTiled(
        WorldMapReader.fromAsset(mapa.caminhoDoArquivo),
      ),
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true, // true
        initialMapZoomFit: InitialMapZoomFitEnum.fitWidth,
        initPosition: Mapa.centroDoMapa
      ),
      components: [
        jogador,
        controller,
        HudDoJogador(status),
        TrocaMapaSensor(
          onTrocaMapa: trocarMapa,
          position: mapa.caminhoPrincipal.last.position, // Ultimo lugar que o jogador deve chegar
          size: Vector2.all(MapTile.tileSize),
        ),
      ],
    );
  }
}

