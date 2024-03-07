// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_player.dart';
import 'package:stick_control/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    TestWidgetsFlutterBinding.ensureInitialized();
    print("start");
    // var lib = ExerciseLibrary();
    // await lib.load();
    // var ex = lib.exercises[0];
    var ex = Exercise(await rootBundle.loadString("assets/ex/test.json"));
    print(ex.name);
    await ExercisePlayer(ex).play();
    //do {} while (true);
  });
}
