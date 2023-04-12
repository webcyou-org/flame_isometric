library flame_isometric;

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:tiled/tiled.dart';

import 'custom_tsx_provider.dart';
import 'src/render_layer.dart';

class FlameIsometric {
  late String tmxSrc;
  late String tileMapSrc;
  late TiledMap tiledMap;
  List<String> tileMapSrcList = [];
  List<String> tsxSrcList = [];
  List<SpriteSheet> spriteSheetList = [];

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
    tiledMap = await createTiledMap(tmxXML);
    spriteSheetList =
        createSpriteSheetList(tiledMap, await createTilesetImageList());
    return this;
  }

  Iterable<TileLayer> get layerList => tiledMap.layers.whereType<TileLayer>();

  List<List<List<int>>> get matrixList => _getMatrixList();

  List<List<List<int>>> get renderMatrixList => _getRenderMatrixList();

  int get layerLength => tiledMap.layers.length;

  int get tileWidth => tiledMap.tileWidth;

  int get tileHeight => tiledMap.tileHeight;

  Vector2 get srcTileSize =>
      Vector2(tileWidth.toDouble(), tileWidth.toDouble());

  SpriteSheet get tileset => spriteSheetList[0];

  List<SpriteSheet> get tilesetList => spriteSheetList;

  Iterable<int>? get firstGridIdList =>
      tiledMap.tilesets.map((tileset) => tileset.firstGid ?? 0);

  List<RenderLayer> get renderLayerList {
    List<RenderLayer> renderLayerList = [];

    for (var matrix in matrixList) {
      final fixedRenderTilesetIndexMatrixList =
          getFixedRenderTilesetIndexMatrixList(matrix);

      for (var i = 0; i < fixedRenderTilesetIndexMatrixList.length; i++) {
        renderLayerList.add(
            RenderLayer(fixedRenderTilesetIndexMatrixList[i], tilesetList[i]));
      }
    }
    return renderLayerList;
  }

  Future<List<dynamic>> createTilesetImageList() async {
    final tilesetImageList = [];
    for (var i = 0; i < tileMapSrcList.length; i++) {
      tilesetImageList.add(await Flame.images.load(tileMapSrcList[i]));
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

  List<int> getMatrixFlatten(index) {
    return matrixList[index].expand((v) => v).toList();
  }

  List<int> getRenderMatrixFlatten(index) {
    return renderMatrixList[index].expand((v) => v).toList();
  }

  List<List<int>> getMatrix(layer) {
    return List<List<int>>.generate(
      layer.height,
      (row) => List.generate(
          layer.width,
          (col) =>
              layer.data != null ? layer.data[row * layer.width + col] : 0),
    );
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

  List<List<List<int>>> _getMatrixList() {
    late List<List<List<int>>> matrixList = [];
    for (var layer in layerList) {
      matrixList.add(getMatrix(layer));
    }
    return matrixList;
  }

  List<List<List<int>>> _getRenderMatrixList() {
    late List<List<List<int>>> matrixList = [];
    for (var layer in layerList) {
      matrixList.add(getSpriteSheetMatrix(layer));
    }
    return matrixList;
  }

  List<List<List<int>>> getFixedRenderTilesetIndexMatrixList(
      List<List<int>> matrix) {
    List<int> tilesetIndexUniqueList = getTilesetIndexUniqueList(matrix)
      ..remove(-1);
    List<int>? gridIdList = firstGridIdList?.toList();
    final List<List<List<int>>> resultList = [];
    for (int i = 0; i < tilesetIndexUniqueList.length; i++) {
      resultList.add(matrix
          .map((xList) => xList
              .map((n) => i == getGridIdRangeIndex(n) ? n - gridIdList![i] : -1)
              .toList())
          .toList());
    }
    return resultList;
  }

  List<int> getTilesetIndexUniqueList(List<List<int>> matrix) {
    List<List<int>> tilesetIndexMapping = getTilesetIndexMapping(matrix);
    List<int> tilesetIndexUniqueList =
        tilesetIndexMapping.expand((v) => v).toList();
    return tilesetIndexUniqueList.toSet().toList();
  }

  List<List<int>> getTilesetIndexMapping(List<List<int>> matrix) {
    return matrix
        .map((xList) => xList.map((n) => getGridIdRangeIndex(n)).toList())
        .toList();
  }

  getGidFlattenIndex(int x, int y, layer) => y * layer.width + x;

  getGridIdList(int x, int y) =>
      tiledMap.layers.map((layer) => getGridId(x, y, layer.id!)).toList();

  // getGridId(int x, int y, int layerId) => getLayer(layerId).first.data[getGidFlattenIndex(x, y, layer)];
  getGridId(int x, int y, int layerId) =>
      getLayer(layerId).first.tileData[y][x].tile;

  int getGridIdRangeIndex(int num) {
    List<int>? gridIdList = firstGridIdList?.toList();
    int index = -1;

    for (int i = 0; i < gridIdList!.length; i++) {
      if (num < gridIdList[i]) {
        index = i;
        break;
      }
    }
    if (index == -1) {
      index = gridIdList.length;
    }
    return index - 1;
  }

  getLayer(int layerId) => layerList.where((layer) => layer.id == layerId);

  int? getTilesetIndexByGid(int gid) =>
      firstGridIdList?.toList().lastIndexWhere((id) => id <= gid);

  Tileset getTilesetByGid(int gid) {
    int index = getTilesetIndexByGid(gid) ?? 0;
    index = index < 0 ? 0 : index;
    return tiledMap.tilesets[index];
  }

  getTileCustomPropertiesByPosition(int x, int y) {
    final gridIdList = getGridIdList(x, y);
    final tileSetList = gridIdList.map((gid) => getTilesetByGid(gid));
    final matchPropertyList = [];

    tileSetList.forEach((tileSet) => {
          tileSet.tiles.forEach((tile) => {
                if (tile.properties.length > 0)
                  {matchPropertyList.add(tile.properties)}
              })
        });
    return matchPropertyList;
  }

  getTileCustomPropertiesByPositionAndLayer(int x, int y, int layerId) {
    final gridId = getGridId(x, y, layerId);
    final tileSet = getTilesetByGid(gridId);
    final matchPropertyList = [];

    for (var tile in tileSet.tiles) {
      if (tile.properties.isNotEmpty) {
        matchPropertyList.add(tile.properties);
      }
    }
    return matchPropertyList;
  }
}
