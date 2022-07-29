import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:rouxzen/cube_style.dart';

import 'cube_command.dart';
import 'cube_state.dart';
import 'cube_model.dart';
import 'cube_painter.dart';

enum CubePanelView { text, flat, cube, face }

class CubePanel extends StatefulWidget {
  final CubeState cube;
  final CubeStyle style;
  final CubePanelView view;
  final bool isReadOnly;
  final Size size;

  CubePanel(
    this.cube,
    this.style,
    this.size, {
    this.view = CubePanelView.text,
    this.isReadOnly = false,
    Key key,
  }) : super(key: key);

  @override
  _CubePanelState createState() => _CubePanelState();
}

class _CubePanelState extends State<CubePanel>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  AnimationController moveController;
  Animation<double> moveAnimation;
  ReactionDisposer moveReactionDisposer;

  double angleX = -65.0;
  double angleY = 0.0;
  double angleZ = -45.0;
  double zoom = 1.0;
  int speed = 500;
  CubeModel model = CubeModel();

  @override
  void initState() {
    moveController = AnimationController(
        vsync: this, duration: Duration(milliseconds: speed));

    final curvedAnimation =
        CurvedAnimation(parent: moveController, curve: Curves.linear);

    moveAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          if (widget.cube.moves.isNotEmpty) {
            var move = widget.cube.moves.first;
            if (move.reset) {
              angleX = -65.0;
              angleY = 0.0;
              angleZ = -45.0;
            }
            model.applyMove(move.remap(widget.cube.axis), moveAnimation.value);
            model.update();
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          model.reset();
          model.update();
          widget.cube.step(widget.cube.moves.first);
          widget.cube.pop();
        }
      });

    moveReactionDisposer = reaction((_) => widget.cube.moves.length, (_) {
      if (widget.cube.moves.isNotEmpty &&
          moveController.status != AnimationStatus.forward) {
        curvedAnimation.curve =
            widget.cube.moves.length == 1 ? Curves.linear : Curves.linear;
        var doubled = widget.cube.moves.first.doubled;
        moveController.duration =
            Duration(milliseconds: doubled ? speed * 2 : speed);

        moveController.reset();
        moveController.forward();
      }
    });

    if (widget.cube.moves.isNotEmpty) moveController.forward();

    super.initState();
  }

  @override
  @override
  void dispose() {
    moveController.dispose();
    if (moveReactionDisposer != null) moveReactionDisposer();
    super.dispose();
  }

  void handleDragX(DragUpdateDetails update) {
    setState(() {
      var delta = update.delta.dx;
      if (angleX > 0 && angleX <= 180) delta *= -1;
      if (angleX < -180) delta *= -1;
      angleZ += delta;
      while (angleZ >= 360) angleZ -= 360;
      while (angleZ < -360) angleZ += 360;
    });
  }

  void handleDragY(DragUpdateDetails update) {
    setState(() {
      angleX += update.delta.dy;
      while (angleX >= 360) angleX -= 360;
      while (angleX < -360) angleX += 360;
    });
  }

  void handleKeyPress(RawKeyEvent evt) {
    if (evt is RawKeyDownEvent) {
      var key = evt.logicalKey.keyLabel?.toUpperCase() ?? "";
      if (key == "3" && evt.isShiftPressed) {
        key = "#";
      } else {
        if (evt.isShiftPressed) key += "'";
      }

      if (key == "-") {
        widget.cube.invert();
        return;
      }

      widget.cube.push(CubeCommand.parse(key));
    }
  }

  Iterable<Color> stickerColors() sync* {
    for (var face in widget.cube.stickers) {
      yield widget.style.colorOf(face);
    }
  }

  Widget createContentView(BuildContext context) {
    switch (widget.view) {
      case CubePanelView.text:
        return Text(widget.cube.debugCube,
            style: GoogleFonts.robotoMono(fontSize: 20));
        break;
      case CubePanelView.flat:
        return Text("Flat View");
        break;

      case CubePanelView.cube:
        int idx = 0;
        for (var color in stickerColors()) {
          if (idx < model.stickers.length) {
            model.stickers[idx++].color = color;
          }
        }

        var rotation = widget.cube.rotation;
        model.axisX = rotation[1].toDouble();
        model.axisY = rotation[2].toDouble();
        model.axisZ = rotation[0].toDouble();

        return Column(
          children: <Widget>[
            GestureDetector(
              child: CustomPaint(
                painter: CubePainter(widget.size, model, angleX, angleY, angleZ,
                    (widget.size.shortestSide / 5.25) * zoom),
                size: widget.size,
              ),
              onHorizontalDragUpdate: (DragUpdateDetails update) =>
                  handleDragX(update),
              onVerticalDragUpdate: (DragUpdateDetails update) =>
                  handleDragY(update),
            ),
          ],
        );
        break;

      case CubePanelView.face:
        return Text("Face View");
        break;
    }

    return Text("Unknown View Type");
  }

  @override
  Widget build(BuildContext context) {
    var inner = Container(
      child: Observer(builder: (_) => createContentView(context)),
    );

    if (widget.isReadOnly) return inner;

    FocusScope.of(context).requestFocus(_focusNode);

    return RawKeyboardListener(
        focusNode: _focusNode, onKey: handleKeyPress, child: inner);
  }
}
