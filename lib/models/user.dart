import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    String uid;
    String email;
    String password;
    String codename;
    String membership;
    String phoneNumber;
    String pictureUrl;
    String voiceUrl;
    String sex;
    String religion;
    String maritalStatus;
    String genotype;
    String dob;
    String location;
    String stateOfOrigin;
    String education;
    String carrer;
    String summary;
    List matches;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
