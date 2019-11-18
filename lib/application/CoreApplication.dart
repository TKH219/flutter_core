
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sw_core_package/configs/CoreAppConfigs.dart';
import 'package:sw_core_package/routes/CoreRoutes.dart';
import 'package:sw_core_package/utilities/CoreStorageManager.dart';

abstract class CoreApplication extends StatelessWidget {

  CoreApplication({Key key}) : super(key: key) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _configureLogger();
    initResources();
    //
  }


  Iterable<LocalizationsDelegate<dynamic>> initLocalizationsDelegate();

  Iterable<Locale> initSupportLocales();

  void initResources();

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _getRoute,
      navigatorKey: CoreRouter.navigatorKey,
      localizationsDelegates: initLocalizationsDelegate(),
      supportedLocales: initSupportLocales(),
    );
    return materialApp;
  }

  Route _getRoute(RouteSettings settings) {
    return CoreRouter.router.generator(settings);
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
}
