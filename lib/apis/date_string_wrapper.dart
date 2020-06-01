import 'dart:convert';
//Turn my custom json to a Date e.g DateStringWrapper("jsonstring").perform flutter Date functions



class DateStringWrapper  {

  DateTime dartDateTime;
  String jsonDateTime;

  DateStringWrapper(String json){
    jsonDateTime = json;
    dartDateTime = convertToDateTime(json);
  }

  DateStringWrapper.withDate(DateTime time){
    jsonDateTime = convertToJsonString(time);
    dartDateTime = time;
  }

  int getHour(){
    return null;
  }

  String convertToJsonString(DateTime date){
    Map map = {};
    map["year"] = date.year;
    map["month"] = date.month;
    map["day"] = date.day;
    map["hour"] = date.hour;
    map["minute"] = date.minute;

    return json.encode(map);

  }

  DateTime convertToDateTime(String jsonStr){
    Map map = json.decode(jsonStr);
    DateTime date = DateTime(
      map["year"],
      map["month"],
      map["day"],
      map["hour"],
      map["minute"],
    );

    return date;
  }

}
