
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'LatLngBuilder.dart';
import 'SphericalUtil.dart';

class LatLngUtils {

  static LatLngBounds getLatLngBounds(List<LatLng> latLngArr) {
    LatLngBuilder latLngBuilder = LatLngBuilder();
    latLngArr.forEach((item) {
      latLngBuilder.include(item);
    });
    return latLngBuilder.build();
  }


  static LatLngBounds getLatLngBoundsOfCirCle(double radius, LatLng center) {
    LatLng targetNorthEast = SphericalUtil.computeOffset(center, radius * sqrt(2.0), 45.0);
    LatLng targetSouthWest = SphericalUtil.computeOffset(center, radius * sqrt(2.0), 225.0);
    LatLngBounds latLngBounds = LatLngBounds(southwest: targetSouthWest, northeast: targetNorthEast);
    return latLngBounds;
  }

  static sortPolygon(List<LatLng> points) {
    final newBounds = getLatLngBounds(points);
    final center = SphericalUtil.getCenterOfLatLngBounds(newBounds);
    List<MapEntry<LatLng,double>> entryList = List<MapEntry<LatLng,double>>();
    points.forEach((item) {
      final heading = SphericalUtil.computeHeading(item, center);
      entryList.add(MapEntry(item, heading));
    });
    entryList.sort((obj1, obj2) {
      return obj1.value.compareTo(obj2.value);
    });
    points.clear();
    entryList.forEach((item) {
      points.add(item.key);
    });
  }


}