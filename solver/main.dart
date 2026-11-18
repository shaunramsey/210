class Tile {
  final int id;
  final List<String> data;
  Tile(this.id, this.data);
}

/*
    a.     s
  i   x.y     j
    r.     b
    s.     a
  a.  x.y     x
    b      b

*/

List<Tile> tiles = [
  Tile(1, ["a", "x", "r", "i"]),
  Tile(2, ["b", "y", "s", "j"]),
  Tile(3, ["a", "s", "x", "b"]),
  Tile(4, ["b", "y", "a", "x"]),
];

Tile rotateTile(Tile tile, int rotation) {
  List<String> newData = List.from(tile.data);
  for (int i = 0; i < rotation; i++) {
    newData = [newData[3], newData[0], newData[1], newData[2]];
  }
  return Tile(tile.id, newData);
}

bool isMatch(String side1, String side2) {
  return (side1 == "a" && side2 == "b") ||
      (side1 == "b" && side2 == "a") ||
      (side1 == "x" && side2 == "y") ||
      (side1 == "y" && side2 == "x") ||
      (side1 == "r" && side2 == "s") ||
      (side1 == "s" && side2 == "r") ||
      (side1 == "i" && side2 == "j") ||
      (side1 == "j" && side2 == "i");
}

bool checkPlacement(List<Tile> placedTiles, int index) {
  if (index == 0) return true; // First tile can be placed anywhere

  Tile topLeftTile = placedTiles[0];
  Tile topRightTile = placedTiles[1];
  Tile bottomRightTile = placedTiles[2];
  Tile bottomLeftTile = placedTiles[3];

  // Check if the right side of the left tile matches the left side of the current tile
  if (!isMatch(topLeftTile.data[1], topRightTile.data[3])) {
    return false;
  }
  if (index > 1) {
    if (!isMatch(topRightTile.data[2], bottomRightTile.data[0])) {
      return false;
    }
  }
  if (index > 2) {
    if (!isMatch(bottomRightTile.data[3], bottomLeftTile.data[1]) ||
        !isMatch(bottomLeftTile.data[0], topLeftTile.data[2])) {
      return false;
    }
  }

  return true;
}

void nextTile(List<Tile> placedTiles, int index) {
  if (index >= placedTiles.length) {
    print("********* All tiles placed successfully! ********");
    print("All tiles placed: ${placedTiles.map((t) => t.data).toList()}");
    return;
  }

  for (int i = 0; i < tiles.length; i++) {
    for (int k = index; k < 4; k++) {
      placedTiles[k] = Tile(-1, ["1", "1", "1", "1"]);
    }
    if (placedTiles.any((t) => t.id == tiles[i].id)) {
      // print(
      //   " [*] skippping tile $i - at index $index because it's already placed: ${placedTiles.map((t) => t.id).toList()}",
      // );

      continue; // Skip if the tile is already placed
    }
    for (int j = 0; j < 4; j++) {
      Tile rotatedTile = rotateTile(tiles[i], j);
      placedTiles[index] = rotatedTile;

      if (!checkPlacement(placedTiles, index)) {
        // print(
        //   "tile $i with rotation $j cannot be placed in slot $index: ${rotatedTile.data}",
        // );
        continue;
      }
      // print(
      //   "tile $i with rotation $j placed in slot $index: ${rotatedTile.data}",
      // );
      nextTile(placedTiles, index + 1);
    }
  }
}

void main() {
  List<Tile> placedTiles = [
    Tile(-1, ["1", "1", "1", "1"]),
    Tile(-1, ["1", "1", "1", "1"]),
    Tile(-1, ["1", "1", "1", "1"]),
    Tile(-1, ["1", "1", "1", "1"]),
  ];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      print(
        "Trying to place tile $i with rotation $j in slot 0: ${rotateTile(tiles[i], j).data}",
      );
      placedTiles[0] = rotateTile(tiles[i], j);
      for (int k = 1; k < 4; k++) {
        placedTiles[k] = Tile(-1, ["1", "1", "1", "1"]);
      }
      // print(
      //   "tile $i with rotation $j placed in slot 0: ${placedTiles[0].data}",
      // );
      nextTile(placedTiles, 1);
    }
  }
}
