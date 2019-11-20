import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sw_core_package/data/models/base/CoreResponse.dart';
import 'package:sw_core_package/utilities/rxbus/CoreBusMessages.dart';
import 'package:sw_core_package/utilities/rxbus/rxbus.dart';

abstract class CoreBloc<CS extends CoreResponse> {
  String get busTag => this.runtimeType.toString();

  @protected
  final Logger _logger = Logger("CoreBloc");

  // ignore: close_sinks
  final BehaviorSubject<CS> subject = BehaviorSubject<CS>();

  CoreBloc() {
    subject.sink.add(null);
  }

  void onReady() {}

  void showProgressHub(bool shouldShow) {
    RxBus.post(ShowProgressHUB(shouldShow), tag: busTag);
  }

  void showToast(String toastMessage) {
    RxBus.post(ShowToastMessage(toastMessage), tag: busTag);
  }

  dispose() {
    subject.close();
  }
}
