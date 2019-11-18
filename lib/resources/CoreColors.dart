import 'package:flutter/material.dart';

class CoreColors {

  static const Color Black_4a = const Color(0xFF4a4a4a); //#4a4a4a,
  static const Color Black_12_a = Colors.black45;
  static const Color White = const Color(0xFFFFFFFF);
  static const Color Orange_28 = const Color(0xFFF05A28);
  static const Color Gray_d3 = const Color(0xB3d3d3d3);
  static const Color Blue_Accent = Colors.blueAccent;
  static const Color Transparent = const Color(0x00FFFFFF);

  // //// Text
  static Color highlightColor = Blue_Accent;
  static Color linkTextColor = Blue_Accent;
  static Color errorTextColor = Blue_Accent;
  // //// loading
  static Color loadingColor = highlightColor;
  static Color loadingBoxBackgroundColor = White;
  static Color loadingBackgroundColor = Black_12_a;

  // //// toast
  static Color toastBackgroundColor = White;
  static Color toastTextColor = primaryTextColor;

  // //// text
  static Color primaryTextColor = Black_4a;

  // //// app bar
  static Color appBarBackgroundColor = White;

  // //// buttons
  // enable
  static Color buttonEnableTextColor = White;
  static Color buttonEnableBackgroundColor = Blue_Accent;
  // disable
  static Color buttonDisableTextColor = Black_4a;
  static Color buttonDisableBackgroundColor = Gray_d3;
  // input
  static Color inputCursorColor = highlightColor;
  static Color inputHintColor = Black_12_a;
  static Color inputIconColor = primaryTextColor;
}