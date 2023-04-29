import 'dart:ui';
import 'package:flame/components.dart';

class CustomIsometricTileMapComponent extends IsometricTileMapComponent {
  CustomIsometricTileMapComponent(
    super.tileset,
    super.matrix, {
    super.destTileSize,
    super.tileHeight,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) : _renderSprite = Sprite(tileset.image);

  Sprite _renderSprite;

  @override
  void render(Canvas c) {
    _renderSprite.image = tileset.image;
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix[i].length; j++) {
        final element = matrix[i][j];
        if (element != -1) {
          _renderSprite = tileset.getSpriteById(element);
          final p = getBlockRenderPositionInts(j, i);
          _renderSprite.render(
            c,
            position: p,
            size: tileset.srcSize,
          );
        }
      }
    }
  }
}
