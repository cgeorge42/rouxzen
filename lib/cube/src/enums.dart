/// The names of the facelet positions of the cube
/// ```text
/// Facelets are defined in order: Up, Right, Front, Down, Left, Back
///               .------------.
///               | U1  U2  U3 |
///               |            |
///               | U4  U5  U6 |
///               |            |
///               | U7  U8  U9 |
///  .------------+------------+-------------------------.
///  | L1  L2  L3 | F1  F2  F3 | R1  R2  R3 | B1  B2  B3 |
///  |            |            |            |            |
///  | L4  L5  L6 | F4  F5  F6 | R4  R5  R6 | B4  B5  B6 |
///  |            |            |            |            |
///  | L7  L8  L9 | F7  F8  F9 | R7  R8  R9 | B7  B8  B9 |
///  '------------+------------+-------------------------'
///               | D1  D2  D3 |
///               |            |
///               | D4  D5  D6 |
///               |            |
///               | D7  D8  D9 |
///               '------------'
/// ```
///
/// A cube definition string "UBL..." means for example: In position U1 we have
/// the U-[Color], in position U2 we have the B-[Color], in position U3 we have the
/// L color etc.
///
/// Facelets are defined in order: Up, Right, Front, Down, Left, Back
enum Facelet {
  U1,
  U2,
  U3,
  U4,
  U5,
  U6,
  U7,
  U8,
  U9,
  R1,
  R2,
  R3,
  R4,
  R5,
  R6,
  R7,
  R8,
  R9,
  F1,
  F2,
  F3,
  F4,
  F5,
  F6,
  F7,
  F8,
  F9,
  D1,
  D2,
  D3,
  D4,
  D5,
  D6,
  D7,
  D8,
  D9,
  L1,
  L2,
  L3,
  L4,
  L5,
  L6,
  L7,
  L8,
  L9,
  B1,
  B2,
  B3,
  B4,
  B5,
  B6,
  B7,
  B8,
  B9
}

/// The possible colors of the cube [Facelet]. Color U refers to the color of the U(p)-face etc. Also used to name the faces itself.
enum Color { U, R, F, D, L, B }

final colorNames = [
  for (var c in Color.values) c.toString().replaceAll("Color.", "")
];

/// The names of the corner positions of the cube. Corner URF e.g. has an U(p), a R(ight) and a F(ront) [Faclet].
enum Corner { URF, UFL, ULB, UBR, DFR, DLF, DBL, DRB }

final cornerNames = [
  for (var c in Corner.values) c.toString().replaceAll("Corner.", "")
];

/// The names of the edge positions of the cube. Edge UR e.g. has an U(p) and R(ight) [Facelet].
enum Edge { UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR }

final edgeNames = [
  for (var e in Edge.values) e.toString().replaceAll("Edge.", "")
];

/// The moves in the faceturn metric. Not to be confused with the names of the facelet positions in class [Facelet].
enum Move {
  U1,
  U2,
  U3,
  R1,
  R2,
  R3,
  F1,
  F2,
  F3,
  D1,
  D2,
  D3,
  L1,
  L2,
  L3,
  B1,
  B2,
  B3
}

final moveNames = [
  for (var m in Move.values) m.toString().replaceAll("Move.", "")
];

/// Basic symmetries of the cube. All 48 cube symmetries can be generated by sequences of these 4 symmetries.
enum BasicSymmetry { ROT_URF3, ROT_F2, ROT_U4, MIRR_LR2 }

final basicSymmetry = [
  for (var bs in BasicSymmetry.values)
    bs.toString().replaceAll("BasicSymmetry.", "")
];