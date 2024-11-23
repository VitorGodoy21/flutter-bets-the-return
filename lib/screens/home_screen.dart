import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/components/filter_component.dart';
import 'package:flutter_bets_the_return/models/bet.dart';
import 'package:flutter_bets_the_return/themes/theme_colors.dart';
import '../Util/bet_utils.dart';
import '../components/item-list/item_list_bet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Bet> _items = [];

  bool _isLoading = false;
  bool _hasMore = true;

  DocumentSnapshot? _lastDocument;

  final int _batchSize = 10;

  List<Bet> filteredItems = [];
  int totalBets = -1;

  String? filterColumnName;
  String? filterColumnValue;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _loadItems();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadItems() async {
    if (_isLoading || !_hasMore) return;

    int tempTotalCount = -1;

    setState(() {
      _isLoading = true;
    });

    Query query;
    if (filterColumnName != null && filterColumnValue != null) {
      query = firestore
          .collection(Bet.FIREBASE_TABLE_NAME)
          .where(filterColumnName.toString(), isEqualTo: filterColumnValue)
          .limit(_batchSize);

      QuerySnapshot totalQuerySnapshot = await firestore
          .collection(Bet.FIREBASE_TABLE_NAME)
          .where(filterColumnName.toString(), isEqualTo: filterColumnValue)
          .get();

      tempTotalCount = totalQuerySnapshot.size;
    } else {
      query = firestore.collection(Bet.FIREBASE_TABLE_NAME).limit(_batchSize);

      QuerySnapshot totalQuerySnapshot =
          await firestore.collection(Bet.FIREBASE_TABLE_NAME).get();

      tempTotalCount = totalQuerySnapshot.size;
    }

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = querySnapshot.docs.last;
        _items.addAll(BetUtils.fromMap(querySnapshot.docs));
        filteredItems = _items;
        totalBets = tempTotalCount;
        if (querySnapshot.docs.length < _batchSize) {
          _hasMore = false;
        }
      });
    } else {
      setState(() {
        _hasMore = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadItems();
    }
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
      body: (_items.isEmpty)
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
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _items.length + (_hasMore ? 1 : 0),
                      // Adiciona um item extra para o loading
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          // Exibe indicador de carregamento no final
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final Bet item = filteredItems[index];
                        return ItemListBet(bet: item);
                      },
                    ),
                  ),
                  if (_isLoading && _items.isEmpty)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }

  void applyFilter(String? column, String value) {
    setState(() {
      filterColumnName = column;
      filterColumnValue = value;
      _lastDocument = null;
      _items.clear();
      _loadItems();
    });
  }

  Future<List<String>> fetchColumns() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Bet.FIREBASE_TABLE_NAME)
        .limit(1)
        .get();

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
}
