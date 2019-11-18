import 'package:flutter/painting.dart';
import 'package:sw_core_package/sw_core_package.dart';

class CoreStyles {
  static TextStyle underlineNormalTextStyle(
          [color = CoreColors.Black_4a,
          decorationColor = CoreColors.Black_4a]) =>
      TextStyle(
          fontWeight: FontWeight.w400,
          color: getTextColor(color),
          fontSize: CoreDimens.SemiLargeTextSize,
          decoration: TextDecoration.underline,
          decorationColor: decorationColor);

  static TextStyle normalTextStyle([color = CoreColors.Black_4a]) =>
      TextStyle(
        fontWeight: FontWeight.w400,
        color: getTextColor(color),
        fontSize: CoreDimens.SemiLargeTextSize,
      );


  static TextStyle semiBoldTextStyle([color = CoreColors.Black_4a]) =>
      TextStyle(
        fontWeight: FontWeight.w600,
        color: getTextColor(color),
        fontSize: CoreDimens.SemiLargeTextSize,
      );

  static TextStyle boldTextStyle([color = CoreColors.Black_4a]) =>
      TextStyle(
        fontWeight: FontWeight.w900,
        color: getTextColor(color),
        fontSize: CoreDimens.SemiLargeTextSize,
      );

  static TextStyle subtitleTextStyle([color = CoreColors.Black_4a]) =>
      TextStyle(
        fontWeight: FontWeight.w400,
        color: getTextColor(color),
        fontSize: CoreDimens.NormalTextSize,
      );

  static Color getTextColor(Color colorParams) {
    if (colorParams == CoreColors.Black_4a) {
      return CoreColors.primaryTextColor;
    } else {
      return colorParams;
    }
  }
}
