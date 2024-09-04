import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/components/item_list_bet.dart';
import 'package:flutter_bets_the_return/models/bet.dart';
import 'package:flutter_bets_the_return/themes/theme_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bet> listBets = [];

  int totalBets = -1;

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
        title: const Text("Apostas - o Retorno"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: (listBets.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma Aposta ainda.\n",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                color: ThemeColors.backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Total apostas: ${totalBets}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        listBets.length,
                        (index) {
                          Bet model = listBets[index];
                          return ItemListBet(bet: model);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  refresh() async {
    List<Bet> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('bets')
        // .where('tip_date', isEqualTo: "03/09/2024")
        .orderBy('tip_date_timestamp', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      temp.add(Bet.fromMap(doc.data()));
    }

    setState(() {
      listBets = temp;
      totalBets = snapshot.docs.length;
    });
  }
}
