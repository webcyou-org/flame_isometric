import 'package:flame_isometric/flame_isometric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final flameIsometric = await FlameIsometric.create(
      tileMap: 'tile_map.png', tmx: 'tiles/tile_map.tmx');

  test('layer Length check', () async {
    expect(flameIsometric.layerLength, 3);
  });

  group('public API', () {
    test('Convert Matrix to 1D array', () async {
      expect(flameIsometric.getMatrixFlatten(0), [
        // ignore: format
        0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 0, 2, 2, 2, 28, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 2, 2, 48, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 50, 50, 50, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 50, 50, 2, 2,
        -1, -1, 2, 2, 2, 2, 2, 2, 2, 50, 50, 50, 50, 50, 2, 2,
        -1, -1, -1, -1, 2, 2, 2, 2, 2, 50, 2, 2, 50, 50, 2, 2,
        -1, -1, -1, -1, -1, -1, -1, 2, 2, 50, 2, 2, 50, 50, 2, 2,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2, 2, 50, 50, 2, 2
      ]);
    });
  });
}
