import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:sw_core_package/utilities/map/SphericalUtil.dart';

class AppMapController {
  AppMapController(this._mapController);

  final Logger _logger = new Logger("AppMapController");

  final double defaultBoundsPadding = 40.0;

  GoogleMapController _mapController;

  CameraPosition _lastPosition;

  double _zoomStep = 1.0;

  double get _currentZoom => _lastPosition != null ? _lastPosition.zoom : 1.0;

  void onCameraIdle() {}

  void onCameraMove(CameraPosition lastPosition) {
    _lastPosition = lastPosition;
    _logger.fine("onCameraMove - zoom: ${_lastPosition.zoom}");
    _validateBoundsZoom();
  }

  Future<void> _validateBoundsZoom() async {}

  Future<void> animateCameraToLatLng(LatLng latLng,
      {double zoom = 0.0, bool zoomFromTop = true}) async {
    if (zoom == 0.0) {
      zoom = this._currentZoom;
    }
    if (Platform.isAndroid) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
    } else {
      await _handleIOSZoom(latLng, zoom, zoomFromTop: zoomFromTop);
    }
  }

  Future<void> animateCameraToBound(LatLngBounds latLngBounds,
      {bool zoomFromTop = true}) async {
    if (Platform.isAndroid) {
      _mapController.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, defaultBoundsPadding));
    } else {
      await _handleIOSBoundZoom(latLngBounds, zoomFromTop: zoomFromTop);
    }
  }

  Future<void> _handleIOSBoundZoom(LatLngBounds latLngBounds,
      {bool zoomFromTop = true}) async {
    if (latLngBounds == null) return;
    final centerLatLng = SphericalUtil.getCenterOfLatLngBounds(latLngBounds);
    await _handleIOSZoom(centerLatLng, 20.0,
        bounds: latLngBounds, zoomFromTop: zoomFromTop);
  }

  Future<void> _handleIOSZoom(LatLng latLng, double destinationZoom,
      {LatLngBounds bounds, bool zoomFromTop = true}) async {
    double _toZoom = zoomFromTop ? 1.0 : this._currentZoom;
    _zoomStep = 0.75;
    //
    if (_toZoom > destinationZoom) {
      _toZoom = destinationZoom - _zoomStep;
    }
    //
    var boundDiameter = 0.0;
    if (bounds != null) {
      boundDiameter = SphericalUtil.computeDistanceBetween(
          bounds.southwest, bounds.northeast);
    }
    // zoom down to destination
    for (; _toZoom < destinationZoom; _toZoom += _zoomStep) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, _toZoom));
      await Future.delayed(Duration(milliseconds: 150));
      // handle LatLngBound case
      if (boundDiameter > 0.0) {
        final region = await _mapController.getVisibleRegion();
        final distance = SphericalUtil.computeDistanceBetween(
            bounds.southwest, region.southwest);
        if (distance < boundDiameter) {
          _zoomStep = 0.25;
          if (distance < boundDiameter / 2) {
            await _mapController.animateCamera(
                CameraUpdate.newLatLngBounds(bounds, defaultBoundsPadding));
            bounds = null;
            break;
          }
        }
      }
    }
    //
  }
}
