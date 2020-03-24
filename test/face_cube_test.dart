import 'package:flutter_test/flutter_test.dart';
import 'package:rouxzen/cube/src/cubie.dart';
import 'package:rouxzen/cube/src/face.dart';

void main() {
  group('Face Cube', () {
    test('should start solved', () {
      final cube = FaceCube();
      print(cube.to2dString());
      expect(cube.toString(),
          "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB");
    });

    test('faces should convert to Cubies', () {
      var face = FaceCube();
      var cubies = face.toCubieCube();
      expect(cubies.toString(), CubieCube().toString());
    });
  });
}
