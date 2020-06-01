import 'package:json_annotation/json_annotation.dart';

part 'textMessage.g.dart';

@JsonSerializable()
class TextMessage {
    TextMessage();

    String uid;
    String title;
    String body;
    String time;
    String status;
    
    factory TextMessage.fromJson(Map<String,dynamic> json) => _$TextMessageFromJson(json);
    Map<String, dynamic> toJson() => _$TextMessageToJson(this);
}
