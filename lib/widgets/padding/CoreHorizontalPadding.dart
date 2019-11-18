import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';

// ignore: must_be_immutable
class CoreHorizontalPadding extends StatelessWidget {

  double _paddingHeight;

  CoreHorizontalPadding([double height = CoreDimens.defaultPadding]) {
    _paddingHeight = height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoreColors.Transparent,
      height: _paddingHeight,
    );
  }

}