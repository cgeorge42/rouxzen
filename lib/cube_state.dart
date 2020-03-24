import 'package:mobx/mobx.dart';
import 'package:rouxzen/cube/cube.dart';

import 'cube_command.dart';
part 'cube_state.g.dart';

// ignore_for_file: unused_element

class CubeState = _CubeState with _$CubeState;

abstract class _CubeState with Store {
  @observable
  String sequence = FaceCube.solved.toString();

  @observable
  CubeAxis axis = CubeAxis.UR;

  final ObservableList<CubeCommand> moves = ObservableList();

  @computed
  bool get isSolved =>
      sequence == "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";

  @computed
  List<int> get rotation {
    var axisAngles = [
      // UR
      [0, 0, 0], // ok
      // UF
      [-90, 0, 0], // ok
      // UL
      [180, 0, 0], // ok
      // UB
      [90, 0, 0], // ok

      // RU
      [0, 180, 90], // ok
      // RF
      [90, 180, 90], // ok
      // RD
      [0, 0, -90], // ok
      // RB
      [90, 0, -90], // ok

      // FU
      [90, 90, 0], // ok
      // FR
      [0, 90, 0], // ok
      // FD
      [-90, 90, 0], // ok
      // FL
      [180, 90, 0], // ok

      // DR
      [0, 180, 0], // ok
      // DF
      [90, 180, 0], // ok
      // DL
      [180, 180, 0], // ok
      // DB
      [-90, 180, 0], // ok

      // LU
      [0, 0, 90], // ok
      // LF
      [-90, 0, 90], // ok
      // LD
      [180, 0, 90], // ok
      // LB
      [90, 0, 90], // ok

      // BU
      [-90, -90, 0], // ok
      // BR
      [0, -90, 0], // ok
      // BD
      [90, -90, 0], // ok
      // BL
      [180, -90, 0] // ok
    ];

    return axisAngles[axis.index];
  }

  @computed
  List<CubeColor> get stickers {
    var up = sequence.substring(CubeFacelet.U1.index, CubeFacelet.U9.index + 1);
    var down =
        sequence.substring(CubeFacelet.D1.index, CubeFacelet.D9.index + 1);
    var left =
        sequence.substring(CubeFacelet.L1.index, CubeFacelet.L9.index + 1);
    var right =
        sequence.substring(CubeFacelet.R1.index, CubeFacelet.R9.index + 1);
    var front =
        sequence.substring(CubeFacelet.F1.index, CubeFacelet.F9.index + 1);
    var back =
        sequence.substring(CubeFacelet.B1.index, CubeFacelet.B9.index + 1);

    var result = List<CubeColor>();
    result.addAll(_mapSticker(up));
    result.addAll(_mapSticker(left));
    result.addAll(_mapSticker(front));
    result.addAll(_mapSticker(right));
    result.addAll(_mapSticker(back));
    result.addAll(_mapSticker(down));
    return result;
  }

  Iterable<CubeColor> _mapSticker(String seq) sync* {
    for (int i = 0; i < seq.length; i++) {
      switch (seq[i]) {
        case "F":
          yield CubeColor.F;
          break;
        case "B":
          yield CubeColor.B;
          break;
        case "U":
          yield CubeColor.U;
          break;
        case "D":
          yield CubeColor.D;
          break;
        case "L":
          yield CubeColor.L;
          break;
        case "R":
          yield CubeColor.R;
          break;
      }
    }
  }

  @action
  CubeCommand pop() {
    if (moves.isNotEmpty) {
      var last = moves.removeAt(0);
      return last;
    }
    return null;
  }

  @action
  push(CubeCommand move) {
    moves.add(move);
  }

  @action
  pushAll(Iterable<CubeCommand> sequence, {bool reversed = false}) {
    for (var cmd in sequence) {
      push(cmd);
    }
  }

  @computed
  String get debugCube => FaceCube.parse(sequence).to2dString();

  @action
  void reset() {
    _reset();
  }

  @action
  void apply(String pattern, {bool reversed = false}) {
    var moves = CubeCommand.parseAll(pattern);

    for (var move in reversed ? moves.reversed : moves) {
      _apply(move);
    }
  }

  @action
  void step(CubeCommand next) {
    _apply(next);
  }

  void _reset() {
    sequence = FaceCube.solved.toString();
    axis = CubeAxis.UR;
  }

  void _applySlice(CubeCommand move) {
    switch (move.face) {
      case CubeColor.F:
        _standing(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.B:
        _standing(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.L:
        _middle(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.R:
        _middle(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.U:
        _equitorial(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.D:
        _equitorial(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.none:
        break;
    }
  }

  void _applyRotate(CubeCommand move) {
    switch (move.face) {
      case CubeColor.F:
        _rotateZ(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.B:
        _rotateZ(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.L:
        _rotateX(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.R:
        _rotateX(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.U:
        _rotateY(move.reversed, doubled: move.doubled);
        break;
      case CubeColor.D:
        _rotateY(!move.reversed, doubled: move.doubled);
        break;
      case CubeColor.none:
        break;
    }
  }

  void _apply(CubeCommand move) {
    if (move.reset) {
      _reset();
      return;
    }
    move = move.remap(axis);

    if (move.slice) {
      _applySlice(move);
      return;
    }
    if (move.rotate) {
      _applyRotate(move);
      return;
    }

    switch (move.face) {
      case CubeColor.F:
        _front(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.B:
        _back(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.L:
        _left(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.R:
        _right(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.U:
        _up(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.D:
        _down(move.reversed, wide: move.wide, doubled: move.doubled);
        break;
      case CubeColor.none:
        break;
    }
  }

  void _rotateX(bool reversed, {bool doubled = false}) {
    var count = _moves(reversed, doubled);
    for (int i = 0; i < count; i++) {
      axis = _rotateXAxis(axis);
    }
  }

  void _rotateY(bool reversed, {bool doubled = false}) {
    var count = _moves(reversed, doubled);
    for (int i = 0; i < count; i++) {
      axis = _rotateYAxis(axis);
    }
  }

  void _rotateZ(bool reversed, {bool doubled = false}) {
    var count = _moves(reversed, doubled);
    for (int i = 0; i < count; i++) {
      axis = _rotateZAxis(axis);
    }
  }

  CubeAxis _rotateZAxis(CubeAxis axis) {
    var map = [
      CubeAxis.LU, // UR ok
      CubeAxis.LF, // UF OK
      CubeAxis.LD, // UL ok
      CubeAxis.LB, // UB OK

      CubeAxis.UL, // RU ok
      CubeAxis.UF, // RF ok
      CubeAxis.UR, // RD ok
      CubeAxis.UB, // RB ok

      CubeAxis.FL, // FU ok
      CubeAxis.FU, // FR ok
      CubeAxis.FR, // FD ok
      CubeAxis.FD, // FL ok

      CubeAxis.RU, // DR ok
      CubeAxis.RF, // DF ok
      CubeAxis.RD, // DL ok
      CubeAxis.RB, // DB ok

      CubeAxis.DL, // LU ok
      CubeAxis.DF, // LF ok
      CubeAxis.DR, // LD ok
      CubeAxis.DB, // LB ok

      CubeAxis.BL, // BU ok
      CubeAxis.BU, // BR ok
      CubeAxis.BR, // BD ok
      CubeAxis.BD, // BL ok
    ];
    return map[axis.index];
  }

  CubeAxis _rotateXAxis(CubeAxis axis) {
    var map = [
      CubeAxis.FR, // UR ok
      CubeAxis.FD, // UF ok
      CubeAxis.FL, // UL ok
      CubeAxis.FU, // UB ok

      CubeAxis.RF, // RU ok
      CubeAxis.RD, // RF ok
      CubeAxis.RB, // RD ok
      CubeAxis.RU, // RB ok

      CubeAxis.DF, // FU ok
      CubeAxis.DR, // FR ok
      CubeAxis.DB, // FD ok
      CubeAxis.DL, // FL ok

      CubeAxis.BR, // DR ok
      CubeAxis.BD, // DF ok
      CubeAxis.BL, // DL ok
      CubeAxis.BU, // DB ok

      CubeAxis.LF, // LU ok
      CubeAxis.LD, // LF ok
      CubeAxis.LB, // LD ok
      CubeAxis.LU, // LB ok

      CubeAxis.UF, // BU ok
      CubeAxis.UR, // BR ok
      CubeAxis.UB, // BD ok
      CubeAxis.UL, // BL ok
    ];
    return map[axis.index];
  }

  CubeAxis _rotateYAxis(CubeAxis axis) {
    var map = [
      CubeAxis.UB, // UR ok
      CubeAxis.UR, // UF ok
      CubeAxis.UF, // UL ok
      CubeAxis.UL, // UB ok

      CubeAxis.BU, // RU OK
      CubeAxis.BR, // RF OK
      CubeAxis.BD, // RD OK
      CubeAxis.BL, // RB OK

      CubeAxis.RU, // FU OK
      CubeAxis.RB, // FR OK
      CubeAxis.RD, // FD OK
      CubeAxis.RF, // FL OK

      CubeAxis.DB, // DR ok
      CubeAxis.DR, // DF ok
      CubeAxis.DF, // DL ok
      CubeAxis.DL, // DB ok

      CubeAxis.FU, // LU OK
      CubeAxis.FR, // LF OK
      CubeAxis.FD, // LD OK
      CubeAxis.FL, // LB OK

      CubeAxis.LU, // BU OK
      CubeAxis.LB, // BR OK
      CubeAxis.LD, // BD OK
      CubeAxis.LF, // BL OK
    ];

    return map[axis.index];
  }

  int _moves(bool reversed, bool doubled) {
    var move = reversed ? -1 : 1;
    if (doubled) move *= 2;
    if (move < 0) move += 4;
    if (move >= 4) move -= 4;
    return move;
  }

  void _front(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.B, count);
      _rotateZ(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.F, count);
    }

    sequence = cube.sequence;
  }

  void _back(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.F, count);
      _rotateZ(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.B, count);
    }

    sequence = cube.sequence;
  }

  void _right(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.L, count);
      _rotateX(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.R, count);
    }

    sequence = cube.sequence;
  }

  void _left(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.R, count);
      _rotateX(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.L, count);
    }

    sequence = cube.sequence;
  }

  void _up(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.D, count);
      _rotateY(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.U, count);
    }

    sequence = cube.sequence;
  }

  void _down(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(sequence);

    if (wide) {
      cube.apply(CubeColor.U, count);
      _rotateY(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.D, count);
    }

    sequence = cube.sequence;
  }

  void _middle(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(sequence);

    cube.apply(CubeColor.L, _moves(!reversed, doubled));
    cube.apply(CubeColor.R, _moves(reversed, doubled));
    _rotateX(!reversed, doubled: doubled);

    sequence = cube.sequence;
  }

  void _standing(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(sequence);

    cube.apply(CubeColor.F, _moves(!reversed, doubled));
    cube.apply(CubeColor.B, _moves(reversed, doubled));
    _rotateZ(reversed, doubled: doubled);

    sequence = cube.sequence;
  }

  void _equitorial(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(sequence);

    cube.apply(CubeColor.U, _moves(reversed, doubled));
    cube.apply(CubeColor.D, _moves(!reversed, doubled));
    _rotateY(!reversed, doubled: doubled);

    sequence = cube.sequence;
  }
}
