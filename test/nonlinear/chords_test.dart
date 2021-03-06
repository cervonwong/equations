import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Chords' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () async {
      const chords =
          Chords(function: "cos(x+3)-log(x)+2", a: 0.1, b: 7, maxSteps: 5);

      expect(chords.maxSteps, equals(5));
      expect(chords.tolerance, equals(1.0e-10));
      expect(chords.function, equals("cos(x+3)-log(x)+2"));
      expect(chords.toString(), equals("f(x) = cos(x+3)-log(x)+2"));
      expect(chords.a, equals(0.1));
      expect(chords.b, equals(7));

      // Solving the equation, making sure that the series converged
      final solutions = await chords.solve();
      expect(solutions.guesses.length <= 5, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.last, MoreOrLessEquals(5, precision: 1));
      expect(solutions.convergence, MoreOrLessEquals(0.5, precision: 1.0));
      expect(solutions.efficiency, MoreOrLessEquals(0.8, precision: 1.0e-1));
    });

    test("Making sure that a malformed equation string throws.", () {
      expect(() async {
        await Chords(function: "2^ - 6y", a: 2, b: 0).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test("Making sure that object comparison properly works", () {
      final chords = Chords(
        function: "x^2-2",
        a: 1,
        b: 2,
      );

      expect(Chords(function: "x^2-2", a: 1, b: 2), equals(chords));
      expect(Chords(function: "x^2-2", a: 0, b: 2) == chords, isTrue);
      expect(Chords(function: "x^2-2", a: 0, b: 2).hashCode,
          equals(chords.hashCode));
    });

    test(
        "Making sure that the chords method still works when the root is "
        "not in the interval but the actual solution is not found", () async {
      const chords = Chords(function: "x^2-2", a: 10, b: 20, maxSteps: 3);
      final solutions = await chords.solve();

      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.length <= 3, isTrue);
    });
  });
}
