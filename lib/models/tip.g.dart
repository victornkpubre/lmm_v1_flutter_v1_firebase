// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tip _$TipFromJson(Map<String, dynamic> json) {
  return Tip()
    ..id = json['id'] as String
    ..oldText = json['oldText'] as String
    ..newText = json['newText'] as String;
}

Map<String, dynamic> _$TipToJson(Tip instance) => <String, dynamic>{
      'id': instance.id,
      'oldText': instance.oldText,
      'newText': instance.newText
    };
