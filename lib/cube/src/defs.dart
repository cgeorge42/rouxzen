import 'enums.dart' show Facelet, Color;

/// Map the corner positions to facelet positions.
const cornerFacelet = [
  [Facelet.U9, Facelet.R1, Facelet.F3],
  [Facelet.U7, Facelet.F1, Facelet.L3],
  [Facelet.U1, Facelet.L1, Facelet.B3],
  [Facelet.U3, Facelet.B1, Facelet.R3],
  [Facelet.D3, Facelet.F9, Facelet.R7],
  [Facelet.D1, Facelet.L9, Facelet.F7],
  [Facelet.D7, Facelet.B9, Facelet.L7],
  [Facelet.D9, Facelet.R9, Facelet.B7]
];

/// Map the edge positions to facelet positions.
const edgeFacelet = [
  [Facelet.U6, Facelet.R2],
  [Facelet.U8, Facelet.F2],
  [Facelet.U4, Facelet.L2],
  [Facelet.U2, Facelet.B2],
  [Facelet.D6, Facelet.R8],
  [Facelet.D2, Facelet.F8],
  [Facelet.D4, Facelet.L8],
  [Facelet.D8, Facelet.B8],
  [Facelet.F6, Facelet.R4],
  [Facelet.F4, Facelet.L6],
  [Facelet.B6, Facelet.L4],
  [Facelet.B4, Facelet.R6]
];

/// Map the corner positions to facelet colors.
const cornerColor = [
  [Color.U, Color.R, Color.F],
  [Color.U, Color.F, Color.L],
  [Color.U, Color.L, Color.B],
  [Color.U, Color.B, Color.R],
  [Color.D, Color.F, Color.R],
  [Color.D, Color.L, Color.F],
  [Color.D, Color.B, Color.L],
  [Color.D, Color.R, Color.B]
];

/// Map the edge positions to facelet colors.
const edgeColor = [
  [Color.U, Color.R],
  [Color.U, Color.F],
  [Color.U, Color.L],
  [Color.U, Color.B],
  [Color.D, Color.R],
  [Color.D, Color.F],
  [Color.D, Color.L],
  [Color.D, Color.B],
  [Color.F, Color.R],
  [Color.F, Color.L],
  [Color.B, Color.L],
  [Color.B, Color.R]
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
