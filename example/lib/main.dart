import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flame_isometric/flame_isometric.dart';

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
    final flameIsometric = await FlameIsometric.create(
        tileMap: 'tile_map.png', tmx: 'tiles/tile_map.tmx');

    for (var i = 0; i < flameIsometric.layerLength; i++) {
      add(
        IsometricTileMapComponent(
          flameIsometric.tileset,
          flameIsometric.matrixList[i],
          destTileSize: flameIsometric.srcTileSize,
          position:
          Vector2(gameSize.x / 2, flameIsometric.tileHeight.toDouble()),
        ),
      );
    }
  }
}
