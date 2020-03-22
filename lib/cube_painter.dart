import 'package:flutter/material.dart';
import 'package:rouxzen/cube_model.dart';
import 'package:vector_math/vector_math.dart' as Math;

import 'utils.dart';

class CubePainter extends CustomPainter {
  final CubeModel model;
  final double angleX;
  final double angleY;
  final double angleZ;
  final double zoom;
  final Size size;

  double _viewPortX = 0.0;
  double _viewPortY = 0.0;

  Math.Vector3 camera;
  Math.Vector3 light;

  List<Math.Vector3> verts = [];
  final edgePen = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  final sideFill = Paint()..color = Colors.black;

  CubePainter(
      this.size, this.model, this.angleX, this.angleY, this.angleZ, this.zoom) {
    camera = Math.Vector3(0.0, 0.0, 0.0);
    light = Math.Vector3(0.0, 0.0, 100.0);
    _viewPortX = (size.width / 2).toDouble();
    _viewPortY = (size.height / 2).toDouble();
  }

  void _drawFace(Canvas canvas, CubeModelFace face, bool outline) {
    // Reference the rotated vertices
    var v1 = verts[face.v1];
    var v2 = verts[face.v2];
    var v3 = verts[face.v3];
    var v4 = verts[face.v4];

    // Calculate the surface normal
    var normalVector = Utils.normalVector3(v1, v2, v3);

    // Calculate the lighting
    Math.Vector3 normalizedLight = Math.Vector3.copy(light).normalized();
    var jnv = Math.Vector3.copy(normalVector).normalized();
    var normal = Utils.scalarMultiplication(jnv, normalizedLight);
    var brightness = normal.clamp(0.0, 1.0);
    if (brightness != 0) return;

    // Set the face color or use black for backside of face
    var paint = Paint();
    paint.color = face.color;
    paint.style = PaintingStyle.fill;

    // Paint the face
    var path = Path();
    path.moveTo(v1.x, v1.y);
    path.lineTo(v2.x, v2.y);
    path.lineTo(v3.x, v3.y);
    path.lineTo(v4.x, v4.y);
    path.close();

    canvas.drawPath(path, paint);
    if (outline) {
      canvas.drawPath(path, edgePen);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), edgePen);

    // Transform

    var m = Math.Matrix4.translationValues(_viewPortX, _viewPortY, 1);
    m.scale(zoom, -zoom);
    m.rotateX(Utils.degreeToRadian(angleX));
    m.rotateY(Utils.degreeToRadian(angleY));
    m.rotateZ(Utils.degreeToRadian(angleZ));

    verts = List<Math.Vector3>();
    for (var v in model.verts) {
      verts.add(m.transform3(Math.Vector3.copy(v)));
    }

    // Sort

    var sorted = List<Map<String, dynamic>>();

    for (var face in model.cubies) {
      sorted.add({
        "order": Utils.zIndex4(
            verts[face.v1], verts[face.v2], verts[face.v3], verts[face.v4]),
        "face": face,
      });
    }

    sorted.sort((Map a, Map b) => a["order"].compareTo(b["order"]));
    for (var item in sorted) {
      var face = item["face"];
      _drawFace(canvas, face, false);
    }

    sorted.clear();
    for (var face in model.stickers) {
      sorted.add({
        "order": Utils.zIndex4(
            verts[face.v1], verts[face.v2], verts[face.v3], verts[face.v4]),
        "face": face,
      });
    }

    sorted.sort((Map a, Map b) => a["order"].compareTo(b["order"]));

    // Render

    for (var item in sorted) {
      var face = item["face"];
      _drawFace(canvas, face, true);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
