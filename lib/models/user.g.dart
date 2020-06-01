// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..uid = json['uid'] as String
    ..email = json['email'] as String
    ..password = json['password'] as String
    ..codename = json['codename'] as String
    ..membership = json['membership'] as String
    ..phoneNumber = json['phoneNumber'] as String
    ..pictureUrl = json['pictureUrl'] as String
    ..voiceUrl = json['voiceUrl'] as String
    ..sex = json['sex'] as String
    ..religion = json['religion'] as String
    ..maritalStatus = json['maritalStatus'] as String
    ..genotype = json['genotype'] as String
    ..dob = json['dob'] as String
    ..location = json['location'] as String
    ..stateOfOrigin = json['stateOfOrigin'] as String
    ..education = json['education'] as String
    ..carrer = json['carrer'] as String
    ..summary = json['summary'] as String
    ..matches = json['matches'] as List;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'password': instance.password,
      'codename': instance.codename,
      'membership': instance.membership,
      'phoneNumber': instance.phoneNumber,
      'pictureUrl': instance.pictureUrl,
      'voiceUrl': instance.voiceUrl,
      'sex': instance.sex,
      'religion': instance.religion,
      'maritalStatus': instance.maritalStatus,
      'genotype': instance.genotype,
      'dob': instance.dob,
      'location': instance.location,
      'stateOfOrigin': instance.stateOfOrigin,
      'education': instance.education,
      'carrer': instance.carrer,
      'summary': instance.summary,
      'matches': instance.matches
    };
