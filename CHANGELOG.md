# 2.0.0-nullsafety.2

  - Created the `RealMatrix` and `ComplexMatrix` types to work with matrix
  - Added support for linear systems solving using Gauss, LU decomposition and Cholesky decomposition
  - Added a new static method called `Algebraic.from()` which automatically builds a new polynomial
    equation according with the number of coefficients.
  - Minor documentation fixes

# 2.0.0-nullsafety.1

  - Added a new root-finding algorithm (`Brent` which implements the Brent's method method)
  - Added `Laguerre` (which implements Laguerre's method for polynomials root finding)
  - Minor on various `Nonlinear` subtypes
  - Documentation fixes

# 2.0.0-nullsafety.0

  - Package migrated to null safety (Dart 2.12).
  - Added a new `ExpressionParser` class (which is also internally used by `NonLinear`)
  - Minor fixes on `Algebraic` and `NonLinear`

# 1.0.1

  - Health suggestions fixes
  - Changed the description of the package

# 1.0.0

 - Initial release
 - Use `Algebraic` for algebraic (polynomial) equations and `Nonlinear` for nonlinear equations
 - Easily work with complex number by using `Complex`