import 'package:flutter_bets_the_return/Util/string_utils.dart';

class Bet {

  static const String FIREBASE_TABLE_NAME = 'bets';

  String id;
  String author;
  String championship;
  String description;
  String eventDate;
  String homeTeam;
  String house;
  String market;
  double odd;
  String preOrLive;
  String sport;
  String status;
  String tipDate;
  double value;
  double valueXOdd;
  String visitingTeam;

  Bet({
      required this.id,
      required this.author,
      required this.championship,
      required this.description,
      required this.eventDate,
      required this.homeTeam,
      required this.house,
      required this.market,
      required this.odd,
      required this.preOrLive,
      required this.sport,
      required this.status,
      required this.tipDate,
      required this.value,
      required this.valueXOdd,
      required this.visitingTeam});

  Bet.fromMap(Map<String, dynamic> map, this.id)
      : author = map["author"],
        championship = map["championship"],
        description = map["description"],
        eventDate = map["event_date"],
        homeTeam = map["home_team"],
        house = map["house"],
        market = map["market"],
        odd = (map["odd"] as num).toDouble(),
        preOrLive = map["pre_or_live"],
        sport = map["sport"],
        status = map["status"],
        tipDate = map["tip_date"],
        value = (map["value"] as num).toDouble(),
        valueXOdd = (map["valuexodd"] as num).toDouble(),
        visitingTeam = map["visiting_team"];


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "author": author,
      "championship": championship,
      "description": description,
      "event_date": eventDate,
      "home_team": homeTeam,
      "house": house,
      "market": market,
      "odd": odd,
      "pre_or_live": preOrLive,
      "sport": sport,
      "status": status,
      "tip_date": tipDate,
      "value": value,
      "valuexodd": valueXOdd,
      "visiting_team": visitingTeam,
    };
  }

  Map<String, dynamic> toFirebaseMap(double updatedValue, String updatedStatus) {
    return {
      "author": author,
      "championship": championship,
      "description": description,
      "event_date": eventDate,
      "event_date_timestamp": eventDate.toTimestamp("dd/MM/yyyy"),
      "home_team": homeTeam,
      "house": house,
      "market": market,
      "odd": odd,
      "pre_or_live": preOrLive,
      "sport": sport,
      "status": updatedStatus,
      "tip_date": tipDate,
      "tip_date_timestamp": tipDate.toTimestamp("dd/MM/yyyy"),
      "value": updatedValue,
      "valuexodd": valueXOdd,
      "visiting_team": visitingTeam,
    };
  }
}
