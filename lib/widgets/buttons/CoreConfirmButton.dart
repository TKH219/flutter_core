import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';
import 'package:sw_core_package/widgets/buttons/bases/CoreStatelessButton.dart';

class CoreConfirmButton extends CoreStatelessButton {
  CoreConfirmButton({String text, Function() onTapCallback,
      EdgeInsetsGeometry buttonMargin = const EdgeInsets.only(
          top: CoreDimens.defaultPadding, bottom: CoreDimens.defaultPadding),
      bool isEnabled = true,
      int height = 50,
      List<Color> arrayColors = const []})
      : super(
            text, onTapCallback, buttonMargin, isEnabled, height, arrayColors);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTapCallback : null,
      child: Container(
        margin: buttonMargin,
        height: CoreDimens.dp_50,
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
            color: isEnabled
                ? CoreColors.buttonEnableBackgroundColor
                : CoreColors.buttonDisableBackgroundColor,
            borderRadius: new BorderRadius.all(
                const Radius.circular(CoreDimens.defaultRadius)),
            gradient: (isEnabled && arrayColors.length >= 2)
                ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: arrayColors)
                : null),
        child: new Text(
          buttonText.toUpperCase(),
          style: new TextStyle(
            color: isEnabled
                ? CoreColors.buttonEnableTextColor
                : CoreColors.buttonDisableTextColor,
            fontSize: CoreDimens.SemiLargeTextSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
