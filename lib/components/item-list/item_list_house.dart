import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/double_utils.dart';

import '../../models/houses.dart';

class ItemListHouse extends StatefulWidget {
  final House house;

  const ItemListHouse({required this.house, super.key});

  @override
  State<ItemListHouse> createState() => _ItemListHouseState();
}

class _ItemListHouseState extends State<ItemListHouse> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.house.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Lucro: ${widget.house.profit.toBRL()}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green),
              ),
              Text(
                  'Banca disponivel: ${widget.house.availableBankroll.toBRL()}'),
              Text(
                  'Banca atual: ${(widget.house.initialBankroll + widget.house.profit + widget.house.adjustment + widget.house.bonusCredits - widget.house.withdrawal).toBRL()}'),
              Text('Valor em aberto: ${widget.house.openValue.toBRL()}'),
              Text('Banca inicial: ${widget.house.initialBankroll.toBRL()}'),
              Text('Crédito de Aposta: ${widget.house.bonusCredits.toBRL()}'),
              Text('Ajuste: ${widget.house.adjustment.toBRL()}'),
              Text('Saque: ${widget.house.withdrawal.toBRL()}'),
            ],
          ),
        ),
      ),
    );
  }
}
