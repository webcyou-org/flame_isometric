import 'package:flame/sprite.dart';

class RenderLayer {
  List<List<int>> matrix = [];
  late SpriteSheet spriteSheet;

  RenderLayer(this.matrix, this.spriteSheet);
}
