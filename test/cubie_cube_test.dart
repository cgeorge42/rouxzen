import 'package:flutter_test/flutter_test.dart';
import 'package:rouxzen/cube/src/cubie.dart';
import 'package:rouxzen/cube/src/enums.dart' show CubeColor;

void main() {
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
  });
}
