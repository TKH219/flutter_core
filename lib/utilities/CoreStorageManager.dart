import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CoreStorageManager {

  SharedPreferences prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token);

  String get getToken;

  //// Keys
  static const userTokenKey = "_userTokenKey";

}