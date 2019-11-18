import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';

class CoreAppBar {
  static AppBar BackAppBar(BuildContext context, String title, [bool shouldCenterTitle = true, List<Widget> actions]) {
    return AppBar(
      backgroundColor: CoreColors.appBarBackgroundColor,
      iconTheme: IconThemeData(
        color: CoreColors.primaryTextColor, //change your color here
      ),
      title: Text(
        title,
        style: CoreStyles.semiBoldTextStyle(),
      ),
      centerTitle: shouldCenterTitle,
      actions: actions,
    );
  }
}