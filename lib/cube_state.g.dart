// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cube_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CubeState on _CubeState, Store {
  Computed<bool> _$isSolvedComputed;

  @override
  bool get isSolved =>
      (_$isSolvedComputed ??= Computed<bool>(() => super.isSolved)).value;
  Computed<List<int>> _$rotationComputed;

  @override
  List<int> get rotation =>
      (_$rotationComputed ??= Computed<List<int>>(() => super.rotation)).value;
  Computed<List<CubeColor>> _$stickersComputed;

  @override
  List<CubeColor> get stickers =>
      (_$stickersComputed ??= Computed<List<CubeColor>>(() => super.stickers))
          .value;
  Computed<String> _$debugCubeComputed;

  @override
  String get debugCube =>
      (_$debugCubeComputed ??= Computed<String>(() => super.debugCube)).value;

  final _$sequenceAtom = Atom(name: '_CubeState.sequence');

  @override
  String get sequence {
    _$sequenceAtom.context.enforceReadPolicy(_$sequenceAtom);
    _$sequenceAtom.reportObserved();
    return super.sequence;
  }

  @override
  set sequence(String value) {
    _$sequenceAtom.context.conditionallyRunInAction(() {
      super.sequence = value;
      _$sequenceAtom.reportChanged();
    }, _$sequenceAtom, name: '${_$sequenceAtom.name}_set');
  }

  final _$axisAtom = Atom(name: '_CubeState.axis');

  @override
  CubeAxis get axis {
    _$axisAtom.context.enforceReadPolicy(_$axisAtom);
    _$axisAtom.reportObserved();
    return super.axis;
  }

  @override
  set axis(CubeAxis value) {
    _$axisAtom.context.conditionallyRunInAction(() {
      super.axis = value;
      _$axisAtom.reportChanged();
    }, _$axisAtom, name: '${_$axisAtom.name}_set');
  }

  final _$_CubeStateActionController = ActionController(name: '_CubeState');

  @override
  CubeCommand pop() {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.pop();
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic push(CubeCommand move) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.push(move);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic pushAll(Iterable<CubeCommand> sequence, {bool reversed = false}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.pushAll(sequence, reversed: reversed);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.reset();
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void apply(String pattern, {bool reversed = false}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.apply(pattern, reversed: reversed);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void step(CubeCommand next) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.step(next);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'sequence: ${sequence.toString()},axis: ${axis.toString()},isSolved: ${isSolved.toString()},rotation: ${rotation.toString()},stickers: ${stickers.toString()},debugCube: ${debugCube.toString()}';
    return '{$string}';
  }
}
