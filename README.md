<p align="center">
<img src="https://raw.githubusercontent.com/albertodev01/equations/6f15adbc96445c88ca02c7b85f4ae2b51f88e949/assets/equations_logo.svg" height="92" alt="dart_equations logo" />
</p>
<p align="center">An equation solving library written purely in Dart</p>
<p align="center">
    <a href="https://codecov.io/gh/albertodev01/equations"><img src="https://codecov.io/gh/albertodev01/equations/branch/master/graph/badge.svg?token=OQFZFHPD3S"/></a>
    <a href="https://github.com/albertodev01/equations/actions"><img src="https://github.com/albertodev01/equations/workflows/equations_ci/badge.svg" alt="CI status" /></a>
    <a href="https://github.com/albertodev01/equations/stargazers"><img src="https://img.shields.io/github/stars/albertodev01/equations.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Stars count on GitHub" /></a>
  <a href="https://pub.dev/packages/equations"><img src="https://img.shields.io/pub/v/equations.svg?style=flat&logo=github&colorB=blue" alt="Stars count on GitHub" /></a>
</p>

---

Thanks to `equations` you're able to solve polynomial and nonlinear equations with ease. It's been written in "pure" Dart, meaning that it has no  
dependency on any framework. It can be used with Flutter for web, desktop and mobile. Here's a summary of the contents of the package:

  - `Algebraic` and all of its subtypes, which can be used to solve algebraic equations (also known as polynomial equations);
  - `Nonlinear` and all of its subtypes, which can be used to solve nonlinear equations;
  - `Complex`, which is used to easily handle complex numbers;
  - `Fraction`, from the [fraction](https://pub.dev/packages/fraction) package which helps you working with fractions.

This package is meant to be used with Dart 2.12 or higher because the code is entirely null safe!

# Algebraic equations

Use one of the following classes to find the roots of a polynomial. You can use both complex numbers and fractions as coefficients.

| Solver name |                                  Equation                                 |    Params field   |
|:-----------:|:-------------------------------------------------------------------------:|:-----------------:|
| `Constant`  | <em>f(x) = a</em>                                                         | a ∈ C             |
| `Linear`    | <em>f(x) = ax + b</em>                                                    | a, b ∈ C          |
| `Quadratic` | <em>f(x) = ax<sup>2</sup> + bx + c</em>                                   | a, b, c ∈ C       |
| `Cubic`     | <em>f(x) = ax<sup>3</sup> + bx<sup>2</sup> + cx + d</em>                  | a, b, c, d ∈ C    |
| `Quartic`   | <em>f(x) = ax<sup>4</sup> + bx<sup>3</sup> + cx<sup>2</sup> + dx + e</em> | a, b, c, d, e ∈ C |
| `Laguerre`  | Any polynomial P(x<sub>i</sub>) where x<sub>i</sub> are coefficients      | x<sub>i</sub> ∈ C |

There's a formula for polynomials up to the fourth degree, as explained by [Galois Theory](https://en.wikipedia.org/wiki/Galois_theory). Roots of
polynomials whose degree is 5 or higher, must be seeked using Laguerre's method or any other root-finding algorithm. For this reason, we suggest
to go for the following approach:

  - Use `Linear` to find the roots of a polynomial whose degree is 1.
  - Use `Quadratic` to find the roots of a polynomial whose degree is 2.
  - Use `Cubic` to find the roots of a polynomial whose degree is 3.
  - Use `Quartic` to find the roots of a polynomial whose degree is 4.
  - Use `Laguerre` to find the roots of a polynomial whose degree is 5 or higher.

Note that `Laguerre` can be used with any polynomials, so you could use it (for example) to solve a cubic equation as well. `Laguerre` internally
uses loops, derivatives and other mechanics that are much slower than `Quartic`, `Cubic`, `Quadratic` and `Linear` so use it only onle when really
needed. Here's how you can solve a cubic:

```dart
// f(x) = (2-3i)x^3 + 6/5ix^2 - (-5+i)x - (9+6i)
final equation = Cubic(
  a: Complex(2, -3),
  b: Complex.fromImaginaryFraction(Fraction(6, 5)),
  c: Complex(5, -1),
  d: Complex(-9, -6)
);

final degree = equation.degree; // 3
final isReal = equation.isRealEquation; // false
final discr = equation.discriminant(); // -31299.688 + 27460.192i

// f(x) = (2 - 3i)x^3 + 1.2ix^2 + (5 - 1i)x + (-9 - 6i)
print("$equation");
// f(x) = (2 - 3i)x^3 + 6/5ix^2 + (5 - 1i)x + (-9 - 6i)
print(equation.toStringWithFractions());

/*
 * Prints the roots of the equation:
 *
 *  x1 = 0.348906207844 - 1.734303423032i
 *  x2 = -1.083892638909 + 0.961044482775
 *  x3 = 1.011909507988 + 0.588643555642
 * */
for (final root in equation.solutions()) {
  print(root);
}
```

Alternatively, you could have used `Laguerre` to solve the same equation:

```dart
// f(x) = (2-3i)x^3 + 6/5ix^2 - (-5+i)x - (9+6i)
final equation = Laguerre(
  coefficients: [
    Complex(2, -3),
    Complex.fromImaginaryFraction(Fraction(6, 5)),
    Complex(5, -1),
    Complex(-9, -6),
  ]
);

/*
 * Prints the roots of the equation:
 *
 *  x1 = 1.0119095 + 0.5886435
 *  x2 = 0.3489062 - 1.7343034i
 *  x3 = -1.0838926 + 0.9610444
 * */ 
for (final root in equation.solutions()) {
  print(root);
}
```

# Nonlinear equations

Use one of the following classes, representing a root-finding algorithm, to find a root of an equation. Only real numbers are allowed. This package  
supports the following root finding methods:

| Solver name  | Params field      |
|:------------:|:-----------------:|
| `Bisection`  | a, b ∈ R          |
| `Chords`     | a, b ∈ R          |
| `Netwon`     | x<sub>0</sub> ∈ R |
| `Secant`     | a, b ∈ R          |
| `Steffensen` | x<sub>0</sub> ∈ R |
| `Brent`      | a, b ∈ R          |

Expressions are parsed using [petitparser](https://pub.dev/packages/petitparser/), a fasts, stable and well tested grammar parser. These algorithms only  
work with real numbers. Here's a simple example of how you can find the roots of an equation:

```dart
final newton = Newton("2*x+cos(x)", -1, maxSteps: 5);

final steps = newton.maxSteps; // 5
final tol = newton.tolerance; // 1.0e-10
final fx = newton.function; // 2*x+cos(x)
final guess = newton.x0; // -1

final solutions = await newton.solve();

final convergence = solutions.convergence.round(); // 2
final solutions = solutions.efficiency.round(); // 1

/*
 * The getter `solutions.guesses` returns the list of values computed by the algorithm
 *
 * -0.4862880170389824
 * -0.45041860473199363
 * -0.45018362150211116
 * -0.4501836112948736
 * -0.45018361129487355
 */
final List<double> guesses = solutions.guesses;
```

Note that certain algorithms don't guarantee the convergence to a root so read the documentation carefully before choosing the method.
