import 'package:rouxzen/cube/cube.dart';

import "defs.dart";

const SOLVED = 0;

/// Represent a cube on the coordinate level.
///
/// In phase 1 a state is uniquely determined by the three coordinates flip, twist and slice.
/// In phase 2 a state is uniquely determined by the three coordinates corners, ud_edges and slice_sorted.
///
class CoordCube {
  /// twist of the corners
  int twist = SOLVED;

  /// flip of edges
  int flip = SOLVED;

  /// corner permutation. Valid in phase1 and phase2
  int corners = SOLVED;

  /// Position of FR, FL, BL, BR edges.
  ///
  /// Valid in phase 1 (<11880) and phase 2 (<24)
  int sliceSorted = SOLVED;

  /// Valid in phase 1 (<11880) and phase 2 (<1680).
  ///
  /// 1656 is the index of solved u_edges.
  int uEdges = 1656;

  /// Valid in phase 1 (<11880) and phase 2 (<1680)
  int dEdges = SOLVED;

  /// Permutation of the UD-edges. Valid only in phase 2
  int udEdges = SOLVED;

  CoordCube([CubieCube source]) {
    if (source != null) {
      twist = source.twist;
      flip = source.flip;
      sliceSorted = source.sliceSorted;
      uEdges = source.uEdges;
      dEdges = source.dEdges;
      corners = source.corners;

      // phase 2 cube
      udEdges = isPhase2 ? source.udEdges : -1;
    }
  }

  /// The phase 1 slice coordinate is given by slice_sorted // 24
  int get slice => (sliceSorted / 24).floor();

  bool get isPhase1 => !isPhase2;
  bool get isPhase2 => sliceSorted < N_PERM_4;

  @override
  String toString() {
    return "(twist: $twist, flip: $flip, slice: $slice, U-edges: $uEdges, "
        "D-edges: $dEdges, E-edges: $sliceSorted, Corners: $corners, UD-edges: $udEdges)";
  }
}
