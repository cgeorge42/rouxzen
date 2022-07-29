import 'package:flutter_test/flutter_test.dart';
import 'package:rouxzen/cube/cube.dart';
import 'package:rouxzen/cube/src/utils.dart';

void main() {
  group('Coord Cube', () {
    test("can create from a cubie cube", () {
      final scramble = 'DUUBULDBFRBFRRULLLBRDFFFBLURDBFDFDRFRULBLUFDURRBLBDUDL';
      final solved = CubieCube();
      final scrambled = CubieCube.parse(scramble);

      var phase1 = CoordCube(scrambled);
      var phase2 = CoordCube(solved);

      expect(phase1.toString(),
          "(twist: 1470, flip: 1306, slice: 474, U-edges: 6738, D-edges: 3033, E-edges: 11389, Corners: 15667, UD-edges: -1)");

      expect(phase2.toString(),
          "(twist: 0, flip: 0, slice: 0, U-edges: 1656, D-edges: 0, E-edges: 0, Corners: 0, UD-edges: 0)");
    });

    // test("can convert between coord and cubie", () {
    //   final scramble = 'DUUBULDBFRBFRRULLLBRDFFFBLURDBFDFDRFRULBLUFDURRBLBDUDL';
    //   final scrambled = CubieCube.parse(scramble);
    //   var coord = CoordCube(scrambled);
    //   var cube = CubieCube();

    //   cube.corners = coord.corners;
    //   cube..twist = coord.twist;

    //   cube.slice = coord.slice;
    //   cube.uEdges = coord.uEdges;
    //   cube.dEdges = coord.dEdges;
    //   cube..flip = coord.flip;

    //   expect(cube.sequence, scramble);
    // });
  });

  group('Cubie Cube', () {
    test('should start solved', () {
      final cube = CubieCube();
      print(cube);
    });

    test('should convert to Faces', () {
      var cube = CubieCube();
      var faces = cube.toFaceCube();
      expect(faces.toString(),
          "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB");
    });

    test('is comparable and hasbable', () {
      var cube1 = CubieCube();
      var cube2 = CubieCube();

      expect(cube1 == cube2, true);

      Map<CubieCube, int> m = {cube1: 0};
      expect(m.containsKey(cube2), true);

      m[cube2] = 1;
      expect(m[cube1], 1);
    });

    test('can be parsed from a string', () {
      var scramble = 'DUUBULDBFRBFRRULLLBRDFFFBLURDBFDFDRFRULBLUFDURRBLBDUDL';
      var cube = CubieCube.parse(scramble);
      expect(
          cube.toString(),
          "(DFR,2)(DBL,0)(DRB,0)(URF,0)(ULB,1)(UBR,1)(DLF,0)(UFL,2)\n" +
              "(BL,1)(BR,0)(UB,1)(UR,0)(FL,0)(DL,0)(DF,1)(DR,1)(FR,0)(UF,1)(DB,0)(UL,1)");

      var face = cube.toFaceCube();
      expect(face.toString(), scramble);

      expect(cube.verify(), "OK");
    });

    test('can apply moves', () {
      var cube = CubieCube()..apply(CubeColor.F, 1);

      expect(cube.sequence,
          "UUUUUULLLURRURRURRFFFFFFFFFRRRDDDDDDLLDLLDLLDBBBBBBBBB");
    });

    test('scrambled cube should be valid', () {
      var cube = CubieCube.random();
      var face = cube.toFaceCube();
      print(face.to2dString());
      print(cube);
      expect(cube.verify(), "OK");
    });
  });

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

  group('Utility', () {
    test('methods should work', () {
      var lsa = range(2, 5, 1);
      expect(lsa, [2, 3, 4]);

      var lsb = range(5, 2, -1);
      expect(lsb, [5, 4, 3]);

      var lsc = [0, 1, 2, 3, 4];
      rotateRight(lsc, 2, 4);
      expect(lsc, [0, 1, 4, 2, 3]);

      var lsd = [];
      for (int i = 1; i <= 12; i++) {
        lsd.add(coeffNchooseK(12, i));
      }
      expect(lsd, [12, 66, 220, 495, 792, 924, 792, 495, 220, 66, 12, 1]);

      var lse = [0, 1, 2, 3, 4];
      rotateLeft(lse, 1, 3);
      expect(lse, [0, 2, 3, 1, 4]);
      rotateRight(lse, 1, 3);
      expect(lse, [0, 1, 2, 3, 4]);
    });
  });
}
