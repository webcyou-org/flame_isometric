import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flame_isometric/flame_isometric.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  test('layer Length check', () async {
    final flameIsometric = await FlameIsometric.create(
        tileMap: 'tile_map.png',
        tmx: 'tiles/tile_map.tmx'
    );

    expect(flameIsometric.layerLength, 3);
  });
}