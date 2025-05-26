import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/reader/tiled_asset_reader.dart';
import 'package:bonfire/widgets/bonfire_widget.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:jogo_tabuleiro/components/GameController.dart';
import 'package:jogo_tabuleiro/components/Player.dart';
import 'package:jogo_tabuleiro/domain/Atlas.dart';

class BoardGame extends StatelessWidget {
  static double tileSize = 32;


  const BoardGame({super.key});

  @override
  Widget build(BuildContext context) {

    GameController controller = GameController();

    //Inicia o Jogador no primeiro mapa e no primeiro ponto do mapa
    Jogador jogador = Jogador(position: controller.getPosicaoInicial(),
        size: Jogador.JogadorSize, caminho: controller.getProximoMapa().caminhoPrincipal);

    return BonfireWidget(
      map: WorldMapByTiled(
        //Dentro do seu arquivo de Mapa.json, altere o parâmetro tilesets > source para o nome
        //Do arquivo tileset gerado em json, por meio do Tiled.

        // https://opengameart.org/content/slates-32x32px-orthogonal-tileset-by-ivan-voirol
          WorldMapReader.fromAsset(
              controller.getProximoMapa().caminhoDoArquivo
          ),
      ),
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true, // Permitir apenas mostrar o mapa
        initialMapZoomFit: InitialMapZoomFitEnum.fitWidth, // Fit com base no wdth da tela
        initPosition: Vector2(15 * tileSize, 9 * tileSize), // Posição inicial da câmera, centralizado na camera
      ),

      components: [
        jogador,
        GameController(),
      ],
    );
  }
}
