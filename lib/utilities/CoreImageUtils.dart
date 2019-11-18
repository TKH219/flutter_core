import 'package:flutter/widgets.dart';

class CoreImageUtils {

  static Image getImage(String imagePath,
      [BoxFit scaleStyle = BoxFit.fill, double width = 0.0, double height = 0.0, Color color]) {
    var assetsImage =
    AssetImage(imagePath); //<- Creates an object that fetches an image.
    if (width == 0 || height == 0) {
      return Image(image: assetsImage, fit: scaleStyle, color: color);
    } else {
      return Image(
        image: assetsImage,
        fit: scaleStyle,
        color: color,
        width: width,
        height: height,
      );
    }
  }

}