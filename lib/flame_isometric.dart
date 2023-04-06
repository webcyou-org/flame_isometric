library flame_isometric;

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:tiled/tiled.dart';

import 'custom_tsx_provider.dart';

class FlameIsometric {
  late String tmxSrc;
  late String tileMapSrc;
  List<String> tileMapSrcList = [];
  List<String> tsxSrcList = [];

  late List<List<List<int>>> matrixList = [];
  late SpriteSheet tileset;
  List<SpriteSheet> tilesetList = [];

  late Vector2 srcTileSize;
  late int tileWidth;
  late int tileHeight;
  late int layerLength = 0;

  FlameIsometric._();

  static Future<FlameIsometric> create(
      {required String tmx,
      required dynamic tileMap,
      List<String>? tsxList}) async {
    var flameIsometric = FlameIsometric._();
    flameIsometric.tmxSrc = tmx;

    if (tileMap.runtimeType == String) {
      flameIsometric.tileMapSrc = tileMap;
      flameIsometric.tileMapSrcList.add(tileMap);
    } else if (tileMap.runtimeType == List<String>) {
      flameIsometric.tileMapSrc = tileMap[0];
      flameIsometric.tileMapSrcList = tileMap;
    }

    if (tsxList != null) {
      flameIsometric.tsxSrcList = tsxList;
    }
    return flameIsometric._init();
  }

  Future<FlameIsometric> _init() async {
    final tmxXML = await Flame.assets.readFile(tmxSrc);
    final TiledMap tiledMap = await createTiledMap(tmxXML);
    final layers = tiledMap.layers.whereType<TileLayer>();
    layerLength = layers.length;
    matrixList = getMatrixList(layers);
    tileWidth = tiledMap.tileWidth;
    tileHeight = tiledMap.tileHeight;
    srcTileSize = Vector2(tileWidth.toDouble(), tileWidth.toDouble());

    final tilesetImageList = await createTilesetImageList();
    final spriteSheetList = createSpriteSheetList(tiledMap, tilesetImageList);

    tileset = spriteSheetList[0];
    tilesetList = spriteSheetList;
    return this;
  }

  Future<List<dynamic>> createTilesetImageList() async {
    final tilesetImageList = [];
    for (var i = 0; i < tileMapSrcList.length; i++) {
      tilesetImageList.add(await Flame.images.load(tileMapSrc));
    }
    return tilesetImageList;
  }

  List<SpriteSheet> createSpriteSheetList(
      TiledMap tiledMap, List<dynamic> tilesetImageList) {
    final List<SpriteSheet> tilesetList = [];

    for (var i = 0; i < tilesetImageList.length; i++) {
      final tileWidth = tiledMap.tilesets[i].tileWidth != null
          ? tiledMap.tilesets[i].tileWidth?.toDouble()
          : srcTileSize.x;
      final tileHeight = tiledMap.tilesets[i].tileHeight != null
          ? tiledMap.tilesets[i].tileHeight?.toDouble()
          : srcTileSize.x;

      tilesetList.add(SpriteSheet(
        image: tilesetImageList[i],
        srcSize: Vector2(tileWidth!, tileHeight!),
      ));
    }
    return tilesetList;
  }

  Future<TiledMap> createTiledMap(String tmxXML) async {
    final TiledMap tiledMap;
    final tsxXMLList = [];

    for (var i = 0; i < tsxSrcList.length; i++) {
      tsxXMLList.add(await Flame.assets.readFile(tsxSrcList[i]));
    }

    if (tsxSrcList.length > 1) {
      final customTsxProviderList = List<CustomTsxProvider>.generate(
          tsxXMLList.length,
          (index) => CustomTsxProvider(tsxSrcList[index], tsxXMLList[index]));
      tiledMap = TileMapParser.parseTmx(tmxXML, tsxList: customTsxProviderList);
    } else {
      tiledMap = TileMapParser.parseTmx(tmxXML);
    }
    return tiledMap;
  }

  List<List<int>> getSpriteSheetMatrix(layer) {
    return List<List<int>>.generate(
      layer.height,
      (row) => List.generate(
          layer.width,
          (col) => layer.data != null
              ? layer.data[row * layer.width + col] - 1
              : -1),
    );
  }

  List<List<List<int>>> getMatrixList(layers) {
    late List<List<List<int>>> matrixList = [];
    layers.forEach((layer) => {matrixList.add(getSpriteSheetMatrix(layer))});
    return matrixList;
  }
}
