// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RouxApp on _RouxApp, Store {
  final _$currentStepAtom = Atom(name: '_RouxApp.currentStep');

  @override
  StepType get currentStep {
    _$currentStepAtom.context.enforceReadPolicy(_$currentStepAtom);
    _$currentStepAtom.reportObserved();
    return super.currentStep;
  }

  @override
  set currentStep(StepType value) {
    _$currentStepAtom.context.conditionallyRunInAction(() {
      super.currentStep = value;
      _$currentStepAtom.reportChanged();
    }, _$currentStepAtom, name: '${_$currentStepAtom.name}_set');
  }

  final _$cubeStyleAtom = Atom(name: '_RouxApp.cubeStyle');

  @override
  CubeStyle get cubeStyle {
    _$cubeStyleAtom.context.enforceReadPolicy(_$cubeStyleAtom);
    _$cubeStyleAtom.reportObserved();
    return super.cubeStyle;
  }

  @override
  set cubeStyle(CubeStyle value) {
    _$cubeStyleAtom.context.conditionallyRunInAction(() {
      super.cubeStyle = value;
      _$cubeStyleAtom.reportChanged();
    }, _$cubeStyleAtom, name: '${_$cubeStyleAtom.name}_set');
  }

  @override
  String toString() {
    final string =
        'currentStep: ${currentStep.toString()},cubeStyle: ${cubeStyle.toString()}';
    return '{$string}';
  }
}
