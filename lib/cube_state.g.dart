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

  final _$stateAtom = Atom(name: '_CubeState.state');

  @override
  String get state {
    _$stateAtom.context.enforceReadPolicy(_$stateAtom);
    _$stateAtom.reportObserved();
    return super.state;
  }

  @override
  set state(String value) {
    _$stateAtom.context.conditionallyRunInAction(() {
      super.state = value;
      _$stateAtom.reportChanged();
    }, _$stateAtom, name: '${_$stateAtom.name}_set');
  }

  final _$resetStateAtom = Atom(name: '_CubeState.resetState');

  @override
  String get resetState {
    _$resetStateAtom.context.enforceReadPolicy(_$resetStateAtom);
    _$resetStateAtom.reportObserved();
    return super.resetState;
  }

  @override
  set resetState(String value) {
    _$resetStateAtom.context.conditionallyRunInAction(() {
      super.resetState = value;
      _$resetStateAtom.reportChanged();
    }, _$resetStateAtom, name: '${_$resetStateAtom.name}_set');
  }

  final _$resetAxisAtom = Atom(name: '_CubeState.resetAxis');

  @override
  CubeAxis get resetAxis {
    _$resetAxisAtom.context.enforceReadPolicy(_$resetAxisAtom);
    _$resetAxisAtom.reportObserved();
    return super.resetAxis;
  }

  @override
  set resetAxis(CubeAxis value) {
    _$resetAxisAtom.context.conditionallyRunInAction(() {
      super.resetAxis = value;
      _$resetAxisAtom.reportChanged();
    }, _$resetAxisAtom, name: '${_$resetAxisAtom.name}_set');
  }

  final _$currentAtom = Atom(name: '_CubeState.current');

  @override
  int get current {
    _$currentAtom.context.enforceReadPolicy(_$currentAtom);
    _$currentAtom.reportObserved();
    return super.current;
  }

  @override
  set current(int value) {
    _$currentAtom.context.conditionallyRunInAction(() {
      super.current = value;
      _$currentAtom.reportChanged();
    }, _$currentAtom, name: '${_$currentAtom.name}_set');
  }

  final _$_CubeStateActionController = ActionController(name: '_CubeState');

  @override
  void push(CubeCommand move) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.push(move);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pushAll(Iterable<CubeCommand> sequence, {bool reversed = false}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.pushAll(sequence, reversed: reversed);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void rewind({int repeat = 1}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.rewind(repeat: repeat);
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic forward({int repeat = 1}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.forward(repeat: repeat);
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
  void apply(String pattern, {bool rewind = false}) {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.apply(pattern, rewind: rewind);
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
  CubeCommand pop() {
    final _$actionInfo = _$_CubeStateActionController.startAction();
    try {
      return super.pop();
    } finally {
      _$_CubeStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'axis: ${axis.toString()},state: ${state.toString()},resetState: ${resetState.toString()},resetAxis: ${resetAxis.toString()},current: ${current.toString()},isSolved: ${isSolved.toString()},rotation: ${rotation.toString()},stickers: ${stickers.toString()},debugCube: ${debugCube.toString()}';
    return '{$string}';
  }
}
