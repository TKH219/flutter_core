import 'dart:ui';
import 'package:flutter/widgets.dart';

abstract class CoreLocalization {

  final Locale locale;

  CoreLocalization(this.locale);

  static CoreLocalization of(BuildContext context) {
    return Localizations.of<CoreLocalization>(
        context, CoreLocalization);
  }

  String getText(String tag);

}

