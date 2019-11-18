
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapUtil.dart';

class SphericalUtil {

  static double toRadians(double degrees) => degrees * (pi/180);

  static double toDegrees(double radians) => (radians*180)/pi;

  static LatLng computeOffset(LatLng from, double distance, double heading) {
    distance /= 6371009.0;
    heading = toRadians(heading);
    double fromLat = toRadians(from.latitude);
    double fromLng = toRadians(from.longitude);
    double cosDistance = cos(distance);
    double sinDistance = sin(distance);
    double sinFromLat = sin(fromLat);
    double cosFromLat = cos(fromLat);
    double sinLat = cosDistance * sinFromLat + sinDistance * cosFromLat * cos(heading);
    double dLng = atan2(sinDistance * cosFromLat * sin(heading), cosDistance - sinFromLat * sinLat);
    return new LatLng(toDegrees(asin(sinLat)), toDegrees(fromLng + dLng));
  }

  static double computeHeading(LatLng from, LatLng to) {
    double fromLat = toRadians(from.latitude);
    double fromLng = toRadians(from.longitude);
    double toLat = toRadians(to.latitude);
    double toLng = toRadians(to.longitude);
    double dLng = toLng - fromLng;
    double heading = atan2(sin(dLng) * cos(toLat), cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng));
    return wrap(toDegrees(heading), -180.0, 180.0);
  }
  static double wrap(double n, double min, double max) {
    return n >= min && n < max ? n : mod(n - min, max - min) + min;
  }

  static double mod(double x, double m) {
    return (x % m + m) % m;
  }

  static LatLng getCenterOfLatLngBounds(LatLngBounds bounds) {
    double var1 = (bounds.southwest.latitude + bounds.northeast.latitude) / 2.0;
    double var3 = bounds.northeast.longitude;
    double var5;
    double var7;
    if ((var5 = bounds.southwest.longitude) <= var3) {
      var7 = (var3 + var5) / 2.0;
    } else {
      var7 = (var3 + 360.0 + var5) / 2.0;
    }

    return new LatLng(var1, var7);
  }

  /// Returns the distance between two LatLngs, in meters.
  static double computeDistanceBetween(LatLng from, LatLng to) {
    return computeAngleBetween(from, to) * MapUtil.EARTH_RADIUS;
  }

  /// Returns the angle between two LatLngs, in radians. This is the same as the distance
  ///  on the unit sphere.
  static double computeAngleBetween(LatLng from, LatLng to) {
    return distanceRadians(toRadians(from.latitude), toRadians(from.longitude),
        toRadians(to.latitude), toRadians(to.longitude));
  }

  /// Returns distance on the unit sphere; the arguments are in radians.
  static double distanceRadians(double lat1, double lng1, double lat2, double lng2) {
    return MapUtil.arcHav(havDistance(lat1, lat2, lng1 - lng2));
  }

  /// Returns hav() of distance from (lat1, lng1) to (lat2, lng2) on the unit sphere.
  static double havDistance(double lat1, double lat2, double dLng) {
    return hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
  }

  /// Returns haversine(angle-in-radians).
  /// hav(x) == (1 - cos(x)) / 2 == sin(x / 2)^2.
  static double hav(double x) {
    double sinHalf = sin(x * 0.5);
    return sinHalf * sinHalf;
  }
}