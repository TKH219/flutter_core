import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';
import 'package:sw_core_package/widgets/buttons/bases/CoreStatelessButton.dart';

class CoreLinkButton extends CoreStatelessButton {

  Color textColor;
  CoreLinkButton(String text, Color textColor,Function() onTapCallback,
      [EdgeInsetsGeometry buttonMargin = const EdgeInsets.only(top: CoreDimens.defaultPadding, bottom: CoreDimens.defaultPadding),
      bool isEnabled = true])
      : super(text, onTapCallback, buttonMargin, isEnabled) {
    this.textColor = textColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTapCallback : null,
      child: FlatButton(
        padding: buttonMargin,
        onPressed: null,
        child: new Text(
          buttonText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: CoreStyles.semiBoldTextStyle(this.textColor),
        ),
      ),
    );
  }
}
