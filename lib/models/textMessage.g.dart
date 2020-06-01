// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textMessage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) {
  return TextMessage()
    ..uid = json['uid'] as String
    ..title = json['title'] as String
    ..body = json['body'] as String
    ..time = json['time'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'body': instance.body,
      'time': instance.time,
      'status': instance.status
    };
