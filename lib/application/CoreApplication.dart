import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sw_core_package/configs/CoreAppConfigs.dart';
import 'package:sw_core_package/routes/CoreRoutes.dart';

abstract class CoreApplication extends StatelessWidget {
  CoreApplication({Key key}) : super(key: key) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _configureLogger();
    initResources();
  }

  Iterable<LocalizationsDelegate<dynamic>> initLocalizationsDelegate();
  Iterable<Locale> initSupportLocales();

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      title: '',
      theme: getCurrentTheme(context),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _getRoute,
      navigatorKey: CoreRouter.navigatorKey,
      localizationsDelegates: initLocalizationsDelegate(),
      supportedLocales: initSupportLocales(),
      locale: defaultLocale(),
    );
    return materialApp;
  }

  Route _getRoute(RouteSettings settings) {
    return CoreRouter.router.generator(settings);
  }

  Locale defaultLocale() {
    return Locale('en');
  }

  _configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      if (CoreAppConfigs.isDebug) {
        print(
            '[${rec.level.name}][${rec.time}][${rec.loggerName}]: ${rec.message}');
      }
    });
  }

  ThemeData getCurrentTheme(BuildContext context) {
    return ThemeData(primarySwatch: Colors.blue);
  }

  void initResources();
}
