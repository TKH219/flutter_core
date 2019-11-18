class CoreResponseError {

  dynamic errorCode;

  String errorMessage;

  CoreResponseError({this.errorCode, this.errorMessage});

  CoreResponseError.fromValues(dynamic errorCode, String errorMessage) {
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }

}