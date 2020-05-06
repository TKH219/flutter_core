// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoreResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return CoreResponse(
      message: json['message'] as String,
      errorMessage: json['errorMessage'] as String);
}

Map<String, dynamic> _$BaseResponseToJson(CoreResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errorMessage': instance.errorMessage
    };
