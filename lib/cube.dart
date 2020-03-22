import 'dart:math';

import 'package:mobx/mobx.dart';
part 'cube.g.dart';

// ignore_for_file: unused_element

class Cube = _Cube with _$Cube;

enum CubeColor { red, orange, blue, green, yellow, white }
enum CubeFace { front, back, left, right, up, down, none }

const List<CubeFace> AllSides = [
  CubeFace.up,
  CubeFace.left,
  CubeFace.front,
  CubeFace.right,
  CubeFace.back,
  CubeFace.down
];

class CubeMove {
  CubeFace face = CubeFace.none;
  bool rotate = false;
  bool slice = false;
  bool wide = false;
  bool reversed = false;
  bool doubled = false;
  bool reset = false;

  CubeMove();
  CubeMove.parse(String move) {
    var m = move != null && move.length > 0 ? move[0] : "";
    if (m == "#") {
      reset = true;
      return;
    }

    switch (m) {
      case "F":
        face = CubeFace.front;
        break;
      case "B":
        face = CubeFace.back;
        break;
      case "L":
        face = CubeFace.left;
        break;
      case "R":
        face = CubeFace.right;
        break;
      case "U":
        face = CubeFace.up;
        break;
      case "D":
        face = CubeFace.down;
        break;
      case "f":
        face = CubeFace.front;
        wide = true;
        break;
      case "b":
        face = CubeFace.back;
        wide = true;
        break;
      case "l":
        face = CubeFace.left;
        wide = true;
        break;
      case "r":
        face = CubeFace.right;
        wide = true;
        break;
      case "u":
        face = CubeFace.up;
        wide = true;
        break;
      case "d":
        face = CubeFace.down;
        wide = true;
        break;
      case "X":
      case "x":
        face = CubeFace.right;
        rotate = true;
        break;
      case "Y":
      case "y":
        face = CubeFace.up;
        rotate = true;
        break;
      case "Z":
      case "z":
        face = CubeFace.front;
        rotate = true;
        break;
      case "M":
        face = CubeFace.left;
        slice = true;
        break;
      case "S":
        face = CubeFace.front;
        slice = true;
        break;
      case "E":
        face = CubeFace.down;
        slice = true;
        break;
    }

    for (var i = 1; i < move.length; i++) {
      var c = move[i];
      if (c == '2') doubled = true;
      if (c == "'") reversed = true;
      if (c == "#") reset = true;
    }
  }

  static List<CubeMove> random(int count) {
    var result = List<CubeMove>();
    var rnd = Random();

    for (int i = 0; i < count; i++) {
      var next = CubeMove()
        ..face = CubeFace.values[rnd.nextInt(6)]
        ..doubled = rnd.nextInt(8) == 0
        ..reversed = rnd.nextBool()
        ..wide = rnd.nextInt(8) == 0
        ..slice = rnd.nextInt(3) == 0;
      result.add(next);
    }
    return result;
  }

  static List<CubeMove> parseAll(String pattern) {
    var result = List<CubeMove>();
    var move = CubeMove();
    const valid = {
      "#",
      "'",
      "2",
      "L",
      "R",
      "U",
      "D",
      "F",
      "B",
      "M",
      "S",
      "E",
      "x",
      "y",
      "z",
      "X",
      "Y",
      "Z",
      "l",
      "r",
      "u",
      "d",
      "f",
      "b"
    };

    for (var i = 0; i < pattern.length; i++) {
      var c = pattern[i];
      if (!valid.contains(c)) continue;

      if (c == "'") {
        move.reversed = true;
        continue;
      }

      if (c == "2") {
        move.doubled = true;
        continue;
      }

      if (c == "#") {
        result.add(CubeMove()..reset = true);
        move = CubeMove();
        continue;
      }

      if (move.face != CubeFace.none) {
        result.add(move);
      }

      move = CubeMove.parse(c);
    }

    if (move.face != CubeFace.none) {
      result.add(move);
    }

    return result;
  }

  @override
  String toString() {
    if (reset) return "#";
    if (face == CubeFace.none) return "";

    var sb = StringBuffer();
    if (rotate) {
      if (face == CubeFace.front || face == CubeFace.back) {
        sb.write("z");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.back) sb.write("'");
      }

      if (face == CubeFace.left || face == CubeFace.right) {
        sb.write("x");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.left) sb.write("'");
      }

      if (face == CubeFace.up || face == CubeFace.down) {
        sb.write("y");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.down) sb.write("'");
      }
      return sb.toString();
    }

    if (slice) {
      if (face == CubeFace.front || face == CubeFace.back) {
        sb.write("S");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.back) sb.write("'");
      }

      if (face == CubeFace.left || face == CubeFace.right) {
        sb.write("M");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.right) sb.write("'");
      }

      if (face == CubeFace.up || face == CubeFace.down) {
        sb.write("E");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeFace.up) sb.write("'");
      }
      return sb.toString();
    }

    var key = _Cube.printFace(face);
    if (wide) key = key.toLowerCase();
    sb.write(key);
    if (doubled) sb.write("2");
    if (reversed) sb.write("'");
    return sb.toString();
  }
}

const List<CubeColor> AllColors = [
  CubeColor.yellow,
  CubeColor.blue,
  CubeColor.red,
  CubeColor.green,
  CubeColor.orange,
  CubeColor.white
];

abstract class _Cube with Store {
  final ObservableList<CubeFace> stickers = ObservableList<CubeFace>.of([
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.up,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.left,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.front,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.right,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.back,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
    CubeFace.down,
  ]);

  final ObservableList<CubeMove> moves = ObservableList();

  @action
  CubeMove pop() {
    if (moves.isNotEmpty) {
      var last = moves.removeAt(0);
      return last;
    }
    return null;
  }

  @action
  push(CubeMove move) {
    moves.add(move);
  }

  @action
  pushAll(Iterable<CubeMove> sequence, {bool reversed = false}) {
    if (reversed) {
      moves.addAll(sequence.toList().reversed);
    } else {
      moves.addAll(sequence);
    }
  }

  @computed
  CubeMove get current => moves.isNotEmpty ? moves[0] : null;

  //   U      00 01 02
  // L F R B  03 04 05
  //   D      06 07 08
  // 09 10 11 18 19 20 27 28 29 36 37 38
  // 12 13 14 21 22 23 30 31 32 39 40 41
  // 15 16 17 24 25 26 33 34 35 42 43 44
  //          45 46 47
  //          48 49 50
  //          51 52 53

  @computed
  bool get isSolved {
    for (var side in AllSides) {
      if (!_isSolved(side)) return false;
    }
    return true;
  }

  @computed
  String get debugCube {
    var buffer = StringBuffer();
    buffer.write("     ");
    for (var idx in [0, 1, 2]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write("     ");
    for (var idx in [3, 4, 5]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write("     ");
    for (var idx in [6, 7, 8]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write(printFace(stickers[9]));
    for (var idx in [10, 11, 18, 19, 20, 27, 28, 29, 36, 37, 38])
      buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write(printFace(stickers[12]));
    for (var idx in [13, 14, 21, 22, 23, 30, 31, 32, 39, 40, 41])
      buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write(printFace(stickers[15]));
    for (var idx in [16, 17, 24, 25, 26, 33, 34, 35, 42, 43, 44])
      buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write("     ");
    for (var idx in [45, 46, 47]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write("     ");
    for (var idx in [48, 49, 50]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    buffer.write("     ");
    for (var idx in [51, 52, 53]) buffer.write(" ${printFace(stickers[idx])}");
    buffer.writeln();

    return buffer.toString();
  }

  static String printFace(CubeFace side) {
    switch (side) {
      case CubeFace.front:
        return "F";
        break;
      case CubeFace.back:
        return "B";
        break;
      case CubeFace.left:
        return "L";
        break;
      case CubeFace.right:
        return "R";
        break;
      case CubeFace.up:
        return "U";
        break;
      case CubeFace.down:
        return "D";
        break;
      case CubeFace.none:
        return ".";
        break;
    }
    return " ";
  }

  bool _isSolved(CubeFace side) {
    CubeFace first;
    for (var sticker in _stickersOf(side)) {
      if (sticker == CubeFace.none) continue;
      if (first == null) first = sticker;
      if (first != sticker) return false;
    }
    return true;
  }

  Iterable<CubeFace> _stickersOf(CubeFace side) sync* {
    for (var idx in _indexOf(side)) {
      yield stickers[idx];
    }
  }

  Iterable<int> _indexOf(CubeFace side) sync* {
    switch (side) {
      case CubeFace.front:
        yield* [18, 19, 20, 21, 22, 23, 24, 25, 26];
        break;
      case CubeFace.back:
        yield* [36, 37, 38, 39, 40, 41, 42, 43, 44];
        break;
      case CubeFace.left:
        yield* [9, 10, 11, 12, 13, 14, 15, 16, 17];
        break;
      case CubeFace.right:
        yield* [27, 28, 29, 30, 31, 32, 33, 34, 35];
        break;
      case CubeFace.up:
        yield* [0, 1, 2, 3, 4, 5, 6, 7, 8];
        break;
      case CubeFace.down:
        yield* [45, 46, 47, 48, 49, 50, 51, 52, 53];
        break;
      case CubeFace.none:
        for (var i = 0; i < stickers.length; i++) {
          if (stickers[i] == CubeFace.none) yield i;
        }
        break;
    }
  }

  @action
  void reset() {
    _reset();
  }

  @action
  void apply(String pattern, {bool reversed = false}) {
    var moves = CubeMove.parseAll(pattern);

    for (var move in reversed ? moves.reversed : moves) {
      _apply(move);
    }
  }

  @action
  void step(CubeMove next) {
    _apply(next);
  }

  void _reset() {
    for (var side in AllSides) {
      for (var idx in _indexOf(side)) {
        stickers[idx] = side;
      }
    }
  }

  void _applySlice(CubeMove move) {
    switch (move.face) {
      case CubeFace.front:
        _standing(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.back:
        _standing(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.left:
        _middle(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.right:
        _middle(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.up:
        _equitorial(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.down:
        _equitorial(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.none:
        break;
    }
  }

  void _applyRotate(CubeMove move) {
    switch (move.face) {
      case CubeFace.front:
        _rotateZ(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.back:
        _rotateZ(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.left:
        _rotateX(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.right:
        _rotateX(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.up:
        _rotateY(move.reversed, doubled: move.doubled);
        break;
      case CubeFace.down:
        _rotateY(!move.reversed, doubled: move.doubled);
        break;
      case CubeFace.none:
        break;
    }
  }

  void _apply(CubeMove move) {
    if (move.reset) {
      _reset();
      return;
    }

    if (move.slice) {
      _applySlice(move);
      return;
    }
    if (move.rotate) {
      _applyRotate(move);
      return;
    }

    switch (move.face) {
      case CubeFace.front:
        _front(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.back:
        _back(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.left:
        _left(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.right:
        _right(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.up:
        _up(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.down:
        _down(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeFace.none:
        break;
    }
  }

  void _rotateX(bool reversed, {bool doubled = false}) {
    _right(reversed, wide: true, doubled: doubled);
    _left(!reversed, doubled: doubled);
  }

  void _rotateY(bool reversed, {bool doubled = false}) {
    _up(reversed, wide: true, doubled: doubled);
    _down(!reversed, doubled: doubled);
  }

  void _rotateZ(bool reversed, {bool doubled = false}) {
    _front(reversed, wide: true, doubled: doubled);
    _back(!reversed, doubled: doubled);
  }

  void _front(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([18, 19, 20, 23, 26, 25, 24, 21], reversed, doubled);
    _cycle3([6, 7, 8, 27, 30, 33, 47, 46, 45, 17, 14, 11], reversed, doubled);
    if (wide) _standing(reversed, doubled: doubled);
  }

  void _back(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([36, 37, 38, 41, 44, 43, 42, 39], reversed, doubled);
    _cycle3([2, 1, 0, 9, 12, 15, 51, 52, 53, 35, 32, 29], reversed, doubled);
    if (wide) _standing(!reversed, doubled: doubled);
  }

  //   U      00 01 02
  // L F R B  03 04 05
  //   D      06 07 08
  // 09 10 11 18 19 20 27 28 29 36 37 38
  // 12 13 14 21 22 23 30 31 32 39 40 41
  // 15 16 17 24 25 26 33 34 35 42 43 44
  //          45 46 47
  //          48 49 50
  //          51 52 53

  void _right(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([27, 28, 29, 32, 35, 34, 33, 30], reversed, doubled);
    _cycle3([8, 5, 2, 36, 39, 42, 53, 50, 47, 26, 23, 20], reversed, doubled);
    if (wide) _middle(!reversed, doubled: doubled);
  }

  void _left(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([9, 10, 11, 14, 17, 16, 15, 12], reversed, doubled);
    _cycle3([0, 3, 6, 18, 21, 24, 45, 48, 51, 44, 41, 38], reversed, doubled);
    if (wide) _middle(reversed, doubled: doubled);
  }

  void _up(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([0, 1, 2, 5, 8, 7, 6, 3], reversed, doubled);
    _cycle3([38, 37, 36, 29, 28, 27, 20, 19, 18, 11, 10, 9], reversed, doubled);
    if (wide) _equitorial(!reversed, doubled: doubled);
  }

  void _down(bool reversed, {bool wide = false, bool doubled = false}) {
    _cycle2([45, 46, 47, 50, 53, 52, 51, 48], reversed, doubled);
    _cycle3(
        [24, 25, 26, 33, 34, 35, 42, 43, 44, 15, 16, 17], reversed, doubled);
    if (wide) _equitorial(reversed, doubled: doubled);
  }

  void _middle(bool reversed, {bool doubled = false}) {
    _cycle3([19, 22, 25, 46, 49, 52, 43, 40, 37, 1, 4, 7], reversed, doubled);
  }

  void _standing(bool reversed, {bool doubled = false}) {
    _cycle3([3, 4, 5, 28, 31, 34, 50, 49, 48, 16, 13, 10], reversed, doubled);
  }

  void _equitorial(bool reversed, {bool doubled = false}) {
    _cycle3(
        [21, 22, 23, 30, 31, 32, 39, 40, 41, 12, 13, 14], reversed, doubled);
  }

  void _cycle2(List<int> indexes, bool reversed, bool doubled) {
    var lsa = List<int>();
    var lsb = List<int>();
    for (var i = 0; i < indexes.length; i++) {
      if (i % 2 == 0) lsa.add(indexes[i]);
      if (i % 2 == 1) lsb.add(indexes[i]);
    }

    _cycle(lsa, reversed);
    if (doubled) _cycle(lsa, reversed);
    _cycle(lsb, reversed);
    if (doubled) _cycle(lsb, reversed);
  }

  void _cycle3(List<int> indexes, bool reversed, bool doubled) {
    var lsa = List<int>();
    var lsb = List<int>();
    var lsc = List<int>();
    for (var i = 0; i < indexes.length; i++) {
      if (i % 3 == 0) lsa.add(indexes[i]);
      if (i % 3 == 1) lsb.add(indexes[i]);
      if (i % 3 == 2) lsc.add(indexes[i]);
    }

    _cycle(lsa, reversed);
    if (doubled) _cycle(lsa, reversed);
    _cycle(lsb, reversed);
    if (doubled) _cycle(lsb, reversed);
    _cycle(lsc, reversed);
    if (doubled) _cycle(lsc, reversed);
  }

  void _cycle(List<int> indexes, bool reversed) {
    if (indexes.length < 2) return;

    var first = stickers[reversed ? indexes.first : indexes.last];

    if (reversed) {
      for (var i = 0; i < indexes.length - 1; i++) {
        stickers[indexes[i]] = stickers[indexes[i + 1]];
      }

      stickers[indexes.last] = first;
    } else {
      for (var i = indexes.length - 1; i > 0; i--) {
        stickers[indexes[i]] = stickers[indexes[i - 1]];
      }

      stickers[indexes.first] = first;
    }
  }
}
