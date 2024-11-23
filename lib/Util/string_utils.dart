import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension StringUtilsExtension on String{
  Timestamp? toTimestamp(String dateFormatString){
    try {
      DateFormat dateFormat = DateFormat(dateFormatString);
      DateTime dateTime = dateFormat.parse(this);
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      return timestamp;
    } catch (e) {
      return null;
    }
  }
}


