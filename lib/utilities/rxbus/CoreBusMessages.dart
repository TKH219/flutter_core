class ShowProgressHUB {
  bool shouldShow;

  ShowProgressHUB(this.shouldShow);
}

class ShowToastMessage {
  String toastText;

  ShowToastMessage(this.toastText);
}

class ShowSnackMessage {
  String message;
  ShowSnackMessage(this.message);
}

class ShowCodeError {
  int errorCode;
  ShowCodeError({this.errorCode});
}
class NoConnection{
  bool isNotConnect;
  NoConnection(this.isNotConnect);
}
class RxBusTag {
  static const RxBusTag_TOKEN_INVALID = "RxBusTag_TOKEN_INVALID";
}
