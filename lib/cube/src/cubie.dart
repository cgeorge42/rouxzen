import 'face.dart' show FaceCube;
import 'enums.dart' show Corner, Edge, cornerNames, edgeNames;
import 'defs.dart' show edgeFacelet, edgeColor, cornerFacelet, cornerColor;

// The basic six cube moves described by permutations and changes in orientation

// Up-move
const cpU = [
  Corner.UBR,
  Corner.URF,
  Corner.UFL,
  Corner.ULB,
  Corner.DFR,
  Corner.DLF,
  Corner.DBL,
  Corner.DRB
];
const coU = [0, 0, 0, 0, 0, 0, 0, 0];
const epU = [
  Edge.UB,
  Edge.UR,
  Edge.UF,
  Edge.UL,
  Edge.DR,
  Edge.DF,
  Edge.DL,
  Edge.DB,
  Edge.FR,
  Edge.FL,
  Edge.BL,
  Edge.BR
];
const eoU = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Right-move
const cpR = [
  Corner.DFR,
  Corner.UFL,
  Corner.ULB,
  Corner.URF,
  Corner.DRB,
  Corner.DLF,
  Corner.DBL,
  Corner.UBR
];
const coR = [2, 0, 0, 1, 1, 0, 0, 2];
const epR = [
  Edge.FR,
  Edge.UF,
  Edge.UL,
  Edge.UB,
  Edge.BR,
  Edge.DF,
  Edge.DL,
  Edge.DB,
  Edge.DR,
  Edge.FL,
  Edge.BL,
  Edge.UR
];
const eoR = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Front-move
const cpF = [
  Corner.UFL,
  Corner.DLF,
  Corner.ULB,
  Corner.UBR,
  Corner.URF,
  Corner.DFR,
  Corner.DBL,
  Corner.DRB
];
const coF = [1, 2, 0, 0, 2, 1, 0, 0];
const epF = [
  Edge.UR,
  Edge.FL,
  Edge.UL,
  Edge.UB,
  Edge.DR,
  Edge.FR,
  Edge.DL,
  Edge.DB,
  Edge.UF,
  Edge.DF,
  Edge.BL,
  Edge.BR
];
const eoF = [0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0];

// Down-move
const cpD = [
  Corner.URF,
  Corner.UFL,
  Corner.ULB,
  Corner.UBR,
  Corner.DLF,
  Corner.DBL,
  Corner.DRB,
  Corner.DFR
];
const coD = [0, 0, 0, 0, 0, 0, 0, 0];
const epD = [
  Edge.UR,
  Edge.UF,
  Edge.UL,
  Edge.UB,
  Edge.DF,
  Edge.DL,
  Edge.DB,
  Edge.DR,
  Edge.FR,
  Edge.FL,
  Edge.BL,
  Edge.BR
];
const eoD = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Left-move
const cpL = [
  Corner.URF,
  Corner.ULB,
  Corner.DBL,
  Corner.UBR,
  Corner.DFR,
  Corner.UFL,
  Corner.DLF,
  Corner.DRB
];
const coL = [0, 1, 2, 0, 0, 2, 1, 0];
const epL = [
  Edge.UR,
  Edge.UF,
  Edge.BL,
  Edge.UB,
  Edge.DR,
  Edge.DF,
  Edge.FL,
  Edge.DB,
  Edge.FR,
  Edge.UL,
  Edge.DL,
  Edge.BR
];
const eoL = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Back-move
const cpB = [
  Corner.URF,
  Corner.UFL,
  Corner.UBR,
  Corner.DRB,
  Corner.DFR,
  Corner.DLF,
  Corner.ULB,
  Corner.DBL
];
const coB = [0, 0, 1, 2, 0, 0, 2, 1];
const epB = [
  Edge.UR,
  Edge.UF,
  Edge.UL,
  Edge.BR,
  Edge.DR,
  Edge.DF,
  Edge.DL,
  Edge.BL,
  Edge.FR,
  Edge.FL,
  Edge.UB,
  Edge.DB
];
const eoB = [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1];

const CUBE_OK = true;

/// Represent a cube on the cubie level with 8 corner cubies, 12 edge cubies and the cubie orientations.
///
///    Is also used to represent:
///    1. the 18 cube moves
///    2. the 48 symmetries of the cube.

class CubieCube {
  /// Corner Permutation
  List<int> cp;

  /// Corner Orientation
  List<int> co;

  /// Edge Permutation
  List<int> ep;

  /// Edge Orientation
  List<int> eo;

  CubieCube() {
    cp = [0, 1, 2, 3, 4, 5, 6, 7];
    co = [0, 0, 0, 0, 0, 0, 0, 0];
    ep = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    eo = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }

  CubieCube.copy(CubieCube other) {
    cp = [...other.cp];
    co = [...other.co];
    ep = [...other.ep];
    eo = [...other.eo];
  }

  factory CubieCube.init(
      List<Corner> cp, List<int> co, List<Edge> ep, List<int> eo) {
    var result = CubieCube();

    if (cp != null) result.cp = [for (var c in cp) c.index];
    if (co != null) result.co = [...co];
    if (ep != null) result.ep = [for (var e in ep) e.index];
    if (eo != null) result.eo = [...eo];

    return result;
  }

  bool operator ==(other) {
    for (int i = 0; i < 8; i++) {
      if (cp[i] != other.cp[i]) return false;
      if (co[i] != other.co[i]) return false;
    }

    for (int i = 0; i < 12; i++) {
      if (ep[i] != other.ep[i]) return false;
      if (eo[i] != other.eo[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return "$cp$co$ep$eo".hashCode;
  }

  @override
  String toString() {
    var sb = StringBuffer();
    for (int i = 0; i < 8; i++) {
      var cos = cp[i] == -1 ? "?" : cornerNames[cp[i]];
      sb.write("($cos,${co[i]})");
    }

    sb.writeln();
    for (int i = 0; i < 12; i++) {
      var eos = ep[i] == -1 ? "?" : edgeNames[ep[i]];
      sb.write("($eos,${eo[i]})");
    }

    return sb.toString();
  }

  /// Return a facelet representation of the cube.
  FaceCube toFaceCube() {
    var fc = FaceCube();
    for (int i = 0; i < 8; i++) {
      var j = cp[i];
      var ori = co[i];
      for (int k = 0; k < 3; k++) {
        var idx = cornerFacelet[i][(k + ori) % 3].index;
        fc.f[idx] = cornerColor[j][k].index;
      }
    }

    for (int i = 0; i < 12; i++) {
      var j = ep[i];
      var ori = eo[i];
      for (int k = 0; k < 2; k++) {
        var idx = edgeFacelet[i][(k + ori) % 2].index;
        fc.f[idx] = edgeColor[j][k].index;
      }
    }

    return fc;
  }
}
