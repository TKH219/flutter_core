import 'dart:math';

class MapUtil {

  /// The earth's radius, in meters.
  /// Mean radius as defined by IUGG.
  // ignore: non_constant_identifier_names
  static final double EARTH_RADIUS = 6371009;

  /// Computes inverse haversine. Has good numerical stability around 0.
  /// arcHav(x) == acos(1 - 2 * x) == 2 * asin(sqrt(x)).
  /// The argument must be in [0, 1], and the result is positive.
  static double arcHav(double x) {
    return 2 * asin(sqrt(x));
  }
}