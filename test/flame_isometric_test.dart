import 'package:flame/game.dart';
import 'package:flame_isometric/flame_isometric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('Case with only one tmx file.', () {
    late FlameIsometric flameIsometric;

    setUp(() async {
      flameIsometric = await FlameIsometric.create(
          tileMap: 'tile_map.png', tmx: 'tiles/tile_map.tmx');
    });

    group('flameIsometric public parameter', () {
      test('Matrix List check', () {
        expect(flameIsometric.matrixList[0], [
          [0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 0, 2, 2, 2, 28, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 2, 2, 48, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
          [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 50, 50, 50, 2, 2],
          [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 50, 50, 2, 2],
          [-1, -1, 2, 2, 2, 2, 2, 2, 2, 50, 50, 50, 50, 50, 2, 2],
          [-1, -1, -1, -1, 2, 2, 2, 2, 2, 50, 2, 2, 50, 50, 2, 2],
          [-1, -1, -1, -1, -1, -1, -1, 2, 2, 50, 2, 2, 50, 50, 2, 2],
          [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2, 2, 50, 50, 2, 2]
        ]);
      });
    });

    group('public Getter', () {
      test('layer Length check', () async {
        expect(flameIsometric.layerLength, 3);
      });
      test('tiledMap tileWidth', () async {
        expect(flameIsometric.tileWidth, 64);
      });
      test('tiledMap tileHeight', () async {
        expect(flameIsometric.tileHeight, 32);
      });
      test('tiledMap srcTileSize', () async {
        expect(flameIsometric.srcTileSize, Vector2(64.0, 64.0));
      });
    });

    group('public API', () {
      test('Convert Matrix to 1D array', () async {
        expect(flameIsometric.getMatrixFlatten(0), [
          0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, // ignore: line_length
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
  });

  group('Case including multiple tile chips and tsx files.', () {
    late FlameIsometric flameIsometric;

    setUp(() async {
      flameIsometric = await FlameIsometric.create(
        tmx: 'tiles/tile_map2.tmx',
        tileMap: ['tile_map.png', 'tile_map2.png'],
        tsxList: ['tiles/tile_map.tsx', 'tiles/tile_map2.tsx'],
      );
    });

    test('layer Length check', () async {
      expect(flameIsometric.layerLength, 3);
    });
    test('tilesetList Length check', () async {
      expect(flameIsometric.tilesetList.length, 2);
      expect(flameIsometric.tiledMap.tilesets.length, 2);
    });

    // <tileset version="1.10" tiledversion="1.10.0" name="tile_map" tilewidth="64" tileheight="64" tilecount="80" columns="10">
    // <tileset version="1.10" tiledversion="1.10.0" name="tile_map2" tilewidth="128" tileheight="128" tilecount="56" columns="8">
    test('tilesetList property check', () async {
      // tile_map.tsx
      expect(flameIsometric.tiledMap.tilesets[0].tiledVersion, '1.10.0');
      expect(flameIsometric.tiledMap.tilesets[0].name, 'tile_map');
      expect(flameIsometric.tiledMap.tilesets[0].tileWidth, 64);
      expect(flameIsometric.tiledMap.tilesets[0].tileHeight, 64);
      expect(flameIsometric.tiledMap.tilesets[0].tileCount, 80);
      expect(flameIsometric.tiledMap.tilesets[0].columns, 10);

      // tile_map2.tsx
      expect(flameIsometric.tiledMap.tilesets[1].tiledVersion, '1.10.0');
      expect(flameIsometric.tiledMap.tilesets[1].name, 'tile_map2');
      expect(flameIsometric.tiledMap.tilesets[1].tileWidth, 128);
      expect(flameIsometric.tiledMap.tilesets[1].tileHeight, 128);
      expect(flameIsometric.tiledMap.tilesets[1].tileCount, 56);
      expect(flameIsometric.tiledMap.tilesets[1].columns, 8);
    });

    group('public Getter', () {
      test('first GridId List', () {
        expect(flameIsometric.firstGridIdList?.toList(), [1, 81]);
      });
    });

    group('public API', () {
      test('Get a flat list of gids with x, y coordinates and layer as arguments.', () {
        expect(flameIsometric.getGidFlattenIndex(1, 1, flameIsometric.tiledMap.layers.first), 17);
      });

      test('Pass x, y coordinates and layerId to get gid', () {
        expect(flameIsometric.getGridId(0, 0, 1), 1);
        expect(flameIsometric.getGridId(3, 0, 1), 3);
        expect(flameIsometric.getGridId(6, 1, 1), 29);
      });

      test('Pass x, y coordinates and get a list of layerIds', () {
        expect(flameIsometric.getGridIdList(0, 0), [1, 0, 0]);
        expect(flameIsometric.getGridIdList(6, 1), [29, 0, 0]);
      });

      test('Obtains the index of the Tileset list with gid as an argument', () {
        expect(flameIsometric.getTilesetIndexByGid(0), -1);
        expect(flameIsometric.getTilesetIndexByGid(1), 0);
        expect(flameIsometric.getTilesetIndexByGid(80), 0);
        expect(flameIsometric.getTilesetIndexByGid(81), 1);
        expect(flameIsometric.getTilesetIndexByGid(130), 1);
      });

      test('Obtain the corresponding Tileset with gid as an argument', () {
        expect(flameIsometric.getTilesetByGid(-1).name, 'tile_map');
        expect(flameIsometric.getTilesetByGid(0).name, 'tile_map');
        expect(flameIsometric.getTilesetByGid(1).name, 'tile_map');
        expect(flameIsometric.getTilesetByGid(80).name, 'tile_map');
        expect(flameIsometric.getTilesetByGid(81).name, 'tile_map2');
        expect(flameIsometric.getTilesetByGid(130).name, 'tile_map2');
      });

      test('Obtain a list of gids with x, y coordinates as arguments', () {
        expect(flameIsometric.getGridIdList(2, 12), [3, 130, 0]);
      });

      test('getTileCustomPropertiesByPosition', () {
        final matchPropertyList = flameIsometric.getTileCustomPropertiesByPosition(2, 12);
        expect(matchPropertyList.first.getValue('blocked'), true);
      });
    });
  });
}
