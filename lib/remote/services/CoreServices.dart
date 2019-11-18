import 'package:sw_core_package/remote/builder/CoreRequestBuilder.dart';

abstract class CoreServices<RB extends CoreRequestBuilder> {
  // ignore: non_constant_identifier_names
  CoreRequestBuilder requestBuilder();
}