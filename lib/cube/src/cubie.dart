import 'dart:math';

import 'package:rouxzen/cube/src/utils.dart';

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
    cp = [...allCorners];
    co = [0, 0, 0, 0, 0, 0, 0, 0];
    ep = [...allEdges];
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

  CubieCube.random() {
    randomize();
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
    var edgeCount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < 12; i++) {
      edgeCount[ep[i]] += 1;
    }

    for (int i = 0; i < 12; i++) {
      if (edgeCount[i] != 1) return "Error: Some edges are undefined.";
    }

    int s = 0;
    for (int i = 0; i < 12; i++) {
      s += eo[i];
    }

    if (s % 2 != 0) return "Error: Total edge flip is wrong.";

    var cornerCount = [0, 0, 0, 0, 0, 0, 0, 0];
    for (int i = 0; i < 8; i++) {
      cornerCount[cp[i]] += 1;
    }

    for (int i = 0; i < 8; i++) {
      if (cornerCount[i] != 1) return "Error: Some corners are undefined.";
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

  /// Generate a random cube.
  ///
  /// The probability is the same for all possible states.
  void randomize() {
    var rnd = Random();
    edges = rnd.nextInt(479001600); // 12!

    var p = edgeParity;
    while (true) {
      corners = rnd.nextInt(40320); // 8!
      if (p == cornerParity) break;
    }

    flip = rnd.nextInt(2048); // 2^11
    twist = rnd.nextInt(2187); // 3^7
  }

  /// Set the permutation of the 12 edges.
  set edges(int idx) {
    ep = [...allEdges];
    for (var j in allEdges) {
      var k = idx % (j + 1);
      idx = (idx / (j + 1)).floor();
      while (k > 0) {
        rotateRight(ep, 0, j);
        k -= 1;
      }
    }
  }

  /// Get the permutation of the 8 corners.
  ///
  /// 0 <= corners < 40320 defined but unused in phase 1, 0 <= corners < 40320 in phase 2,
  /// corners = 0 for solved cube

  int get corners {
    var perm = [...cp]; // copy corner permutation to rotate it

    var b = 0;
    for (var j in range(CubeCorner.DRB.index, CubeCorner.URF.index, -1)) {
      var k = 0;
      while (perm[j] != j) {
        rotateLeft(perm, 0, j);
        k += 1;
      }
      b = (j + 1) * b + k;
    }
    return b;
  }

  /// Set the permuation of the 8 corners.
  set corners(int idx) {
    cp = [...allCorners];
    for (var j in allCorners) {
      var k = idx % (j + 1);
      idx = (idx / (j + 1)).floor();
      while (k > 0) {
        rotateRight(cp, 0, j);
        k -= 1;
      }
    }
  }

  /// Get the flip of the 12 edges.
  ///
  /// 0 <= flip < 2048 in phase 1, flip = 0 in phase 2.
  int get flip {
    int result = 0;
    for (var i in range(CubeEdge.UR.index, CubeEdge.BR.index)) {
      result = 2 * result + eo[i];
    }
    return result;
  }

  /// Set the orientation of the 12 edges.
  set flip(int idx) {
    var fparity = 0;
    eo = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    // set the first 11 edges
    for (var i in range(CubeEdge.BR.index - 1, CubeEdge.UR.index - 1, -1)) {
      eo[i] = idx % 2;
      fparity += eo[i];
      idx = (idx / 2).floor();
    }

    // orientation of the last edge is determined by the flip of the other 11
    eo[CubeEdge.BR.index] = ((2 - (fparity % 2)) % 2);
  }

  /// Get the twist of the 8 corners.
  ///
  /// 0 <= twist < 2187 in phase 1, twist = 0 in phase 2
  int get twist {
    int result = 0;
    for (var i in range(CubeCorner.URF.index, CubeCorner.DRB.index)) {
      result = 3 * result + co[i];
    }
    return result;
  }

  /// Set the orientation of the 8 corners
  set twist(int idx) {
    var tparity = 0;
    co = [0, 0, 0, 0, 0, 0, 0, 0];
    // Set the first 7 edges
    for (var i
        in range(CubeCorner.DRB.index - 1, CubeCorner.URF.index - 1, -1)) {
      co[i] = idx % 3;
      tparity += co[i];
      idx = (idx / 3).floor();
    }

    // orientation of the last corner is determined by the twist of the other 8
    co[CubeCorner.DRB.index] = ((3 - (tparity % 3)) % 3);
  }

  /// Get the location of the UD-slice edges FR,FL,BL and BR ignoring their permutation.
  ///
  /// 0<= slice < 495 in phase 1, slice = 0 in phase 2.
  int get slice {
    int a = 0;
    int x = 0;

    // Compute the index a < (12 choose 4)
    for (var j in range(CubeEdge.BR.index, CubeEdge.UR.index - 1, -1)) {
      if (CubeEdge.FR.index <= ep[j] && ep[j] <= CubeEdge.BR.index) {
        a += coeffNchooseK(11 - j, x + 1);
        x += 1;
      }
    }
    return a;
  }

  set slice(int idx) {
    var sliceEdge = [...allEdges.skip(8)];
    var otherEdge = [...allEdges.take(8)];
    var a = idx; // Location

    for (int e = 0; e < 12; e++) {
      ep[e] = -1; // Invalidate all edge positions

      var x = 4; // set slice edges
      for (var j = 0; j < 12; j++) {
        if (a - coeffNchooseK(11 - j, x) >= 0) {
          ep[j] = sliceEdge[4 - x];
          a -= coeffNchooseK(11 - j, x);
          x -= 1;
        }
      }

      x = 0; // set the remaining edges UR..DB

      for (var j = 0; j < 12; j++) {
        if (ep[j] == -1) {
          ep[j] = otherEdge[x];
          x += 1;
        }
      }
    }
  }

  /// Get the permutation and location of the UD-slice edges FR,FL,BL and BR.
  ///
  ///0 <= sliceSorted < 11880 in phase 1, 0 <= sliceSorted < 24 in phase 2, sliceSorted = 0 for solved cube.
  int get sliceSorted {
    var a = 0;
    var x = 0;
    var edge4 = [0, 0, 0, 0];

    // First compute the index a < (12 choose 4) and the permutation array perm.
    for (var j in range(CubeEdge.BR.index, CubeEdge.UR.index - 1, -1)) {
      if (CubeEdge.FR.index <= ep[j] && ep[j] <= CubeEdge.BR.index) {
        a += coeffNchooseK(11 - j, x + 1);
        edge4[3 - x] = ep[j];
        x += 1;
      }
    }

    // Then compute the index b < 4! for the permutation in edge4
    var b = 0;
    for (var j in range(3, 0, -1)) {
      var k = 0;
      while (edge4[j] != j + 8) {
        rotateLeft(edge4, 0, j);
        k += 1;
      }
      b = (j + 1) * b + k;
    }
    return 24 * a + b;
  }

  set sliceSorted(int idx) {
    var sliceEdge = [...allEdges.skip(8)];
    var otherEdge = [...allEdges.take(8)];

    var b = idx % 24; // Permutation
    var a = (idx / 24).floor(); // Location
    for (var e in allEdges) {
      ep[e] = -1;
    } // Invalidate all edge positions

    var j = 1; // generate permutation from index b
    while (j < 4) {
      var k = b % (j + 1);
      b = (b / (j + 1)).floor();
      while (k > 0) {
        rotateRight(sliceEdge, 0, j);
        k -= 1;
      }
      j += 1;
    }

    var x = 4; // set slice edges
    for (var j in allEdges) {
      if (a - coeffNchooseK(11 - j, x) >= 0) {
        ep[j] = sliceEdge[4 - x];
        a -= coeffNchooseK(11 - j, x);
        x -= 1;
      }
    }

    x = 0; // set the remaining edges UR..DB
    for (j in allEdges) {
      if (ep[j] == -1) {
        ep[j] = otherEdge[x];
        x += 1;
      }
    }
  }

  ///Get the permutation and location of edges UR, UF, UL and UB.
  ///
  ///0 <= uEdges < 11880 in phase 1, 0 <= uEdges < 1680 in phase 2, uEdges = 1656 for solved cube.
  int get uEdges => _getEdges(CubeEdge.UR.index, CubeEdge.UB.index, 0);

  set uEdges(int idx) {
    var sliceEdge = [...allEdges.take(4)];
    var otherEdge = [...allEdges.skip(4)];
    _setEdges(idx, sliceEdge, otherEdge);
  }

  /// Get the permutation and location of the edges DR, DF, DL and DB.
  ///
  /// 0 <= dEdges < 11880 in phase 1, 0 <= dEdges < 1680 in phase 2, dEdges = 0 for solved cube.
  int get dEdges => _getEdges(CubeEdge.DR.index, CubeEdge.DB.index, 4);

  set dEdges(int idx) {
    var sliceEdge = [...allEdges.sublist(4, 8)];
    var otherEdge = [...allEdges.skip(8), ...allEdges.take(4)];
    _setEdges(idx, sliceEdge, otherEdge);
  }

  int _getEdges(int first, int last, int offset) {
    var a = 0;
    var x = 0;
    var edge4 = [0, 0, 0, 0];
    var mod = [...ep];

    rotateRight(mod, 0, 11);
    rotateRight(mod, 0, 11);
    rotateRight(mod, 0, 11);
    rotateRight(mod, 0, 11);

    // First compute the index a < (12 choose 4) and the permutation array perm.
    for (var j in range(CubeEdge.BR.index, CubeEdge.UR.index - 1, -1)) {
      if (first <= mod[j] && mod[j] <= last) {
        a += coeffNchooseK(11 - j, x + 1);
        edge4[3 - x] = mod[j];
        x += 1;
      }
    }
    // Then compute the index b < 4! for the permutation in edge4
    var b = 0;
    for (var j in range(3, 0, -1)) {
      var k = 0;
      while (edge4[j] != j + offset) {
        rotateLeft(edge4, 0, j);
        k += 1;
      }
      b = (j + 1) * b + k;
    }
    return 24 * a + b;
  }

  void _setEdges(int idx, List<int> sliceEdge, List<int> otherEdge) {
    var b = idx % 24; // Permutation
    var a = (idx / 24).floor(); // Location
    for (var e in allEdges) ep[e] = -1; // Invalidate all edge positions

    var j = 1; // generate permutation from index b
    while (j < 4) {
      var k = b % (j + 1);
      b = (b / (j + 1)).floor();
      while (k > 0) {
        rotateRight(sliceEdge, 0, j);
        k -= 1;
      }
      j += 1;
    }

    var x = 4; // set slice edges
    for (var j in allEdges) {
      if (a - coeffNchooseK(11 - j, x) >= 0) {
        ep[j] = sliceEdge[4 - x];
        a -= coeffNchooseK(11 - j, x);
        x -= 1;
      }
    }
    x = 0; // set the remaining edges UR..DB
    for (var j in allEdges) {
      if (ep[j] == -1) {
        ep[j] = otherEdge[x];
        x += 1;
      }
    }

    rotateLeft(ep, 0, 11);
    rotateLeft(ep, 0, 11);
    rotateLeft(ep, 0, 11);
    rotateLeft(ep, 0, 11);
  }

  /// Get the permutation of the 8 U and D edges.
  ///
  /// udEdges undefined in phase 1, 0 <= udEdges < 40320 in phase 2, udEdges = 0 for solved cube.
  int get udEdges {
    var perm = [...ep.take(8)]; // duplicate first 8 elements of ep
    var b = 0;
    for (var j in range(CubeEdge.DB.index, CubeEdge.UR.index, -1)) {
      var k = 0;
      while (perm[j] != j) {
        rotateLeft(perm, 0, j);
        k += 1;
      }
      b = (j + 1) * b + k;
    }
    return b;
  }

  set udEdges(int idx) {
    // positions of FR FL BL BR edges are not affected
    for (var i in allEdges.take(8)) ep[i] = i;

    for (var j in allEdges.take(8)) {
      var k = idx % (j + 1);
      idx = (idx / (j + 1)).floor();
      while (k > 0) {
        rotateRight(ep, 0, j);
        k -= 1;
      }
    }
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
