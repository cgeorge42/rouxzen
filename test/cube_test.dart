import 'package:flutter_test/flutter_test.dart';
import 'package:rouxzen/cube_state.dart';

void main() {
  group('Cube Face Turns', () {
    test('Cube should start solved', () {
      final cube = CubeState();
      print(cube.debugCube);
      expect(cube.isSolved, true);
    });
    test('Middle', () {
      final cube = CubeState();
      cube.apply("M");
      print(cube.debugCube);
    });

    test('Front', () {
      final cube = CubeState();
      cube.apply("F");
      print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("F2");
      var f3 = cube.debugCube;
      print(f3);
      expect(cube.isSolved, false);
      cube.apply("F");
      expect(cube.isSolved, true);

      cube.apply("F'");
      expect(cube.debugCube, f3);
      cube.apply("F");
      expect(cube.isSolved, true);

      cube.apply("f'");
      print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("f");
      expect(cube.isSolved, true);
    });

    test('Back', () {
      final cube = CubeState();
      cube.apply("B");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("B2");
      var b3 = cube.debugCube;
      //print(b3);
      expect(cube.isSolved, false);
      cube.apply("B");
      expect(cube.isSolved, true);

      cube.apply("B'");
      expect(cube.debugCube, b3);
      cube.apply("B");
      expect(cube.isSolved, true);

      cube.apply("b'");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("b");
      expect(cube.isSolved, true);
    });

    test('Left', () {
      final cube = CubeState();
      cube.apply("L");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("L2");
      var b3 = cube.debugCube;
      // print(b3);
      expect(cube.isSolved, false);
      cube.apply("L");
      expect(cube.isSolved, true);

      cube.apply("L'");
      expect(cube.debugCube, b3);
      cube.apply("L");
      expect(cube.isSolved, true);

      cube.apply("l'");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("l");
      expect(cube.isSolved, true);
    });
    test('Right', () {
      final cube = CubeState();
      cube.apply("R");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("R2");
      var b3 = cube.debugCube;
      //print(b3);
      expect(cube.isSolved, false);
      cube.apply("R");
      expect(cube.isSolved, true);

      cube.apply("R'");
      expect(cube.debugCube, b3);
      cube.apply("R");
      expect(cube.isSolved, true);

      cube.apply("r'");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("r");
      expect(cube.isSolved, true);
    });

    test('Up', () {
      final cube = CubeState();
      cube.apply("U");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("U2");
      var b3 = cube.debugCube;
      //print(b3);
      expect(cube.isSolved, false);
      cube.apply("U");
      expect(cube.isSolved, true);

      cube.apply("U'");
      expect(cube.debugCube, b3);
      cube.apply("U");
      expect(cube.isSolved, true);

      cube.apply("u'");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("u");
      expect(cube.isSolved, true);
    });

    test('Down', () {
      final cube = CubeState();
      cube.apply("D");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("D2");
      var b3 = cube.debugCube;
      //print(b3);
      expect(cube.isSolved, false);
      cube.apply("D");
      expect(cube.isSolved, true);

      cube.apply("D'");
      expect(cube.debugCube, b3);
      cube.apply("D");
      expect(cube.isSolved, true);

      cube.apply("d'");
      //print(cube.debugCube);
      expect(cube.isSolved, false);
      cube.apply("d");
      expect(cube.isSolved, true);
    });
  });
}
