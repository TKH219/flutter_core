import 'package:flutter/widgets.dart';
import 'CoreRoutes.dart';

class CoreScreenNavigator {
  void pop({bool returnResult = false}) {
    CoreRouter.navigatorKey.currentState.pop(returnResult);
  }

  void popUntil(String routePath) {
    CoreRouter.navigatorKey.currentState
        .popUntil(ModalRoute.withName(routePath));
  }

  Future<T> pushScreen<T extends Object>(String serviceName,
      {List<dynamic> params, bool isReplace = false}) {
    var routePath = serviceName;
    if (params != null && params.length > 0) {
      params.forEach((param) {
        routePath = "$routePath/$param";
      });
    }
    if (isReplace) {
      CoreRouter.navigatorKey.currentState.pushReplacementNamed(routePath);
    } else {
      CoreRouter.navigatorKey.currentState.pushNamed(routePath);
    }
  }
}
