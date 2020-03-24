import 'face.dart';
import 'enums.dart';
import 'defs.dart';

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
    ep = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    eo = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }

  factory CubieCube.parse(String sequence) {
    return FaceCube.parse(sequence).toCubieCube();
  }

  CubieCube.copy(CubieCube other) {
    cp = [...other.cp];
    co = [...other.co];
    ep = [...other.ep];
    eo = [...other.eo];
  }

  factory CubieCube.init(
      List<CubeCorner> cp, List<int> co, List<CubeEdge> ep, List<int> eo) {
    var result = CubieCube();

    if (cp != null) result.cp = [for (var c in cp) c.index];
    if (co != null) result.co = [...co];
    if (ep != null) result.ep = [for (var e in ep) e.index];
    if (eo != null) result.eo = [...eo];

    return result;
  }

  void copyFrom(CubieCube other) {
    cp = [...other.cp];
    co = [...other.co];
    ep = [...other.ep];
    eo = [...other.eo];
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

  String get sequence => toFaceCube().toString();

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

  void apply(CubeColor face, int count) {
    if (count < 0) count += 4;
    if (count >= 4) count -= 4;
    if (count == 0) return;

    switch (face) {
      case CubeColor.U:
        if (count == 1) multiply(moveCube[CubeMove.U1.index]);
        if (count == 2) multiply(moveCube[CubeMove.U2.index]);
        if (count == 3) multiply(moveCube[CubeMove.U3.index]);
        break;
      case CubeColor.R:
        if (count == 1) multiply(moveCube[CubeMove.R1.index]);
        if (count == 2) multiply(moveCube[CubeMove.R2.index]);
        if (count == 3) multiply(moveCube[CubeMove.R3.index]);
        break;
      case CubeColor.F:
        if (count == 1) multiply(moveCube[CubeMove.F1.index]);
        if (count == 2) multiply(moveCube[CubeMove.F2.index]);
        if (count == 3) multiply(moveCube[CubeMove.F3.index]);
        break;
      case CubeColor.D:
        if (count == 1) multiply(moveCube[CubeMove.D1.index]);
        if (count == 2) multiply(moveCube[CubeMove.D2.index]);
        if (count == 3) multiply(moveCube[CubeMove.D3.index]);
        break;
      case CubeColor.L:
        if (count == 1) multiply(moveCube[CubeMove.L1.index]);
        if (count == 2) multiply(moveCube[CubeMove.L2.index]);
        if (count == 3) multiply(moveCube[CubeMove.L3.index]);
        break;
      case CubeColor.B:
        if (count == 1) multiply(moveCube[CubeMove.B1.index]);
        if (count == 2) multiply(moveCube[CubeMove.B2.index]);
        if (count == 3) multiply(moveCube[CubeMove.B3.index]);
        break;
      case CubeColor.none:
        break;
    }
  }

  /// Multiply this cube with another [CubieCube], restricted to the corners.
  void multiplyCorners(CubieCube other) {
    var next = CubieCube();

    for (int i = 0; i < 8; i++) {
      // next corner index
      var j = other.cp[i];

      // calculate next corner permutation
      next.cp[i] = cp[j];

      // calculate next corner orientation
      var orientA = co[j];
      var orientB = other.co[i];
      var orient = 0;

      // if both cubes are regular cubes
      if (orientA < 3 && orientB < 3) {
        orient = orientA + orientB;
        // the composition is a regular cube
        if (orient >= 3) orient -= 3;
      }
      // cube b is in a mirrored state
      else if (orientA < 3 && 3 <= orientB) {
        orient = orientA + orientB;
        // the composition also is in a mirrored state
        if (orient >= 6) orient -= 3;
      }
      // cube a is in a mirrored state
      else if (orientA >= 3 && 3 > orientB) {
        orient = orientA - orientB;
        // the composition is a mirrored cube
        if (orient < 3) orient += 3;
      }
      // if both cubes are in mirrored states
      else if (orientA >= 3 && orientB >= 3) {
        orient = orientA - orientB;
        // the composition is a regular cube
        if (orient < 0) orient += 3;
      }
      next.co[i] = orient;
    }

    cp = next.cp;
    co = next.co;
  }

  /// Multiply this cube with another [CubieCube], restricted to the edges.
  void multiplyEdges(CubieCube other) {
    var next = CubieCube();

    for (int i = 0; i < 12; i++) {
      // next edge index
      var j = other.ep[i];

      // calculate next edge permuation and orientation
      next.ep[i] = ep[j];
      next.eo[i] = (other.eo[i] + eo[j]) % 2;
    }

    ep = next.ep;
    eo = next.eo;
  }

  void multiply(CubieCube other) {
    multiplyCorners(other);
    multiplyEdges(other);
  }

  CubieCube get inverse {
    var next = CubieCube();

    for (int i = 0; i < 12; i++) {
      next.ep[ep[i]] = i;
    }

    for (int i = 0; i < 12; i++) {
      next.eo[i] = eo[next.ep[i]];
    }

    for (int i = 0; i < 8; i++) {
      next.cp[cp[i]] = i;
    }

    for (int i = 0; i < 8; i++) {
      var orient = co[next.cp[i]];

      if (orient >= 3) {
        next.co[i] = orient;
      } else {
        next.co[i] -= orient;
        if (next.co[i] < 0) {
          next.co[i] += 3;
        }
      }
    }

    return next;
  }

  /// Give the parity of the corner permutation.
  int get cornerParity {
    int s = 0;
    for (int i = CubeCorner.DRB.index; i > CubeCorner.URF.index; i--) {
      for (int j = i - 1; j > CubeCorner.URF.index - 1; j--) {
        if (cp[j] > cp[i]) s++;
      }
    }
    return s % 2;
  }

  /// Give the parity of the edge permutation. A solvable cube has the same corner and edge parity.
  int get edgeParity {
    int s = 0;

    for (int i = CubeEdge.BR.index; i > CubeEdge.UR.index; i--) {
      for (int j = i - 1; j > CubeEdge.UR.index - 1; j--) {
        if (ep[j] > ep[i]) s++;
      }
    }

    return s % 2;
  }

  String verify() {
    var edges = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < 12; i++) {
      edges[ep[i]] += 1;
    }

    for (int i = 0; i < 12; i++) {
      if (edges[i] != 1) return "Error: Some edges are undefined.";
    }

    int s = 0;
    for (int i = 0; i < 12; i++) {
      s += eo[i];
    }

    if (s % 2 != 0) return "Error: Total edge flip is wrong.";

    var corners = [0, 0, 0, 0, 0, 0, 0, 0];
    for (int i = 0; i < 8; i++) {
      corners[cp[i]] += 1;
    }

    for (int i = 0; i < 8; i++) {
      if (corners[i] != 1) return "Error: Some corners are undefined.";
    }

    s = 0;
    for (int i = 0; i < 8; i++) {
      s += co[i];
    }

    if (s % 3 != 0) return "Error: Total corner twist is wrong.";

    if (edgeParity != cornerParity) {
      return "Error: Wrongedge and corner parity.";
    }

    return CUBE_OK;
  }
}

// The basic six cube moves described by permutations and changes in orientation

// Up-move
const cpU = [
  CubeCorner.UBR,
  CubeCorner.URF,
  CubeCorner.UFL,
  CubeCorner.ULB,
  CubeCorner.DFR,
  CubeCorner.DLF,
  CubeCorner.DBL,
  CubeCorner.DRB
];
const coU = [0, 0, 0, 0, 0, 0, 0, 0];
const epU = [
  CubeEdge.UB,
  CubeEdge.UR,
  CubeEdge.UF,
  CubeEdge.UL,
  CubeEdge.DR,
  CubeEdge.DF,
  CubeEdge.DL,
  CubeEdge.DB,
  CubeEdge.FR,
  CubeEdge.FL,
  CubeEdge.BL,
  CubeEdge.BR
];
const eoU = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Right-move
const cpR = [
  CubeCorner.DFR,
  CubeCorner.UFL,
  CubeCorner.ULB,
  CubeCorner.URF,
  CubeCorner.DRB,
  CubeCorner.DLF,
  CubeCorner.DBL,
  CubeCorner.UBR
];
const coR = [2, 0, 0, 1, 1, 0, 0, 2];
const epR = [
  CubeEdge.FR,
  CubeEdge.UF,
  CubeEdge.UL,
  CubeEdge.UB,
  CubeEdge.BR,
  CubeEdge.DF,
  CubeEdge.DL,
  CubeEdge.DB,
  CubeEdge.DR,
  CubeEdge.FL,
  CubeEdge.BL,
  CubeEdge.UR
];
const eoR = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Front-move
const cpF = [
  CubeCorner.UFL,
  CubeCorner.DLF,
  CubeCorner.ULB,
  CubeCorner.UBR,
  CubeCorner.URF,
  CubeCorner.DFR,
  CubeCorner.DBL,
  CubeCorner.DRB
];
const coF = [1, 2, 0, 0, 2, 1, 0, 0];
const epF = [
  CubeEdge.UR,
  CubeEdge.FL,
  CubeEdge.UL,
  CubeEdge.UB,
  CubeEdge.DR,
  CubeEdge.FR,
  CubeEdge.DL,
  CubeEdge.DB,
  CubeEdge.UF,
  CubeEdge.DF,
  CubeEdge.BL,
  CubeEdge.BR
];
const eoF = [0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0];

// Down-move
const cpD = [
  CubeCorner.URF,
  CubeCorner.UFL,
  CubeCorner.ULB,
  CubeCorner.UBR,
  CubeCorner.DLF,
  CubeCorner.DBL,
  CubeCorner.DRB,
  CubeCorner.DFR
];
const coD = [0, 0, 0, 0, 0, 0, 0, 0];
const epD = [
  CubeEdge.UR,
  CubeEdge.UF,
  CubeEdge.UL,
  CubeEdge.UB,
  CubeEdge.DF,
  CubeEdge.DL,
  CubeEdge.DB,
  CubeEdge.DR,
  CubeEdge.FR,
  CubeEdge.FL,
  CubeEdge.BL,
  CubeEdge.BR
];
const eoD = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Left-move
const cpL = [
  CubeCorner.URF,
  CubeCorner.ULB,
  CubeCorner.DBL,
  CubeCorner.UBR,
  CubeCorner.DFR,
  CubeCorner.UFL,
  CubeCorner.DLF,
  CubeCorner.DRB
];
const coL = [0, 1, 2, 0, 0, 2, 1, 0];
const epL = [
  CubeEdge.UR,
  CubeEdge.UF,
  CubeEdge.BL,
  CubeEdge.UB,
  CubeEdge.DR,
  CubeEdge.DF,
  CubeEdge.FL,
  CubeEdge.DB,
  CubeEdge.FR,
  CubeEdge.UL,
  CubeEdge.DL,
  CubeEdge.BR
];
const eoL = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// Back-move
const cpB = [
  CubeCorner.URF,
  CubeCorner.UFL,
  CubeCorner.UBR,
  CubeCorner.DRB,
  CubeCorner.DFR,
  CubeCorner.DLF,
  CubeCorner.ULB,
  CubeCorner.DBL
];
const coB = [0, 0, 1, 2, 0, 0, 2, 1];
const epB = [
  CubeEdge.UR,
  CubeEdge.UF,
  CubeEdge.UL,
  CubeEdge.BR,
  CubeEdge.DR,
  CubeEdge.DF,
  CubeEdge.DL,
  CubeEdge.BL,
  CubeEdge.FR,
  CubeEdge.FL,
  CubeEdge.UB,
  CubeEdge.DB
];
const eoB = [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1];

const CUBE_OK = "OK";

final basic = [
  CubieCube.init(cpU, coU, epU, eoU),
  CubieCube.init(cpR, coR, epR, eoR),
  CubieCube.init(cpF, coF, epF, eoF),
  CubieCube.init(cpD, coD, epD, eoD),
  CubieCube.init(cpL, coL, epL, eoL),
  CubieCube.init(cpB, coB, epB, eoB),
];

final moveCube = [
  CubieCube()..multiply(basic[0]),
  CubieCube()..multiply(basic[0])..multiply(basic[0]),
  CubieCube()..multiply(basic[0])..multiply(basic[0])..multiply(basic[0]),
  CubieCube()..multiply(basic[1]),
  CubieCube()..multiply(basic[1])..multiply(basic[1]),
  CubieCube()..multiply(basic[1])..multiply(basic[1])..multiply(basic[1]),
  CubieCube()..multiply(basic[2]),
  CubieCube()..multiply(basic[2])..multiply(basic[2]),
  CubieCube()..multiply(basic[2])..multiply(basic[2])..multiply(basic[2]),
  CubieCube()..multiply(basic[3]),
  CubieCube()..multiply(basic[3])..multiply(basic[3]),
  CubieCube()..multiply(basic[3])..multiply(basic[3])..multiply(basic[3]),
  CubieCube()..multiply(basic[4]),
  CubieCube()..multiply(basic[4])..multiply(basic[4]),
  CubieCube()..multiply(basic[4])..multiply(basic[4])..multiply(basic[4]),
  CubieCube()..multiply(basic[5]),
  CubieCube()..multiply(basic[5])..multiply(basic[5]),
  CubieCube()..multiply(basic[5])..multiply(basic[5])..multiply(basic[5]),
];
