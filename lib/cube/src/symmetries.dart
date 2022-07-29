import 'package:rouxzen/cube/src/tables.dart';

import 'cubie.dart';
import 'enums.dart';
import 'defs.dart';

const INVALID = 65535;

// 120° clockwise rotation around the long diagonal URF-DBL
const cpROT_URF3 = [
  CubeCorner.URF,
  CubeCorner.DFR,
  CubeCorner.DLF,
  CubeCorner.UFL,
  CubeCorner.UBR,
  CubeCorner.DRB,
  CubeCorner.DBL,
  CubeCorner.ULB
];
const coROT_URF3 = [1, 2, 1, 2, 2, 1, 2, 1];
const epROT_URF3 = [
  CubeEdge.UF,
  CubeEdge.FR,
  CubeEdge.DF,
  CubeEdge.FL,
  CubeEdge.UB,
  CubeEdge.BR,
  CubeEdge.DB,
  CubeEdge.BL,
  CubeEdge.UR,
  CubeEdge.DR,
  CubeEdge.DL,
  CubeEdge.UL
];
const eoROT_URF3 = [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1];

// 180° rotation around the axis through the F and B centers
const cpROT_F2 = [
  CubeCorner.DLF,
  CubeCorner.DFR,
  CubeCorner.DRB,
  CubeCorner.DBL,
  CubeCorner.UFL,
  CubeCorner.URF,
  CubeCorner.UBR,
  CubeCorner.ULB
];
const coROT_F2 = [0, 0, 0, 0, 0, 0, 0, 0];
const epROT_F2 = [
  CubeEdge.DL,
  CubeEdge.DF,
  CubeEdge.DR,
  CubeEdge.DB,
  CubeEdge.UL,
  CubeEdge.UF,
  CubeEdge.UR,
  CubeEdge.UB,
  CubeEdge.FL,
  CubeEdge.FR,
  CubeEdge.BR,
  CubeEdge.BL
];
const eoROT_F2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// 90° clockwise rotation around the axis through the U and D centers
const cpROT_U4 = [
  CubeCorner.UBR,
  CubeCorner.URF,
  CubeCorner.UFL,
  CubeCorner.ULB,
  CubeCorner.DRB,
  CubeCorner.DFR,
  CubeCorner.DLF,
  CubeCorner.DBL
];
const coROT_U4 = [0, 0, 0, 0, 0, 0, 0, 0];
const epROT_U4 = [
  CubeEdge.UB,
  CubeEdge.UR,
  CubeEdge.UF,
  CubeEdge.UL,
  CubeEdge.DB,
  CubeEdge.DR,
  CubeEdge.DF,
  CubeEdge.DL,
  CubeEdge.BR,
  CubeEdge.FR,
  CubeEdge.FL,
  CubeEdge.BL
];
const eoROT_U4 = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1];

// reflection at the plane through the U, D, F, B centers
const cpMIRR_LR2 = [
  CubeCorner.UFL,
  CubeCorner.URF,
  CubeCorner.UBR,
  CubeCorner.ULB,
  CubeCorner.DLF,
  CubeCorner.DFR,
  CubeCorner.DRB,
  CubeCorner.DBL
];
const coMIRR_LR2 = [3, 3, 3, 3, 3, 3, 3, 3];
const epMIRR_LR2 = [
  CubeEdge.UL,
  CubeEdge.UF,
  CubeEdge.UR,
  CubeEdge.UB,
  CubeEdge.DL,
  CubeEdge.DF,
  CubeEdge.DR,
  CubeEdge.DB,
  CubeEdge.FL,
  CubeEdge.FR,
  CubeEdge.BR,
  CubeEdge.BL
];
const eoMIRR_LR2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

/// 4 Basic Symmetries
final basicSymCube = [
  CubieCube.init(cpROT_URF3, coROT_URF3, epROT_URF3, eoROT_URF3),
  CubieCube.init(cpROT_URF3, coROT_URF3, epROT_URF3, eoROT_URF3),
  CubieCube.init(cpROT_U4, coROT_U4, epROT_U4, eoROT_U4),
  CubieCube.init(cpMIRR_LR2, coMIRR_LR2, epMIRR_LR2, eoMIRR_LR2)
];

/// 48 [CubieCube] representing the 48 cube symmetries
///
/// ```text
///     symCube[] = ROT_URF3 * ROT_F2 * ROT_U4 * MIRR_LR2;
/// ```
final symCube = CubeSymmetries.createSymCube();

/// Indices for the inverse symmetries
///
/// ```text
///    invIdx[i] = i^-1
/// ```
final invIdx = CubeSymmetries.createInvIdx();

/// Group table for the 48 cube symmetries
///
/// ```text
///    multSym[i][j] = i * j
/// ```
final multSym = CubeSymmetries.createMultSym();

/// Generate the table for the conjugation of a move m by a symmetry s.
///
/// ```text
///    conjMove[m][s] = s*m*s^-1
/// ```
final conjMove = CubeSymmetries.createConjMove();

class CubeSymmetries {
  static List<CubieCube> createSymCube() {
    var result = List<CubieCube>();
    var cc = CubieCube();

    for (var _ in [0, 1, 2]) {
      for (var _ in [0, 1]) {
        for (var _ in [0, 1, 2, 3]) {
          for (var _ in [0, 1]) {
            result.add(CubieCube.copy(cc));
            cc.multiply(basicSymCube[BasicSymmetry.MIRR_LR2.index]);
          }
          cc.multiply(basicSymCube[BasicSymmetry.ROT_U4.index]);
        }
        cc.multiply(basicSymCube[BasicSymmetry.ROT_F2.index]);
      }
      cc.multiply(basicSymCube[BasicSymmetry.ROT_URF3.index]);
    }

    return result;
  }

  static List<int> createInvIdx() {
    var result = List<int>.filled(N_SYM, 0);
    for (var j = 0; j < N_SYM; j++) {
      for (var i = 0; i < N_SYM; i++) {
        var cc = CubieCube.copy(symCube[j]);
        cc.multiplyCorners(symCube[i]);
        if (cc.cp[CubeCorner.URF.index] == CubeCorner.URF.index &&
            cc.cp[CubeCorner.UFL.index] == CubeCorner.UFL.index &&
            cc.cp[CubeCorner.ULB.index] == CubeCorner.ULB.index) {
          result[j] = i;
          break;
        }
      }
    }
    return result;
  }

  static List<List<int>> createMultSym() {
    var result = List<List<int>>();

    for (var i = 0; i < N_SYM; i++) result.add(List<int>.filled(N_SYM, 0));

    for (var i = 0; i < N_SYM; i++) {
      for (var j = 0; j < N_SYM; j++) {
        var cc = CubieCube.copy(symCube[i]);
        cc.multiply(symCube[j]);

        // SymCube[i]*SymCube[j] == SymCube[k]
        result[i][j] = symCube.indexWhere((scc) => cc == scc);
      }
    }
    return result;
  }

  static List<List<int>> createConjMove() {
    var result = List<List<int>>();

    var totalMoves = CubeMove.values.length;
    for (int i = 0; i < totalMoves; i++) result.add(List<int>.filled(N_SYM, 0));

    for (int s = 0; s < N_SYM; s++) {
      for (int m = 0; m < totalMoves; m++) {
        var ss = CubieCube.copy(symCube[s]);
        ss.multiply(moveCube[m]);
        // s * m * s^-1
        ss.multiply(symCube[invIdx[s]]);
        result[m][s] = moveCube.indexWhere((mcc) => ss == mcc);
      }
    }

    return result;
  }

  TableCache cache;

  CubeSymmetries([this.cache]);

  List<int> _twistConj;

  /// phase 1 table for the conjugation of the twist t by a symmetry s.
  ///
  /// ```text
  ///   twistConj[t, s] = s*t*s^-1
  /// ```
  List<int> get twistConj {
    if (_twistConj != null) return _twistConj;
    if (cache != null) {
      _twistConj = cache.getListInt("conj_twist");
      if (_twistConj != null) return _twistConj;
    }

    _twistConj = List<int>.filled(N_TWIST * N_SYM_D4h, 0);
    cache?.updateProgress("conj_twist", 0, _twistConj.length);
    for (int t = 0; t < N_TWIST; t++) {
      var cc = CubieCube();
      cc.twist = t;

      for (var s = 0; s < N_SYM_D4h; s++) {
        var ss = CubieCube.copy(symCube[s]);
        ss.multiplyCorners(cc);
        ss.multiplyCorners(symCube[invIdx[s]]);

        // s*t*s^-1
        _twistConj[N_SYM_D4h * t + s] = ss.twist;
      }
    }

    if (cache != null) {
      cache.updateProgress("conj_twist", _twistConj.length, _twistConj.length);
      cache.storeListInt("conj_twist", _twistConj);
    }
    return _twistConj;
  }

  List<int> _udEdgesConj;

  /// phase 2 table for the conjugation of the URtoDB coordinate by a symmetrie
  List<int> get udEdgesConj {
    if (_udEdgesConj != null) return _udEdgesConj;
    if (cache != null) {
      _udEdgesConj = cache.getListInt("conj_ud_edges");
      if (_udEdgesConj != null) return _udEdgesConj;
    }

    _udEdgesConj = List<int>.filled(N_UD_EDGES * N_SYM_D4h, 0);
    cache?.updateProgress("conj_ud_edges", 0, _udEdgesConj.length);

    for (int t = 0; t < N_UD_EDGES; t++) {
      if ((t + 1) % 400 == 0)
        cache?.updateProgress(
            "conj_ud_edges", t * N_SYM_D4h, _udEdgesConj.length);

      var cc = CubieCube();
      cc.udEdges = t;

      for (var s = 0; s < N_SYM_D4h; s++) {
        var ss = CubieCube.copy(symCube[s]);
        ss.multiplyEdges(cc);
        ss.multiplyEdges(symCube[invIdx[s]]); // s*t*s^-1

        _udEdgesConj[N_SYM_D4h * t + s] = ss.udEdges;
      }
    }

    if (cache != null) {
      cache.updateProgress(
          "conj_ud_edges", _udEdgesConj.length, _udEdgesConj.length);
      cache.storeListInt("conj_ud_edges", _udEdgesConj);
    }
    return _udEdgesConj;
  }
}
