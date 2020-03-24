import 'package:mobx/mobx.dart';
import 'package:rouxzen/cube_style.dart';

import 'cube_state.dart';
part 'app.g.dart';

class RouxApp = _RouxApp with _$RouxApp;

enum StepType { FirstBlock, SecondBlock, CMLL, LSE }

abstract class _RouxApp with Store {
  @observable
  StepType currentStep = StepType.CMLL;

  @observable
  CubeStyle cubeStyle = CubeStyle();

  final CubeState cube = CubeState();
}
