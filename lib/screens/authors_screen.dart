import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/components/item_list_author.dart';

import '../models/author.dart';
import '../models/bet.dart';
import '../themes/theme_colors.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  List<Author> listAuthors = [];
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
        title: const Text("Indicações"),
      ),
      body: (listAuthors.isEmpty)
          ? const Center(
              child: Text(
              "Nenhuma indicação encontrada.\n",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ))
          : Container(
              decoration: const BoxDecoration(
                color: ThemeColors.backgroundColor,
              ),
              child: Expanded(
                child: ListView(
                  children: List.generate(
                    listAuthors.length,
                    (index) {
                      Author model = listAuthors[index];
                      return ItemListAuthor(author: model);
                    },
                  ),
                ),
              ),
            ),
    );
  }

  refresh() async {
    List<Author> temp = [];
    QuerySnapshot<Map<String, dynamic>> authorSnapshot =
        await firestore.collection('authors').get();

    for (var doc in authorSnapshot.docs) {
      int green = 0;
      int red = 0;
      int open = 0;
      int betVoid = 0;
      int cashout = 0;
      double profit = 0;

      Author author = Author.fromMap(doc.data());
      QuerySnapshot<Map<String, dynamic>> betSnapshot = await firestore
          .collection('bets')
          .where('author', isEqualTo: author.name)
          .get();

      for (var doc in betSnapshot.docs) {
        Bet bet = Bet.fromMap(doc.data());
        switch (bet.status) {
          case "Green":
            green++;
            profit += bet.valueXOdd - bet.value;
            break;
          case "Red":
            red++;
            profit -= bet.value;
            break;
          case "Aberto":
            open++;
            break;
          case "Anulado":
            betVoid++;
            break;
          case "Cashout":
            cashout++;
            profit += bet.valueXOdd - bet.value;
            break;
        }
      }

      Author updatedAuthor = Author(
          name: author.name,
          alias: author.alias,
          profit: profit,
          //TODO: GET UNIT VALUE BY FIRESTORE
          profitInBetUnit: profit / 50,
          totalBets: green + red + open + betVoid + cashout,
          totalGreen: green,
          totalRed: red,
          totalOpen: open,
          totalVoid: betVoid,
          totalCashout: cashout);

      temp.add(updatedAuthor);
    }

    setState(() {
      listAuthors = temp;
    });
  }
}
