import 'dart:math';

import 'cube/cube.dart';

class CubeCommand {
  CubeColor face = CubeColor.none;
  bool rotate = false;
  bool slice = false;
  bool wide = false;
  bool reversed = false;
  bool doubled = false;
  bool reset = false;

  CubeCommand();
  CubeCommand.copy(CubeCommand other) {
    face = other.face;
    rotate = other.rotate;
    slice = other.slice;
    wide = other.wide;
    reversed = other.reversed;
    doubled = other.doubled;
    reset = other.doubled;
  }
  CubeCommand.reset() {
    reset = true;
  }

  CubeCommand.parse(String move) {
    var m = move != null && move.length > 0 ? move[0] : "";
    if (m == "#") {
      reset = true;
      return;
    }

    switch (m) {
      case "F":
        face = CubeColor.F;
        break;
      case "B":
        face = CubeColor.B;
        break;
      case "L":
        face = CubeColor.L;
        break;
      case "R":
        face = CubeColor.R;
        break;
      case "U":
        face = CubeColor.U;
        break;
      case "D":
        face = CubeColor.D;
        break;
      case "f":
        face = CubeColor.F;
        wide = true;
        break;
      case "b":
        face = CubeColor.B;
        wide = true;
        break;
      case "l":
        face = CubeColor.L;
        wide = true;
        break;
      case "r":
        face = CubeColor.R;
        wide = true;
        break;
      case "u":
        face = CubeColor.U;
        wide = true;
        break;
      case "d":
        face = CubeColor.D;
        wide = true;
        break;
      case "X":
      case "x":
        face = CubeColor.R;
        rotate = true;
        break;
      case "Y":
      case "y":
        face = CubeColor.U;
        rotate = true;
        break;
      case "Z":
      case "z":
        face = CubeColor.F;
        rotate = true;
        break;
      case "M":
        face = CubeColor.L;
        slice = true;
        break;
      case "S":
        face = CubeColor.F;
        slice = true;
        break;
      case "E":
        face = CubeColor.D;
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

  static List<CubeCommand> random(int count) {
    var result = List<CubeCommand>();
    var rnd = Random();

    for (int i = 0; i < count; i++) {
      var next = CubeCommand()
        ..face = CubeColor.values[rnd.nextInt(6)]
        ..doubled = rnd.nextInt(8) == 0
        ..reversed = rnd.nextBool()
        ..wide = rnd.nextInt(8) == 0
        ..slice = rnd.nextInt(3) == 0
        ..rotate = rnd.nextInt(8) == 0;

      result.add(next);
    }
    return result;
  }

  static List<CubeCommand> parseAll(String pattern) {
    var result = List<CubeCommand>();
    var move = CubeCommand();
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
        result.add(CubeCommand()..reset = true);
        move = CubeCommand();
        continue;
      }

      if (move.face != CubeColor.none) {
        result.add(move);
      }

      move = CubeCommand.parse(c);
    }

    if (move.face != CubeColor.none) {
      result.add(move);
    }

    return result;
  }

  @override
  String toString() {
    if (reset) return "#";
    if (face == CubeColor.none) return "";

    var sb = StringBuffer();
    if (rotate) {
      if (face == CubeColor.F || face == CubeColor.B) {
        sb.write("z");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.B) sb.write("'");
      }

      if (face == CubeColor.L || face == CubeColor.R) {
        sb.write("x");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.L) sb.write("'");
      }

      if (face == CubeColor.U || face == CubeColor.D) {
        sb.write("y");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.D) sb.write("'");
      }
      return sb.toString();
    }

    if (slice) {
      if (face == CubeColor.F || face == CubeColor.B) {
        sb.write("S");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.B) sb.write("'");
      }

      if (face == CubeColor.L || face == CubeColor.R) {
        sb.write("M");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.R) sb.write("'");
      }

      if (face == CubeColor.U || face == CubeColor.D) {
        sb.write("E");
        if (doubled) sb.write("2");
        if (reversed || !reversed && face == CubeColor.U) sb.write("'");
      }
      return sb.toString();
    }

    String key;
    switch (face) {
      case CubeColor.F:
        key = "F";
        break;
      case CubeColor.B:
        key = "B";
        break;
      case CubeColor.L:
        key = "L";
        break;
      case CubeColor.R:
        key = "R";
        break;
      case CubeColor.U:
        key = "U";
        break;
      case CubeColor.D:
        key = "D";
        break;
      case CubeColor.none:
        key = ".";
        break;
    }

    if (wide) key = key.toLowerCase();
    sb.write(key);
    if (doubled) sb.write("2");
    if (reversed) sb.write("'");
    return sb.toString();
  }

  CubeCommand remap(CubeAxis axis) {
    var result = CubeCommand.copy(this);

    if (face == CubeColor.none) return result;

    var axisColor = [
      // UR
      [
        CubeColor.U,
        CubeColor.R,
        CubeColor.F,
        CubeColor.D,
        CubeColor.L,
        CubeColor.B
      ],
      // UF
      [
        CubeColor.U,
        CubeColor.F,
        CubeColor.L,
        CubeColor.D,
        CubeColor.B,
        CubeColor.R
      ],
      //UL
      [
        CubeColor.U,
        CubeColor.L,
        CubeColor.B,
        CubeColor.D,
        CubeColor.R,
        CubeColor.F
      ],
      // UB
      [
        CubeColor.U,
        CubeColor.B,
        CubeColor.R,
        CubeColor.D,
        CubeColor.F,
        CubeColor.L
      ],
      // RU
      [
        CubeColor.R,
        CubeColor.U,
        CubeColor.B,
        CubeColor.L,
        CubeColor.D,
        CubeColor.F
      ],
      // RF
      [
        CubeColor.R,
        CubeColor.F,
        CubeColor.U,
        CubeColor.L,
        CubeColor.B,
        CubeColor.D
      ],
      // RD
      [
        CubeColor.R,
        CubeColor.D,
        CubeColor.F,
        CubeColor.L,
        CubeColor.U,
        CubeColor.B
      ],
      // RB
      [
        CubeColor.R,
        CubeColor.B,
        CubeColor.D,
        CubeColor.L,
        CubeColor.F,
        CubeColor.U
      ],
      // FU
      [
        CubeColor.F,
        CubeColor.U,
        CubeColor.R,
        CubeColor.B,
        CubeColor.D,
        CubeColor.L
      ],
      // FR
      [
        CubeColor.F,
        CubeColor.R,
        CubeColor.D,
        CubeColor.B,
        CubeColor.L,
        CubeColor.U
      ],
      // FD
      [
        CubeColor.F,
        CubeColor.D,
        CubeColor.L,
        CubeColor.B,
        CubeColor.U,
        CubeColor.R
      ],
      // FL
      [
        CubeColor.F,
        CubeColor.L,
        CubeColor.U,
        CubeColor.B,
        CubeColor.R,
        CubeColor.D
      ],
      // DR
      [
        CubeColor.D,
        CubeColor.R,
        CubeColor.B,
        CubeColor.U,
        CubeColor.L,
        CubeColor.F
      ],
      // DF
      [
        CubeColor.D,
        CubeColor.F,
        CubeColor.R,
        CubeColor.U,
        CubeColor.B,
        CubeColor.L
      ],
      // DL
      [
        CubeColor.D,
        CubeColor.L,
        CubeColor.F,
        CubeColor.U,
        CubeColor.R,
        CubeColor.B
      ],
      // DB
      [
        CubeColor.D,
        CubeColor.B,
        CubeColor.L,
        CubeColor.U,
        CubeColor.F,
        CubeColor.R
      ],
      // LU
      [
        CubeColor.L,
        CubeColor.U,
        CubeColor.F,
        CubeColor.R,
        CubeColor.D,
        CubeColor.B
      ],
      // LF
      [
        CubeColor.L,
        CubeColor.F,
        CubeColor.D,
        CubeColor.R,
        CubeColor.B,
        CubeColor.U
      ],
      // LD
      [
        CubeColor.L,
        CubeColor.D,
        CubeColor.B,
        CubeColor.R,
        CubeColor.U,
        CubeColor.F
      ],
      // LB
      [
        CubeColor.L,
        CubeColor.B,
        CubeColor.U,
        CubeColor.R,
        CubeColor.F,
        CubeColor.D
      ],
      // BU
      [
        CubeColor.B,
        CubeColor.U,
        CubeColor.L,
        CubeColor.F,
        CubeColor.D,
        CubeColor.R
      ],
      // BR
      [
        CubeColor.B,
        CubeColor.R,
        CubeColor.U,
        CubeColor.F,
        CubeColor.L,
        CubeColor.D
      ],
      // BD
      [
        CubeColor.B,
        CubeColor.D,
        CubeColor.R,
        CubeColor.F,
        CubeColor.U,
        CubeColor.L
      ],
      // BL
      [
        CubeColor.B,
        CubeColor.L,
        CubeColor.D,
        CubeColor.F,
        CubeColor.R,
        CubeColor.U
      ],
    ];

    result.face = axisColor[axis.index][face.index];
    return result;
  }
}
