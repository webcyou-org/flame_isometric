import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_isometric/flame_isometric.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IsometricMap Sample',
      home: MainGamePage(),
    );
  }
}

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  MainGame game = MainGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GameWidget(game: game),
      ],
    ));
  }
}

class MainGame extends FlameGame with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final gameSize = gameRef.size;
    // single
    // final flameIsometric = await FlameIsometric.create(
    //     tileMap: 'tile_map.png', tmx: 'tiles/tile_map.tmx');
    //
    // for (var i = 0; i < flameIsometric.layerLength; i++) {
    //   add(
    //     IsometricTileMapComponent(
    //       flameIsometric.tileset,
    //       flameIsometric.renderMatrixList[i],
    //       destTileSize: flameIsometric.srcTileSize,
    //       position:
    //           Vector2(gameSize.x / 2, flameIsometric.tileHeight.toDouble()),
    //     ),
    //   );
    // }

    final flameIsometric = await FlameIsometric.create(
        tileMap: ['tile_map.png', 'tile_map2.png'],
        tsxList: ['tiles/tile_map.tsx', 'tiles/tile_map2.tsx'],
        tmx: 'tiles/tile_map2.tmx'
    );

    for (var renderLayer in flameIsometric.renderLayerList) {
      add(
        IsometricTileMapComponent(
          renderLayer.spriteSheet,
          renderLayer.matrix,
          destTileSize: flameIsometric.srcTileSize,
          position:
          Vector2(gameSize.x / 2, flameIsometric.tileHeight.toDouble()),
        ),
      );
    }
  }
}
