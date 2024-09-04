import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  String eventDate;
  Timestamp eventDateTimestamp;
  String name;
  String tipDate;
  Timestamp tipDateTimestamp;

  Test({
      required this.eventDate,
      required this.eventDateTimestamp,
      required this.name,
      required this.tipDate,
      required this.tipDateTimestamp});

  Test.fromMap(Map<String, dynamic> map)
      : eventDate = map["event_date"],
        eventDateTimestamp = map["event_date_timestamp"],
        name = map["name"],
        tipDate = map["tip_date"],
        tipDateTimestamp = map["tip_date_timestamp"];

  Map<String, dynamic> toMap() {
    return {
      "event_date": eventDate,
      "event_date_timestamp": eventDateTimestamp,
      "name": name,
      "tip_date": tipDate,
      "tip_date_timestamp": tipDateTimestamp
    };
  }
}
