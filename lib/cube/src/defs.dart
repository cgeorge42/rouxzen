import 'enums.dart' show CubeFacelet, CubeColor;

/// Map the corner positions to facelet positions.
const cornerFacelet = [
  [CubeFacelet.U9, CubeFacelet.R1, CubeFacelet.F3],
  [CubeFacelet.U7, CubeFacelet.F1, CubeFacelet.L3],
  [CubeFacelet.U1, CubeFacelet.L1, CubeFacelet.B3],
  [CubeFacelet.U3, CubeFacelet.B1, CubeFacelet.R3],
  [CubeFacelet.D3, CubeFacelet.F9, CubeFacelet.R7],
  [CubeFacelet.D1, CubeFacelet.L9, CubeFacelet.F7],
  [CubeFacelet.D7, CubeFacelet.B9, CubeFacelet.L7],
  [CubeFacelet.D9, CubeFacelet.R9, CubeFacelet.B7]
];

/// Map the edge positions to facelet positions.
const edgeFacelet = [
  [CubeFacelet.U6, CubeFacelet.R2],
  [CubeFacelet.U8, CubeFacelet.F2],
  [CubeFacelet.U4, CubeFacelet.L2],
  [CubeFacelet.U2, CubeFacelet.B2],
  [CubeFacelet.D6, CubeFacelet.R8],
  [CubeFacelet.D2, CubeFacelet.F8],
  [CubeFacelet.D4, CubeFacelet.L8],
  [CubeFacelet.D8, CubeFacelet.B8],
  [CubeFacelet.F6, CubeFacelet.R4],
  [CubeFacelet.F4, CubeFacelet.L6],
  [CubeFacelet.B6, CubeFacelet.L4],
  [CubeFacelet.B4, CubeFacelet.R6]
];

/// Map the corner positions to facelet colors.
const cornerColor = [
  [CubeColor.U, CubeColor.R, CubeColor.F],
  [CubeColor.U, CubeColor.F, CubeColor.L],
  [CubeColor.U, CubeColor.L, CubeColor.B],
  [CubeColor.U, CubeColor.B, CubeColor.R],
  [CubeColor.D, CubeColor.F, CubeColor.R],
  [CubeColor.D, CubeColor.L, CubeColor.F],
  [CubeColor.D, CubeColor.B, CubeColor.L],
  [CubeColor.D, CubeColor.R, CubeColor.B]
];

/// Map the edge positions to facelet colors.
const edgeColor = [
  [CubeColor.U, CubeColor.R],
  [CubeColor.U, CubeColor.F],
  [CubeColor.U, CubeColor.L],
  [CubeColor.U, CubeColor.B],
  [CubeColor.D, CubeColor.R],
  [CubeColor.D, CubeColor.F],
  [CubeColor.D, CubeColor.L],
  [CubeColor.D, CubeColor.B],
  [CubeColor.F, CubeColor.R],
  [CubeColor.F, CubeColor.L],
  [CubeColor.B, CubeColor.L],
  [CubeColor.B, CubeColor.R]
];

const N_PERM_4 = 24;
const N_CHOOSE_8_4 = 70;

/// /// number of possible face moves
const N_MOVE = 18;

/// 3^7 possible corner orientations in phase 1
const N_TWIST = 2187;

/// 2^11 possible edge orientations in phase 1
const N_FLIP = 2048;

/// 12*11*10*9 possible positions of the FR, FL, BL, BR edges in phase 1
const N_SLICE_SORTED = 11880;

/// N_PERM_4  /// we ignore the permutation of FR, FL, BL, BR in phase 1
const N_SLICE = N_SLICE_SORTED;

/// number of equivalence classes for combined flip+slice concerning symmetry group D4h
const N_FLIPSLICE_CLASS = 64430;

/// number of different positions of the edges UR, UF, UL and UB in phase 2
const N_U_EDGES_PHASE2 = 1680;

/// number of different positions of the edges DR, DF, DL and DB in phase 2
const N_D_EDGES_PHASE2 = 1680;

/// 8! corner permutations in phase 2
const N_CORNERS = 40320;

/// number of equivalence classes concerning symmetry group D4h
const N_CORNERS_CLASS = 2768;

/// 8! permutations of the edges in the U-face and D-face in phase 2
const N_UD_EDGES = 40320;

/// number of cube symmetries of full group Oh
const N_SYM = 48;

/// Number of symmetries of subgroup D4h
const N_SYM_D4h = 16;
