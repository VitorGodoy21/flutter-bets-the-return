import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/components/filter_component.dart';
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
  List<Bet> filteredItems = [];

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
                  FilterComponent(
                    columnsFuture: fetchColumns(),
                    onFilterApplied: applyFilter,
                  ),
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
                    child: RefreshIndicator(
                      onRefresh: () {
                        return refresh();
                      },
                      child: ListView(
                        children: List.generate(
                          filteredItems.length,
                          (index) {
                            Bet model = filteredItems[index];
                            return ItemListBet(bet: model);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void applyFilter(String? column, String value) {
    setState(() {
      filteredItems = listBets.where((item) {
        return item.toMap()[column]?.toString().contains(value) ?? false;
      }).toList();
      totalBets = filteredItems.length;
    });
  }

  Future<List<String>> fetchColumns() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('bets').limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot firstDocument = querySnapshot.docs.first;
      Map<String, dynamic>? data =
          firstDocument.data() as Map<String, dynamic>?;

      if (data != null) {
        var returnedData = data.keys.toList();
        returnedData.add('id');
        return returnedData;
      }
    }

    return [];
  }

  refresh() async {
    List<Bet> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('bets')
        .orderBy('tip_date_timestamp', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      temp.add(Bet.fromMap(doc.data(), doc.id));
    }

    setState(() {
      listBets = temp;
      filteredItems = temp;
      totalBets = snapshot.docs.length;
    });
  }
}
