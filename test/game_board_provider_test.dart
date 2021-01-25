// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tic_tac_toe/services/game_service.dart';

void main() {
  group("Terminal Function", () {
    test("Does our Terminal function work correctly", () {
      final subject = GameService();

      final result = subject.terminal([
        ["O", "X", "O"],
        [null, "X", null],
        [null, "X", null]
      ]);

      expect(result, true);
    });
    test("Does our Terminal function work correctly", () {
      final subject = GameService();

      final result = subject.terminal([
        [null, null, null],
        ["O", "X", "X"],
        [null, null, null]
      ]);

      expect(result, false);
    });
  });
}
