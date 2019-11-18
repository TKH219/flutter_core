import 'package:flutter/widgets.dart';
import 'package:sw_core_package/localizes/CoreLocalization.dart';

abstract class CoreLocalizationDelegate<CL extends CoreLocalization>  extends LocalizationsDelegate<CL>{

  const CoreLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return [CoreSupportLocale.en, CoreSupportLocale.vi].contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate old) {
   return false;
  }

}

class CoreSupportLocale {

  static const String en = "en";
  static const String vi = "vi";

}