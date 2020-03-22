import 'package:flutter/material.dart';
import 'package:rouxzen/cube.dart';
import 'package:vector_math/vector_math.dart' as Math;

import 'utils.dart';

class CubeRotation {
  double frontAngle = 0;
  double standingAngle = 0;
  double backAngle = 0;

  double leftAngle = 0;
  double middleAngle = 0;
  double rightAngle = 0;

  double upAngle = 0;
  double equatorialAngle = 0;
  double downAngle = 0;

  void reset() {
    frontAngle = 0;
    standingAngle = 0;
    backAngle = 0;

    leftAngle = 0;
    middleAngle = 0;
    rightAngle = 0;

    upAngle = 0;
    equatorialAngle = 0;
    downAngle = 0;
  }
}

class CubeModelFace {
  int v1 = 0;
  int v2 = 0;
  int v3 = 0;
  int v4 = 0;
  Color color = Colors.black;

  bool isFront = false;
  bool isStanding = false;
  bool isBack = false;

  bool isLeft = false;
  bool isMiddle = false;
  bool isRight = false;

  bool isUp = false;
  bool isEquatorial = false;
  bool isDown = false;

  CubeModelFace(int first) {
    v1 = first;
    v2 = first + 1;
    v3 = first + 2;
    v4 = first + 3;
  }

  Math.Matrix4 getFaceRotation(CubeRotation cube) {
    var result = Math.Matrix4.identity();

    if (isFront) _applyRotateY(cube.frontAngle, result);
    if (isStanding) _applyRotateY(cube.standingAngle, result);
    if (isBack) _applyRotateY(-cube.backAngle, result);

    if (isUp) _applyRotateZ(-cube.upAngle, result);
    if (isEquatorial) _applyRotateZ(cube.equatorialAngle, result);
    if (isDown) _applyRotateZ(cube.downAngle, result);

    if (isRight) _applyRotateX(-cube.rightAngle, result);
    if (isMiddle) _applyRotateX(cube.middleAngle, result);
    if (isLeft) _applyRotateX(cube.leftAngle, result);

    return result;
  }

  void _applyRotateY(double angle, Math.Matrix4 m) {
    if (angle != 0) m.rotateY(Utils.degreeToRadian(angle));
  }

  void _applyRotateX(double angle, Math.Matrix4 m) {
    if (angle != 0) m.rotateX(Utils.degreeToRadian(angle));
  }

  void _applyRotateZ(double angle, Math.Matrix4 m) {
    if (angle != 0) m.rotateZ(Utils.degreeToRadian(angle));
  }
}

class CubeModel {
  final CubeRotation rotation = CubeRotation();

  List<Math.Vector3> verts = [];
  List<CubeModelFace> stickers = [];
  List<CubeModelFace> cubies = [];

  List<bool> leftStickers;
  List<bool> middleStickers;
  List<bool> rightStickers;
  List<bool> upStickers;
  List<bool> equatorialStickers;
  List<bool> downStickers;
  List<bool> frontStickers;
  List<bool> standingStickers;
  List<bool> backStickers;

  void reset() {
    rotation.reset();
  }

  void applyMove(CubeMove move, double progress) {
    rotation.reset();
    if (move.reset) return;

    var angle = (move.doubled ? 180.0 : 90.0) * progress;
    if (move.reversed) angle *= -1.0;

    // Apply whole cube rotations
    // x - Rotate on R
    // y - Rotate on U
    // z - Rotate on F
    if (move.rotate) {
      if (move.face == CubeFace.front || move.face == CubeFace.back) {
        if (move.face == CubeFace.back) angle *= -1;
        rotation.frontAngle = angle;
        rotation.standingAngle = angle;
        rotation.backAngle = -angle;
      }

      if (move.face == CubeFace.left || move.face == CubeFace.right) {
        if (move.face == CubeFace.left) angle *= -1;
        rotation.leftAngle = -angle;
        rotation.middleAngle = -angle;
        rotation.rightAngle = angle;
      }

      if (move.face == CubeFace.up || move.face == CubeFace.down) {
        if (move.face == CubeFace.down) angle *= -1;
        rotation.downAngle = -angle;
        rotation.equatorialAngle = -angle;
        rotation.upAngle = angle;
      }
      return;
    }

    // Apply slice only rotations
    // M - Middle same direction as L
    // E - Equatorial same direction as D
    // S - Standing same direction as F
    if (move.slice) {
      if (move.face == CubeFace.front || move.face == CubeFace.back) {
        if (move.face == CubeFace.back) angle *= -1;
        rotation.standingAngle = angle;
      }

      if (move.face == CubeFace.left || move.face == CubeFace.right) {
        if (move.face == CubeFace.right) angle *= -1;
        rotation.middleAngle = angle;
      }

      if (move.face == CubeFace.up || move.face == CubeFace.down) {
        if (move.face == CubeFace.up) angle *= -1;
        rotation.equatorialAngle = angle;
      }

      return;
    }

    switch (move.face) {
      case CubeFace.front:
        rotation.frontAngle = angle;
        if (move.wide) rotation.standingAngle = angle;
        break;
      case CubeFace.back:
        rotation.backAngle = angle;
        if (move.wide) rotation.standingAngle = -angle;
        break;
      case CubeFace.left:
        rotation.leftAngle = angle;
        if (move.wide) rotation.middleAngle = angle;
        break;
      case CubeFace.right:
        rotation.rightAngle = angle;
        if (move.wide) rotation.middleAngle = -angle;
        break;
      case CubeFace.up:
        rotation.upAngle = angle;
        if (move.wide) rotation.equatorialAngle = -angle;
        break;
      case CubeFace.down:
        rotation.downAngle = angle;
        if (move.wide) rotation.equatorialAngle = angle;
        break;
      case CubeFace.none:
        break;
    }
  }

  void _addCubieFace(double x, double y, double z, CubeFace face) {
    var cmf = CubeModelFace(verts.length)
      ..isLeft = x < 0
      ..isMiddle = x == 0
      ..isRight = x > 0
      ..isUp = z > 0
      ..isEquatorial = z == 0
      ..isDown = z < 0
      ..isFront = y < 0
      ..isStanding = y == 0
      ..isBack = y > 0;
    //cmf.color = CubeStyle().colorOf(face);
    cubies.add(cmf);

    Math.Vector3 axisX;
    Math.Vector3 axisY;
    Math.Vector3 center;

    switch (face) {
      case CubeFace.front:
        center = Math.Vector3(x, y - .5, z);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.back:
        center = Math.Vector3(x, y + .5, z);
        axisX = Math.Vector3(-.5, 0, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.left:
        center = Math.Vector3(x - .5, y, z);
        axisX = Math.Vector3(0, -.5, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.right:
        center = Math.Vector3(x + .5, y, z);
        axisX = Math.Vector3(0, .5, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.up:
        center = Math.Vector3(x, y, z + .5);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, .5, 0);
        break;
      case CubeFace.down:
        center = Math.Vector3(x, y, z - .5);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, -.5, 0);
        break;
      case CubeFace.none:
        break;
    }

    var v1 = center - axisX + axisY;
    var v2 = center + axisX + axisY;
    var v3 = center + axisX - axisY;
    var v4 = center - axisX - axisY;

    var m = cmf.getFaceRotation(rotation);

    verts.add(m.transform3(v1));
    verts.add(m.transform3(v2));
    verts.add(m.transform3(v3));
    verts.add(m.transform3(v4));

    cubies.add(cmf);
  }

  void _addCubie(double x, double y, double z) {
    for (var side in AllSides) {
      _addCubieFace(x, y, z, side);
    }
  }

  //   U      00 01 02
  // L F R B  03 04 05
  //   D      06 07 08
  // 09 10 11 18 19 20 27 28 29 36 37 38
  // 12 13 14 21 22 23 30 31 32 39 40 41
  // 15 16 17 24 25 26 33 34 35 42 43 44
  //          45 46 47
  //          48 49 50
  //          51 52 53

  void _addSticker(double x, double y, CubeFace face, int index) {
    Math.Vector3 axisX;
    Math.Vector3 axisY;
    Math.Vector3 center;

    switch (face) {
      case CubeFace.front:
        center = Math.Vector3(x, -1.5, y);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.back:
        center = Math.Vector3(-x, 1.5, y);
        axisX = Math.Vector3(-.5, 0, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.left:
        center = Math.Vector3(-1.5, -x, y);
        axisX = Math.Vector3(0, -.5, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.right:
        center = Math.Vector3(1.5, x, y);
        axisX = Math.Vector3(0, .5, 0);
        axisY = Math.Vector3(0, 0, .5);
        break;
      case CubeFace.up:
        center = Math.Vector3(x, y, 1.5);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, .5, 0);
        break;
      case CubeFace.down:
        center = Math.Vector3(x, -y, -1.5);
        axisX = Math.Vector3(.5, 0, 0);
        axisY = Math.Vector3(0, -.5, 0);
        break;
      case CubeFace.none:
        break;
    }
    axisX *= .95;
    axisY *= .95;

    var v1 = center - axisX + axisY;
    var v2 = center + axisX + axisY;
    var v3 = center + axisX - axisY;
    var v4 = center - axisX - axisY;

    var cmf = CubeModelFace(verts.length)
      ..isLeft = leftStickers[index]
      ..isMiddle = middleStickers[index]
      ..isRight = rightStickers[index]
      ..isUp = upStickers[index]
      ..isEquatorial = equatorialStickers[index]
      ..isDown = downStickers[index]
      ..isFront = frontStickers[index]
      ..isStanding = standingStickers[index]
      ..isBack = backStickers[index];

    var m = cmf.getFaceRotation(rotation);

    verts.add(m.transform3(v1));
    verts.add(m.transform3(v2));
    verts.add(m.transform3(v3));
    verts.add(m.transform3(v4));

    stickers.add(cmf);
  }

  Iterable<bool> _expand(List<int> indexes) sync* {
    for (int i = 0; i < 54; i++) {
      yield indexes.contains(i);
    }
  }

  void update() {
    verts.clear();
    stickers.clear();
    cubies.clear();

    int index = 0;
    for (var face in AllSides) {
      for (var y = 1; y >= -1; y -= 1) {
        for (var x = -1; x <= 1; x += 1) {
          _addSticker(x.toDouble(), y.toDouble(), face, index);
          index += 1;
        }
      }
    }

    for (var z = -1; z <= 1; z++)
      for (var y = -1; y <= 1; y++)
        for (var x = -1; x <= 1; x++) {
          if (x == 0 && y == 0 && z == 0) continue;

          _addCubie(x.toDouble(), y.toDouble(), z.toDouble());
        }
  }

  //   U      00 01 02
  // L F R B  03 04 05
  //   D      06 07 08
  // 09 10 11 18 19 20 27 28 29 36 37 38
  // 12 13 14 21 22 23 30 31 32 39 40 41
  // 15 16 17 24 25 26 33 34 35 42 43 44
  //          45 46 47
  //          48 49 50
  //          51 52 53

  CubeModel() {
    leftStickers = _expand([
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      0,
      3,
      6,
      18,
      21,
      24,
      45,
      48,
      51,
      38,
      41,
      44
    ]).toList();
    middleStickers =
        _expand([1, 4, 7, 19, 22, 25, 46, 49, 52, 37, 40, 43]).toList();
    rightStickers = _expand([
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      20,
      23,
      26,
      2,
      5,
      8,
      36,
      39,
      42,
      47,
      50,
      53
    ]).toList();
    frontStickers = _expand([
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      6,
      7,
      8,
      27,
      30,
      33,
      47,
      46,
      45,
      17,
      14,
      11
    ]).toList();
    standingStickers =
        _expand([3, 4, 5, 28, 31, 34, 48, 49, 50, 10, 13, 16]).toList();
    backStickers = _expand([
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      29,
      32,
      35,
      0,
      1,
      2,
      51,
      52,
      53,
      9,
      12,
      15
    ]).toList();

    downStickers = _expand([
      45,
      46,
      47,
      48,
      49,
      50,
      51,
      52,
      53,
      15,
      16,
      17,
      24,
      25,
      26,
      33,
      34,
      35,
      42,
      43,
      44
    ]).toList();
    equatorialStickers =
        _expand([12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, 41]).toList();
    upStickers = _expand([
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      18,
      19,
      20,
      27,
      28,
      29,
      36,
      37,
      38
    ]).toList();

    update();
  }
}
