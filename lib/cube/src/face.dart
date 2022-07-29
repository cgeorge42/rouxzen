import 'enums.dart' show CubeColor, colorNames;
import 'defs.dart' show cornerFacelet, cornerColor, edgeFacelet, edgeColor;
import 'cubie.dart' show CubieCube;

/// Represent a cube on the facelet level with 54 colored facelets.
class FaceCube {
  static const solved =
      "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";

  final List<int> f = [];

  bool isValid = true;

  FaceCube() {
    for (var color in [
      CubeColor.U,
      CubeColor.R,
      CubeColor.F,
      CubeColor.D,
      CubeColor.L,
      CubeColor.B
    ]) {
      for (var i = 0; i < 9; i++) {
        f.add(color.index);
      }
    }
  }

  FaceCube.copy(FaceCube other) {
    f.addAll(other.f);
    isValid = other.isValid;
  }

  factory FaceCube.parse(String source) {
    var result = FaceCube();

    Map<String, int> counts = {
      "U": 0,
      "R": 0,
      "F": 0,
      "D": 0,
      "L": 0,
      "B": 0,
    };

    if (source.length != 54) result.isValid = false;

    for (int i = 0; i < 54; i++) {
      var c = i < source.length ? source[i] : "X";
      switch (c) {
        case "U":
          result.f[i] = CubeColor.U.index;
          counts["U"] += 1;
          break;
        case "R":
          result.f[i] = CubeColor.R.index;
          counts["R"] += 1;
          break;
        case "F":
          result.f[i] = CubeColor.F.index;
          counts["F"] += 1;
          break;
        case "D":
          result.f[i] = CubeColor.D.index;
          counts["D"] += 1;
          break;
        case "L":
          result.f[i] = CubeColor.L.index;
          counts["L"] += 1;
          break;
        case "B":
          result.f[i] = CubeColor.B.index;
          counts["B"] += 1;
          break;
        default:
          break;
      }
    }

    for (var c in ["U", "R", "F", "D", "L", "B"]) {
      if (counts[c] != 9) result.isValid = false;
    }

    return result;
  }

  String to2dString() {
    var s = toString();
    var sb = StringBuffer();
    sb.writeln("    ${s.substring(0, 3)}");
    sb.writeln("    ${s.substring(3, 6)}");
    sb.writeln("    ${s.substring(6, 9)}");
    sb.writeln(
        "${s.substring(36, 39)} ${s.substring(18, 21)} ${s.substring(9, 12)} ${s.substring(45, 48)}");
    sb.writeln(
        "${s.substring(39, 42)} ${s.substring(21, 24)} ${s.substring(12, 15)} ${s.substring(48, 51)}");
    sb.writeln(
        "${s.substring(42, 45)} ${s.substring(24, 27)} ${s.substring(15, 18)} ${s.substring(51, 54)}");
    sb.writeln("    ${s.substring(27, 30)}");
    sb.writeln("    ${s.substring(30, 33)}");
    sb.writeln("    ${s.substring(33, 36)}");

    return sb.toString();
  }

  @override
  String toString() {
    var sb = StringBuffer();
    for (var c in f) {
      sb.write(colorNames[c]);
    }
    return sb.toString();
  }

  /// Return a cubie representation of the facelet cube.
  CubieCube toCubieCube() {
    var cc = CubieCube();

    // invalidate corner and edge permutations
    cc.cp = [-1, -1, -1, -1, -1, -1, -1, -1];
    cc.ep = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];

    for (int i = 0; i < 8; i++) {
      var fac = cornerFacelet[i];

      // find the Up or Down face of the corner
      var k = 0;
      for (k in [0, 1, 2]) {
        var c = f[fac[k].index];
        if (c == CubeColor.U.index || c == CubeColor.D.index) break;
      }

      var c1 = f[fac[(k + 1) % 3].index];
      var c2 = f[fac[(k + 2) % 3].index];

      // find the corner that matches
      for (int j = 0; j < 8; j++) {
        var col = cornerColor[j];
        if (c1 == col[1].index && c2 == col[2].index) {
          cc.cp[i] = j;
          cc.co[i] = k;
          break;
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 12; j++) {
        var c0 = f[edgeFacelet[i][0].index];
        var c1 = edgeColor[j][0].index;
        var c2 = f[edgeFacelet[i][1].index];
        var c3 = edgeColor[j][1].index;

        if (c0 == c1 && c2 == c3) {
          cc.ep[i] = j;
          cc.eo[i] = 0;
          break;
        }

        if (c0 == c3 && c2 == c1) {
          cc.ep[i] = j;
          cc.eo[i] = 1;
        }
      }
    }

    return cc;
  }
}
