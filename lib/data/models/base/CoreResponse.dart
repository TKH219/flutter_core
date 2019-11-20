import 'package:json_annotation/json_annotation.dart';
import 'package:sw_core_package/remote/constants/RemoteConstants.dart';
part 'CoreResponse.g.dart';

@JsonSerializable()
class CoreResponse extends Object {
  String name;
  String created;
  String message;
  String errorMessage;
  @JsonKey(ignore: true)
  int headerErrorCode = CoreHttpCode.OK;

  //
  CoreResponse(
      {this.name = "",
      this.created = "",
      this.message = "",
      this.errorMessage = ""});

  bool isSuccessCode() {
    return headerErrorCode == CoreHttpCode.OK;
  }

  void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
  }

  factory CoreResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
