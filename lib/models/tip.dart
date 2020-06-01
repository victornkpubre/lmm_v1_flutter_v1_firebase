import 'package:json_annotation/json_annotation.dart';

part 'tip.g.dart';

@JsonSerializable()
class Tip {
    Tip();

    String id;
    String oldText;
    String newText;
    
    factory Tip.fromJson(Map<String,dynamic> json) => _$TipFromJson(json);
    Map<String, dynamic> toJson() => _$TipToJson(this);
}
