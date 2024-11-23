import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/double_utils.dart';

import '../../models/author.dart';

class ItemListAuthor extends StatefulWidget {
  final Author author;

  const ItemListAuthor({required this.author, super.key});

  @override
  State<ItemListAuthor> createState() => _ItemListAuthorState();
}

class _ItemListAuthorState extends State<ItemListAuthor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.author.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                widget.author.profit.toBRL(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green),
              ),
              Text('${widget.author.profitInBetUnit.toStringAsFixed(2)}u'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.author.totalBets}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${widget.author.totalGreen}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              Text('${widget.author.totalRed}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              Text('${widget.author.totalOpen}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.yellow)),
              Text('${widget.author.totalVoid}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange)),
              Text('${widget.author.totalCashout}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          )
        ],
      ),
    );
  }
}
