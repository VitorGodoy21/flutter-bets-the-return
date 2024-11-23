import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bet.dart';

class BetUtils {
  static List<Bet> fromMap<T>(List<QueryDocumentSnapshot<T>> list){
    List<Bet> temp = [];
    for(var doc in list){
      temp.add(Bet.fromMap(doc.data() as Map<String, dynamic>, doc.id));
    }
    return temp;
  }
}