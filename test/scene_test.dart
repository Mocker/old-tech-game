import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

void main() {
  test('flutter_scene types check', () {
    final camera = PerspectiveCamera(
      position: vm.Vector3(0, 2, 5),
      target: vm.Vector3(0, 0, 0),
    );
    expect(camera.position.z, 5);
  });
}
