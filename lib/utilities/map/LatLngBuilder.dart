import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngBuilder {
  double zzdg = 1.0 / 0.0;
  double zzdh = -1.0 / 0.0;
  double zzdi = 0.0/0.0;
  double zzdj = 0.0 / 0.0;

  LatLngBuilder() {}

  LatLngBuilder include(LatLng var1) {
    this.zzdg = min(this.zzdg, var1.latitude);
    this.zzdh = max(this.zzdh, var1.latitude);
    double var2 = var1.longitude;
    if (this.zzdi.isNaN) {
      this.zzdi = var2;
    } else {
      if (this.zzdi <= this.zzdj ? this.zzdi <= var2 && var2 <= this.zzdj : this.zzdi <= var2 || var2 <= this.zzdj) {
        return this;
      }

      if (zza(this.zzdi, var2) < zzb(this.zzdj, var2)) {
        this.zzdi = var2;
        return this;
      }
    }

    this.zzdj = var2;
    return this;
  }

  LatLngBounds build() {
    return LatLngBounds(
        southwest: LatLng(this.zzdg, this.zzdi),
        northeast: LatLng(this.zzdh, this.zzdj));
  }

  double zza(double var0, double var2) {
    return (var0 - var2 + 360.0) % 360.0;
  }

  double zzb(double var0, double var2) {
    return (var2 - var0 + 360.0) % 360.0;
  }
}
