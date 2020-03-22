// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Cube on _Cube, Store {
  Computed<CubeMove> _$currentComputed;

  @override
  CubeMove get current =>
      (_$currentComputed ??= Computed<CubeMove>(() => super.current)).value;
  Computed<bool> _$isSolvedComputed;

  @override
  bool get isSolved =>
      (_$isSolvedComputed ??= Computed<bool>(() => super.isSolved)).value;
  Computed<String> _$debugCubeComputed;

  @override
  String get debugCube =>
      (_$debugCubeComputed ??= Computed<String>(() => super.debugCube)).value;

  final _$_CubeActionController = ActionController(name: '_Cube');

  @override
  CubeMove pop() {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.pop();
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic push(CubeMove move) {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.push(move);
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic pushAll(Iterable<CubeMove> sequence, {bool reversed = false}) {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.pushAll(sequence, reversed: reversed);
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.reset();
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  void apply(String pattern, {bool reversed = false}) {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.apply(pattern, reversed: reversed);
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  void step(CubeMove next) {
    final _$actionInfo = _$_CubeActionController.startAction();
    try {
      return super.step(next);
    } finally {
      _$_CubeActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'current: ${current.toString()},isSolved: ${isSolved.toString()},debugCube: ${debugCube.toString()}';
    return '{$string}';
  }
}
