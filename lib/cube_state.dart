import 'package:mobx/mobx.dart';
import 'package:rouxzen/cube/cube.dart';

import 'cube_command.dart';
part 'cube_state.g.dart';

// ignore_for_file: unused_element

class CubeState = _CubeState with _$CubeState;

abstract class _CubeState with Store {
  @observable
  CubeAxis axis = CubeAxis.UR;

  @observable
  String state = FaceCube.solved;

  @observable
  String resetState = FaceCube.solved;

  @observable
  CubeAxis resetAxis = CubeAxis.UR;

  final ObservableList<CubeCommand> moves = ObservableList();

  @observable
  int current = -1;

  @computed
  bool get isSolved => state == FaceCube.solved;

  @computed
  List<int> get rotation => _axisAngles[axis.index];

  /// converts [CubeAxis] into rotation in degress ```[U, R, F]```
  final _axisAngles = [
    [0, 0, 0], //     UR
    [-90, 0, 0], //   UF
    [180, 0, 0], //   UL
    [90, 0, 0], //    UB

    [0, 180, 90], //  RU
    [90, 180, 90], // RF
    [0, 0, -90], //   RD
    [90, 0, -90], //  RB

    [90, 90, 0], //   FU
    [0, 90, 0], //    FR
    [-90, 90, 0], //  FD
    [180, 90, 0], //  FL

    [0, 180, 0], //   DR
    [90, 180, 0], //  DF
    [180, 180, 0], // DL
    [-90, 180, 0], // DB

    [0, 0, 90], //    LU
    [-90, 0, 90], //  LF
    [180, 0, 90], //  LD
    [90, 0, 90], //   LB

    [-90, -90, 0], // BU
    [0, -90, 0], //   BR
    [90, -90, 0], //  BD
    [180, -90, 0] //  BL
  ];

  @computed
  List<CubeColor> get stickers {
    var up = state.substring(CubeFacelet.U1.index, CubeFacelet.U9.index + 1);
    var down = state.substring(CubeFacelet.D1.index, CubeFacelet.D9.index + 1);
    var left = state.substring(CubeFacelet.L1.index, CubeFacelet.L9.index + 1);
    var right = state.substring(CubeFacelet.R1.index, CubeFacelet.R9.index + 1);
    var front = state.substring(CubeFacelet.F1.index, CubeFacelet.F9.index + 1);
    var back = state.substring(CubeFacelet.B1.index, CubeFacelet.B9.index + 1);

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
  void push(CubeCommand move) {
    moves.add(move);
  }

  @action
  void pushAll(Iterable<CubeCommand> sequence, {bool reversed = false}) {
    for (var cmd in sequence) {
      push(cmd);
    }
  }

  @action
  void clear() {
    moves.clear();
    current = -1;
  }

  @action
  void rewind({int repeat = 1}) {
    if (moves.isEmpty) {
      current = -1;
      return;
    }

    if (current >= moves.length) {
      current = moves.length - 1;
    }

    for (int i = 0; i < repeat; i++) {
      if (current >= 0) {
        _apply(moves[current].reverse());
      }
    }
  }

  @action
  forward({int repeat = 1}) {
    if (moves.isEmpty) {
      current = -1;
      return;
    }

    if (current < 0) current = 0;

    for (int i = 0; i < repeat; i++) {
      if (current < moves.length) {
        _apply(moves[current]);
      }
      current++;
    }

    if (current > moves.length) current = moves.length;
  }

  @computed
  String get debugCube => FaceCube.parse(state).to2dString();

  @action
  void reset() {
    _reset();
  }

  @action
  void apply(String pattern, {bool rewind = false}) {
    var moves = CubeCommand.parseAll(pattern);

    for (var move in rewind ? moves.reversed : moves) {
      _apply(rewind ? move.reverse() : move);
    }
  }

  @action
  void step(CubeCommand next) {
    _apply(next);
  }

  @action
  void scramble() {
    state = CubieCube.random().sequence;
  }

  @action
  void invert() {
    state = CubieCube.parse(state).inverse.sequence;
  }

  @action
  CubeCommand pop() {
    if (moves.isNotEmpty) {
      var last = moves.removeAt(0);
      return last;
    }
    return null;
  }

  void _reset() {
    state = resetState;
    axis = resetAxis;
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
      axis = _rotateXAxis[axis.index];
    }
  }

  void _rotateY(bool reversed, {bool doubled = false}) {
    var count = _moves(reversed, doubled);
    for (int i = 0; i < count; i++) {
      axis = _rotateYAxis[axis.index];
    }
  }

  void _rotateZ(bool reversed, {bool doubled = false}) {
    var count = _moves(reversed, doubled);
    for (int i = 0; i < count; i++) {
      axis = _rotateZAxis[axis.index];
    }
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
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.B, count);
      _rotateZ(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.F, count);
    }

    state = cube.sequence;
  }

  void _back(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.F, count);
      _rotateZ(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.B, count);
    }

    state = cube.sequence;
  }

  void _right(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.L, count);
      _rotateX(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.R, count);
    }

    state = cube.sequence;
  }

  void _left(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.R, count);
      _rotateX(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.L, count);
    }

    state = cube.sequence;
  }

  void _up(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.D, count);
      _rotateY(reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.U, count);
    }

    state = cube.sequence;
  }

  void _down(bool reversed, {bool wide = false, bool doubled = false}) {
    var count = _moves(reversed, doubled);
    var cube = CubieCube.parse(state);

    if (wide) {
      cube.apply(CubeColor.U, count);
      _rotateY(!reversed, doubled: doubled);
    } else {
      cube.apply(CubeColor.D, count);
    }

    state = cube.sequence;
  }

  void _middle(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(state);

    cube.apply(CubeColor.L, _moves(!reversed, doubled));
    cube.apply(CubeColor.R, _moves(reversed, doubled));
    _rotateX(!reversed, doubled: doubled);

    state = cube.sequence;
  }

  void _standing(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(state);

    cube.apply(CubeColor.F, _moves(!reversed, doubled));
    cube.apply(CubeColor.B, _moves(reversed, doubled));
    _rotateZ(reversed, doubled: doubled);

    state = cube.sequence;
  }

  void _equitorial(bool reversed, {bool doubled = false}) {
    var cube = CubieCube.parse(state);

    cube.apply(CubeColor.U, _moves(reversed, doubled));
    cube.apply(CubeColor.D, _moves(!reversed, doubled));
    _rotateY(!reversed, doubled: doubled);

    state = cube.sequence;
  }

  final _rotateXAxis = [
    CubeAxis.FR, // UR
    CubeAxis.FD, // UF
    CubeAxis.FL, // UL
    CubeAxis.FU, // UB

    CubeAxis.RF, // RU
    CubeAxis.RD, // RF
    CubeAxis.RB, // RD
    CubeAxis.RU, // RB

    CubeAxis.DF, // FU
    CubeAxis.DR, // FR
    CubeAxis.DB, // FD
    CubeAxis.DL, // FL

    CubeAxis.BR, // DR
    CubeAxis.BD, // DF
    CubeAxis.BL, // DL
    CubeAxis.BU, // DB

    CubeAxis.LF, // LU
    CubeAxis.LD, // LF
    CubeAxis.LB, // LD
    CubeAxis.LU, // LB

    CubeAxis.UF, // BU
    CubeAxis.UR, // BR
    CubeAxis.UB, // BD
    CubeAxis.UL, // BL
  ];

  final _rotateZAxis = [
    CubeAxis.LU, // UR
    CubeAxis.LF, // UF
    CubeAxis.LD, // UL
    CubeAxis.LB, // UB

    CubeAxis.UL, // RU
    CubeAxis.UF, // RF
    CubeAxis.UR, // RD
    CubeAxis.UB, // RB

    CubeAxis.FL, // FU
    CubeAxis.FU, // FR
    CubeAxis.FR, // FD
    CubeAxis.FD, // FL

    CubeAxis.RU, // DR
    CubeAxis.RF, // DF
    CubeAxis.RD, // DL
    CubeAxis.RB, // DB

    CubeAxis.DL, // LU
    CubeAxis.DF, // LF
    CubeAxis.DR, // LD
    CubeAxis.DB, // LB

    CubeAxis.BL, // BU
    CubeAxis.BU, // BR
    CubeAxis.BR, // BD
    CubeAxis.BD, // BL
  ];

  final _rotateYAxis = [
    CubeAxis.UB, // UR
    CubeAxis.UR, // UF
    CubeAxis.UF, // UL
    CubeAxis.UL, // UB

    CubeAxis.BU, // RU
    CubeAxis.BR, // RF
    CubeAxis.BD, // RD
    CubeAxis.BL, // RB

    CubeAxis.RU, // FU
    CubeAxis.RB, // FR
    CubeAxis.RD, // FD
    CubeAxis.RF, // FL

    CubeAxis.DB, // DR
    CubeAxis.DR, // DF
    CubeAxis.DF, // DL
    CubeAxis.DL, // DB

    CubeAxis.FU, // LU
    CubeAxis.FR, // LF
    CubeAxis.FD, // LD
    CubeAxis.FL, // LB

    CubeAxis.LU, // BU
    CubeAxis.LB, // BR
    CubeAxis.LD, // BD
    CubeAxis.LF, // BL
  ];
}
