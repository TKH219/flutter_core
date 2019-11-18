// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoreResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return CoreResponse(
      success: json['success'] as bool,
      name: json['name'] as String,
      created: json['created'] as String,
      message: json['message'] as String,
      errorMessage: json['errorMessage'] as String);
}

Map<String, dynamic> _$BaseResponseToJson(CoreResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'name': instance.name,
      'created': instance.created,
      'message': instance.message,
      'errorMessage': instance.errorMessage
    };
