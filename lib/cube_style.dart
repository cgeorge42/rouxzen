import 'package:flutter/material.dart';

import 'cube.dart';

class CubeStyle {
  final CubeColor front;
  final CubeColor back;
  final CubeColor up;
  final CubeColor down;
  final CubeColor left;
  final CubeColor right;

  CubeStyle._(this.front, this.back, this.left, this.right, this.up, this.down);

  Color asColor(CubeColor color) {
    switch (color) {
      case CubeColor.red:
        return Colors.red;
        break;
      case CubeColor.orange:
        return Colors.orange;
        break;
      case CubeColor.blue:
        return Colors.blue;
        break;
      case CubeColor.green:
        return Colors.green;
        break;
      case CubeColor.yellow:
        return Colors.yellow;
        break;
      case CubeColor.white:
        return Colors.white;
        break;
    }
    return Colors.black;
  }

  Color colorOf(CubeFace side) {
    switch (side) {
      case CubeFace.front:
        return asColor(front);
        break;
      case CubeFace.back:
        return asColor(back);
        break;
      case CubeFace.left:
        return asColor(left);
        break;
      case CubeFace.right:
        return asColor(right);
        break;
      case CubeFace.up:
        return asColor(up);
        break;
      case CubeFace.down:
        return asColor(down);
        break;
      case CubeFace.none:
        return Colors.grey;
        break;
    }
    return Colors.black;
  }

  static CubeColor opposite(CubeColor face) {
    switch (face) {
      case CubeColor.red:
        return CubeColor.orange;
      case CubeColor.orange:
        return CubeColor.red;
      case CubeColor.blue:
        return CubeColor.green;
      case CubeColor.green:
        return CubeColor.blue;
      case CubeColor.yellow:
        return CubeColor.white;
      case CubeColor.white:
        return CubeColor.yellow;
    }
    return face;
  }

  factory CubeStyle() {
    return CubeStyle._(CubeColor.red, CubeColor.orange, CubeColor.blue,
        CubeColor.green, CubeColor.yellow, CubeColor.white);
  }

  factory CubeStyle.frontUp(CubeColor front, CubeColor up) {
    CubeColor left;

    if (front == CubeColor.red || front == CubeColor.orange) {
      if (up == CubeColor.red) up = CubeColor.yellow;
      if (up == CubeColor.orange) up = CubeColor.yellow;

      if (up == CubeColor.yellow) left = CubeColor.blue;
      if (up == CubeColor.blue) left = CubeColor.white;
      if (up == CubeColor.white) left = CubeColor.green;
      if (up == CubeColor.green) left = CubeColor.yellow;

      if (front == CubeColor.orange) left = opposite(left);
    }

    if (front == CubeColor.blue || front == CubeColor.green) {
      if (up == CubeColor.blue) up = CubeColor.yellow;
      if (up == CubeColor.green) up = CubeColor.yellow;

      if (up == CubeColor.yellow) left = CubeColor.orange;
      if (up == CubeColor.orange) left = CubeColor.white;
      if (up == CubeColor.white) left = CubeColor.red;
      if (up == CubeColor.red) left = CubeColor.yellow;

      if (front == CubeColor.green) left = opposite(left);
    }

    if (front == CubeColor.yellow || front == CubeColor.white) {
      if (up == CubeColor.yellow) up = CubeColor.red;
      if (up == CubeColor.white) up = CubeColor.red;

      if (up == CubeColor.orange) left = CubeColor.blue;
      if (up == CubeColor.blue) left = CubeColor.red;
      if (up == CubeColor.red) left = CubeColor.green;
      if (up == CubeColor.green) left = CubeColor.orange;

      if (front == CubeColor.white) left = opposite(left);
    }

    return CubeStyle._(
        front, opposite(front), left, opposite(left), up, opposite(up));
  }
}
