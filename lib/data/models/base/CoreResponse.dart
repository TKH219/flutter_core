import 'package:json_annotation/json_annotation.dart';
part 'CoreResponse.g.dart';

@JsonSerializable()
class CoreResponse extends Object{

  bool success = false;
  String name;
  String created;
  String message;
  String errorMessage;
  @JsonKey(ignore: true)
  int headerErrorCode = HttpCode.OK;

  //
  CoreResponse({this.success = false, this.name = "", this.created = "",
    this.message = "", this.errorMessage = "", this.headerErrorCode = HttpCode.OK});

  bool isSuccessCode() {
    return headerErrorCode == HttpCode.OK;
  }

  void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
    this.success = false;
  }

  factory CoreResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);

}

class HttpCode {
  static const int OK = 200;
}
