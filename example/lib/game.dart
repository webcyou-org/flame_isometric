import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flame_isometric/flame_isometric.dart';

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
