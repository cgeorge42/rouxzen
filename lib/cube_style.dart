import 'package:flutter/material.dart';
import 'cube/cube.dart';

class CubeStyle {
  final Color front;
  final Color back;
  final Color up;
  final Color down;
  final Color left;
  final Color right;

  CubeStyle._(this.front, this.back, this.left, this.right, this.up, this.down);

  Color colorOf(CubeColor side) {
    switch (side) {
      case CubeColor.F:
        return front;
        break;
      case CubeColor.B:
        return back;
        break;
      case CubeColor.L:
        return left;
        break;
      case CubeColor.R:
        return right;
        break;
      case CubeColor.U:
        return up;
        break;
      case CubeColor.D:
        return down;
        break;
      case CubeColor.none:
        return Colors.grey;
        break;
    }
    return Colors.black;
  }

  static Color opposite(Color face) {
    if (face == Colors.red) return Colors.orange;
    if (face == Colors.orange) return Colors.red;
    if (face == Colors.blue) return Colors.green;
    if (face == Colors.green) return Colors.blue;
    if (face == Colors.white) return Colors.yellow;
    if (face == Colors.yellow) return Colors.white;

    return Colors.black;
  }

  factory CubeStyle() {
    return CubeStyle._(Colors.red, Colors.orange, Colors.blue, Colors.green,
        Colors.yellow, Colors.white);
  }

  factory CubeStyle.frontUp(Color front, Color up) {
    Color left;

    if (front == Colors.red || front == Colors.orange) {
      if (up == Colors.red) up = Colors.yellow;
      if (up == Colors.orange) up = Colors.yellow;

      if (up == Colors.yellow) left = Colors.blue;
      if (up == Colors.blue) left = Colors.white;
      if (up == Colors.white) left = Colors.green;
      if (up == Colors.green) left = Colors.yellow;

      if (front == Colors.orange) left = opposite(left);
    }

    if (front == Colors.blue || front == Colors.green) {
      if (up == Colors.blue) up = Colors.yellow;
      if (up == Colors.green) up = Colors.yellow;

      if (up == Colors.yellow) left = Colors.orange;
      if (up == Colors.orange) left = Colors.white;
      if (up == Colors.white) left = Colors.red;
      if (up == Colors.red) left = Colors.yellow;

      if (front == Colors.green) left = opposite(left);
    }

    if (front == Colors.yellow || front == Colors.white) {
      if (up == Colors.yellow) up = Colors.red;
      if (up == Colors.white) up = Colors.red;

      if (up == Colors.orange) left = Colors.blue;
      if (up == Colors.blue) left = Colors.red;
      if (up == Colors.red) left = Colors.green;
      if (up == Colors.green) left = Colors.orange;

      if (front == Colors.white) left = opposite(left);
    }

    return CubeStyle._(
        front, opposite(front), left, opposite(left), up, opposite(up));
  }
}
