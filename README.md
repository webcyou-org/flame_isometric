# Flame Isometric
## Generate matrix for IsometricTileMapComponent

[![Pub](https://img.shields.io/pub/v/flame_isometric.svg)](https://pub.dartlang.org/packages/flame_isometric)

The matrix required to render an isometric tile map using the IsometricTileMapComponent in [Flame](https://github.com/flame-engine), Flutter's frame game engine. This plugin generates the

<img width="600" src="https://user-images.githubusercontent.com/1584153/229280525-558709e9-7594-4296-9a90-e23423f1ffe9.png">

## Usage

### import IsometricTileMapComponent Class

The Flame 1.6.0 version of [IsometricTileMapComponent](https://docs.flame-engine.org/1.6.0/flame/components.html#isometrictilemapcomponent) does not provide an interface to easily import tile maps generated by the Tiled Map Editor, but rather generates them using tilesetImage and matrix. The interface is generated by tilesetImage and matrix.

So, using 'package:tiled/tiled.dart' and 'package:flame/sprite.dart', we analyze the tmx data with TileMapParser and create a matrix, The matrix is then adjusted to match the SpriteSheet index, and the tileset is generated by the SpriteSheet component.
By passing the matrix and tileset to IsometricTileMapComponent, an IsometricMap is rendered.


They are handled by the [FlameIsometric class](https://github.com/flame-games/isometric_map/blob/main/lib/utility/flame_isometric.dart), which can be generated by passing the tileMap image path and the tmx file path.

```dart
final flameIsometric = await FlameIsometric.create(tileMap: 'tile_map.png', tmx: 'tiles/tile_map.tmx');
```

The matrix is generated layer by layer, and the matrices for all layers are stored in the matrixList of the flameIsometric instance.

Rendering is performed in layer order using for statements, etc.

```dart
for (var i = 0; i < flameIsometric.layerLength; i++) {
  add(
    IsometricTileMapComponent(
      flameIsometric.tileset,
      flameIsometric.matrixList[i],
      destTileSize: flameIsometric.srcTileSize,
      position: Vector2(gameSize.x / 2, flameIsometric.tileHeight.toDouble()),
    ),
  );
}
```

### tileset Multiple support

Multiple tilesets are also supported.

Specify a tileMap with a List as the argument, and tsxList also specifies a List as the argument.

Please note that tsxList is required in this case.

```dart
final flameIsometric = await FlameIsometric.create(tileMap: ['tile_map.png', 'tile_map2.png'], tsxList: ['tile_map.tsx', 'tile_map2.tsx'], tmx: 'tiles/tile_map.tmx');
```

These sample sources can be found [here](https://github.com/webcyou-org/flame_isometric/tree/main/example).

## Create Reference

Use the [Tiled Map Editor](https://www.mapeditor.org/) to create an Isometric tile map.

<img width="600" src="https://user-images.githubusercontent.com/1584153/229280771-215499c8-001e-40fa-a8fa-99a84ce8f51f.png">

In this case, Flame 1.6.0 does not seem to support rectangular maps, so "Isometric" (not Isometric (Staggered)) must be selected for Orientation.

<img width="450" src="https://user-images.githubusercontent.com/1584153/229281063-ff376a45-fd02-4a33-b0ab-76ee72d4a88b.png">

Select a map of the following shape.

<img width="600" src="https://user-images.githubusercontent.com/1584153/229281810-69a23536-7e7e-4d01-9ecc-099ffd60b0f0.png">

As for tile sets, they are mapped in squares.

<img width="400" src="https://user-images.githubusercontent.com/1584153/229282300-1198fdff-c34c-4357-b8e5-a28b1ad868eb.png">

This time, we are using materials created by 
[Seth Galbraith](https://opengameart.org/content/isometric-64x64-medieval-building-tileset) from [OpenGameArt.org](https://opengameart.org/), a website that provides free materials.


### Layers

As for layers, they are placed in three separate layers: "bottom," "middle," and "top.

<img width="400" src="https://user-images.githubusercontent.com/1584153/229285689-81633dbb-7eaf-4865-9134-3a9d6393f51b.png">

Mainly, the floor is placed in the "bottom" layer. The "middle" layer is for walls, etc. The "top" layer is mainly used for roofs, and the map is created as shown below.

<img width="500" src="https://user-images.githubusercontent.com/1584153/229283137-ba3d35b1-7708-43bd-b681-41d475abc4b2.png">


## Contributor

### copyright holder

isometric-64x64-medieval-building-tileset

[Seth Galbraith](https://opengameart.org/content/isometric-64x64-medieval-building-tileset)

I appreciate it very much.


## Author

**Daisuke Takayama**

-   [@webcyou](https://twitter.com/webcyou)
-   [@panicdragon](https://twitter.com/panicdragon)
-   <https://github.com/webcyou>
-   <https://github.com/webcyou-org>
-   <https://github.com/panicdragon>
-   <https://www.webcyou.com/>
