import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class CoreStatelessButton extends StatelessWidget {
  String buttonText;
  Function() onTapCallback;
  EdgeInsetsGeometry buttonMargin;
  bool isEnabled;
  int height;
  List<Color> arrayColors;

  CoreStatelessButton(String text, Function() onTapCallback,
      EdgeInsetsGeometry buttonMargin, bool isEnabled,
      [int height, List<Color> colors]) {
    this.buttonText = text;
    this.onTapCallback = onTapCallback;
    this.buttonMargin = buttonMargin;
    this.isEnabled = isEnabled;
    this.height = height;
    this.arrayColors = colors;
  }
}