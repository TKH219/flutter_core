import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';

class CoreAppLogo extends StatelessWidget {

  String logoIconName;
  double padding;

  CoreAppLogo(String logoName, [double padding = CoreDimens.dp_102]) {
    this.logoIconName = logoName;
    this.padding = padding;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: new EdgeInsets.only(right: this.padding, left: this.padding),
      child: CoreImageUtils.getImage(
          logoIconName, BoxFit.fill),
    );
  }

}