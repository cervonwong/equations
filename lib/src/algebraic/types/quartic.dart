import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] that represents a fourth degree
/// polynomial equation in the form _ax^4 + bx^3 + cx^2 + dx + e = 0_.
///
/// This equation has exactly 4 solutions:
///
///  - 2 distinct real roots and 2 complex conjugate roots
///  - 4 real roots and 0 complex roots
///  - 0 real roots and 4 complex conjugate roots
///  - Multiple roots which can be all equal or paired (complex or real)
///
/// The above cases depend on the value of the discriminant.
class Quartic extends Algebraic {
  /// The first coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex a;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex b;

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex c;

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex d;

  /// The fifth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex e;

  /// These are examples of quartic equations, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = -x^4 - 8x^3 - 1
  /// final eq = Quartic(
  ///   a: Complex.fromReal(-1),
  ///   b: Complex.fromReal(-8),
  ///   e: Complex.fromReal(-1),
  /// );
  ///
  /// // f(x) = ix^4 - ix^2 + 6
  /// final eq = Quartic(
  ///   a: Complex.fromImaginary(1),
  ///   c: Complex.fromImaginary(-1),
  ///   e: Complex.fromReal(6),
  /// );
  /// ```
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Quartic.realEquation()] for a
  /// less verbose syntax.
  Quartic({
    this.a = const Complex.fromReal(1),
    this.b = const Complex.zero(),
    this.c = const Complex.zero(),
    this.d = const Complex.zero(),
    this.e = const Complex.zero(),
  }) : super([a, b, c, d, e]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Quartic.realEquation({
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 0,
    double e = 0,
  })  : a = Complex.fromReal(a),
        b = Complex.fromReal(b),
        c = Complex.fromReal(c),
        d = Complex.fromReal(d),
        e = Complex.fromReal(e),
        super.realEquation([a, b, c, d, e]);

  @override
  int get degree => 4;

  @override
  Algebraic derivative() => Cubic(
      a: a * Complex.fromReal(4),
      b: b * Complex.fromReal(3),
      c: c * Complex.fromReal(2),
      d: d);

  @override
  Complex discriminant() {
    final k = (b * b * c * c * d * d) -
        (d * d * d * b * b * b * Complex.fromReal(4)) -
        (d * d * c * c * c * a * Complex.fromReal(4)) +
        (d * d * d * c * b * a * Complex.fromReal(18)) -
        (d * d * d * d * a * a * Complex.fromReal(27)) +
        (e * e * e * a * a * a * Complex.fromReal(256));

    final p = e *
        ((c * c * c * b * b * Complex.fromReal(-4)) +
            (b * b * b * c * d * Complex.fromReal(18)) +
            (c * c * c * c * a * Complex.fromReal(16)) -
            (d * c * c * b * a * Complex.fromReal(80)) -
            (d * d * b * b * a * Complex.fromReal(6)) +
            (d * d * a * a * c * Complex.fromReal(144)));

    final r = (e * e) *
        (b * b * b * b * Complex.fromReal(-27) +
            b * b * c * a * Complex.fromReal(144) -
            a * a * c * c * Complex.fromReal(128) -
            d * b * a * a * Complex.fromReal(192));

    return k + p + r;
  }

  @override
  List<Complex> solutions() {
    final fb = b / a;
    final fc = c / a;
    final fd = d / a;
    final fe = e / a;

    final q1 = (fc * fc) -
        (fb * fd * Complex.fromReal(3)) +
        (fe * Complex.fromReal(12));
    final q2 = (fc.pow(3) * Complex.fromReal(2)) -
        (fb * fc * fd * Complex.fromReal(9)) +
        (fd.pow(2) * Complex.fromReal(27)) +
        (fb.pow(2) * fe * Complex.fromReal(27)) -
        (fc * fe * Complex.fromReal(72));
    final q3 = (fb * fc * Complex.fromReal(8)) -
        (fd * Complex.fromReal(16)) -
        (fb.pow(3) * Complex.fromReal(2));
    final q4 = (fb.pow(2) * Complex.fromReal(3)) - (fc * Complex.fromReal(8));

    var temp = (q2 * q2 / Complex.fromReal(4)) - (q1.pow(3));
    final q5 = (temp.sqrt() + (q2 / Complex.fromReal(2))).pow(1.0 / 3.0);
    final q6 = ((q1 / q5) + q5) / Complex.fromReal(3);
    temp = (q4 / Complex.fromReal(12)) + q6;
    final q7 = temp.sqrt() * Complex.fromReal(2);
    temp = ((q4 * Complex.fromReal(4)) / Complex.fromReal(6)) -
        (q6 * Complex.fromReal(4)) -
        (q3 / q7);

    final solutions = [
      (fb.negate - q7 - temp.sqrt()) / Complex.fromReal(4),
      (fb.negate - q7 + temp.sqrt()) / Complex.fromReal(4),
    ];

    temp = ((q4 * Complex.fromReal(4)) / Complex.fromReal(6)) -
        (q6 * Complex.fromReal(4)) +
        (q3 / q7);

    solutions
      ..add((fb.negate + q7 - temp.sqrt()) / Complex.fromReal(4))
      ..add((fb.negate + q7 + temp.sqrt()) / Complex.fromReal(4));

    return solutions;
  }

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Quartic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
    Complex? d,
    Complex? e,
  }) =>
      Quartic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
        e: e ?? this.e,
      );
}
