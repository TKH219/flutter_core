import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class CoreStatefulButton extends StatefulWidget {

  @protected
  String buttonText;
  @protected
  Function() onTapCallback;
  @protected
  bool isEnabled;
  @protected
  EdgeInsetsGeometry buttonMargin;

  CoreStatefulButton(String buttonText, Function() onTapCallback, bool isEnabled, EdgeInsetsGeometry buttonMargin, {Key key}): super(key: key) {
    this.buttonText = buttonText;
    this.buttonMargin = buttonMargin;
    this.onTapCallback = onTapCallback;
    this.isEnabled = isEnabled;
  }

  void setEnabled(bool shouldEnable);
}


abstract class CoreButtonState extends State<CoreStatefulButton> {

  String buttonText;
  Function() onTapCallback;
  @protected
  bool isEnabled;
  EdgeInsetsGeometry buttonMargin;

  CoreButtonState(String buttonText, Function() onTapCallback, bool isEnabled, EdgeInsetsGeometry buttonMargin) {
    this.buttonText = buttonText;
    this.buttonMargin = buttonMargin;
    this.onTapCallback = onTapCallback;
    this.isEnabled = isEnabled;
  }

  onButtonPressed() {
    if (isEnabled) {
      onTapCallback();
    }
  }

  void setEnabled(bool shouldEnable) {
    setState(() {
      isEnabled = shouldEnable;
    });
  }
}