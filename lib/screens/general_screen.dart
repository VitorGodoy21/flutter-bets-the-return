import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/components/general_info_panel_generic.dart';
import 'package:flutter_bets_the_return/models/houses.dart';

import '../models/bet.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  List<House> listHouses = [];
  double totalProfit = 0;
  double totalAdjustment = 0;
  double totalBonusCredits = 0;
  double totalInitialBankroll = 0;
  double totalWithdrawal = 0;
  double totalOpenValue = 0;
  double totalCurrentBankroll = 0;
  double totalAvailableBankroll = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geral"),
      ),
      body: (listHouses.isEmpty)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Carregando informações\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GeneralInfoPanelGeneric<House>(
                      items: listHouses,
                      title: 'Lucro',
                      nameBuilder: (dynamic house) => house.name,
                      valueBuilder: (dynamic house) => house.profit,
                    ),
                  ),
                  Expanded(
                    child: GeneralInfoPanelGeneric<House>(
                      items: listHouses,
                      title: 'Banca Disponivel',
                      nameBuilder: (dynamic house) => house.name,
                      valueBuilder: (dynamic house) => house.availableBankroll,
                    ),
                  ),
                  Expanded(
                    child: GeneralInfoPanelGeneric<House>(
                      items: listHouses,
                      title: 'Banca Atual',
                      nameBuilder: (dynamic house) => house.name,
                      valueBuilder: (dynamic house) => house.currentBankroll,
                    ),
                  ),

                  Expanded(
                    child: GeneralInfoPanelGeneric<House>(
                      items: listHouses,
                      title: 'Valor em Aberto',
                      nameBuilder: (dynamic house) => house.name,
                      valueBuilder: (dynamic house) => house.openValue,
                    ),
                  ),

                  Expanded(
                    child: GeneralInfoPanelGeneric<House>(
                      items: listHouses,
                      title: 'Banca Inicial',
                      nameBuilder: (dynamic house) => house.name,
                      valueBuilder: (dynamic house) => house.initialBankroll,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  refresh() async {
    List<House> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('houses').orderBy('name').get();

    for (var doc in snapshot.docs) {
      temp.add(House.fromMap(doc.data()));
    }
    listHouses = temp;

    getInfos(temp);
  }

  getInfos(List<House> houses) async {
    double tempTotalProfit = 0;
    double tempTotalAdjustment = 0;
    double tempTotalBonusCredits = 0;
    double tempTotalInitialBankroll = 0;
    double tempTotalWithdrawal = 0;
    double tempTotalOpenValue = 0;
    double tempTotalCurrentBankroll = 0;
    double tempTotalAvailableBankroll = 0;

    List<House> updatedHouses = [];
    // double totalProfit = 0;
    for (var house in houses) {
      double houseProfit = 0;
      double houseOpenValue = 0;
      QuerySnapshot<Map<String, dynamic>> betsSnapshot = await firestore
          .collection(Bet.FIREBASE_TABLE_NAME)
          .where(
            'house',
            isEqualTo: house.name,
          )
          .get();

      for (var doc in betsSnapshot.docs) {
        Bet bet = Bet.fromMap(doc.data(), doc.id);
        // try{
          switch (bet.status) {
            case "Green":
              houseProfit += bet.valueXOdd - bet.value;
              break;
            case "Cashout":
              houseProfit += bet.valueXOdd - bet.value;
              break;
            case "Red":
              houseProfit -= bet.value;
              break;
            case "Aberto":
              houseOpenValue += bet.value;
              break;
            case "Anulado":
              houseProfit += 0;
              break;
            default:
              print("WRONG STATE: bet.status: ${bet.status}");
              houseProfit += 0;
          }
      }
      House tempHouse = house;
      tempHouse.profit = houseProfit;
      tempHouse.openValue = houseOpenValue;
      tempHouse.currentBankroll = house.initialBankroll +
          houseProfit +
          house.adjustment +
          house.bonusCredits -
          house.withdrawal;
      tempHouse.availableBankroll = tempHouse.currentBankroll - houseOpenValue;

      //Setup general total info, considering all houses
      tempTotalProfit += houseProfit;
      tempTotalAdjustment += house.adjustment;
      tempTotalBonusCredits += house.bonusCredits;
      tempTotalInitialBankroll += house.initialBankroll;
      tempTotalWithdrawal += house.withdrawal;
      tempTotalOpenValue += houseOpenValue;
      tempTotalCurrentBankroll += tempHouse.currentBankroll;
      tempTotalAvailableBankroll += tempHouse.availableBankroll;

      updatedHouses.add(tempHouse);
    }

    setState(() {
      listHouses = updatedHouses;
      totalProfit = tempTotalProfit;
      totalAdjustment = tempTotalAdjustment;
      totalBonusCredits = tempTotalBonusCredits;
      totalInitialBankroll = tempTotalInitialBankroll;
      totalWithdrawal = tempTotalWithdrawal;
      totalOpenValue = tempTotalOpenValue;
      totalCurrentBankroll = tempTotalCurrentBankroll;
      totalAvailableBankroll = tempTotalAvailableBankroll;
    });
  }
}
