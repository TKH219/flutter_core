import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

abstract class CoreRouter {
  static Router router = Router();
  static GlobalKey<NavigatorState> navigatorKey;
}
