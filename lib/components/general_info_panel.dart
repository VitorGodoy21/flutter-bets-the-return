import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/ColorUtils.dart';
import 'package:flutter_bets_the_return/Util/DoubleUtils.dart';

import '../models/houses.dart';

class GeneralInfoPanel extends StatefulWidget {
  final List<House> houses;

  const GeneralInfoPanel({super.key, required this.houses});

  @override
  State<GeneralInfoPanel> createState() => _GeneralInfoPanelState();
}

class _GeneralInfoPanelState extends State<GeneralInfoPanel> {
  double totalProfit = 0;
  bool isListVisible = false;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Lucro:   ',
                  style: const TextStyle(fontSize: 18),
                  children: [
                    TextSpan(
                        text: totalProfit.toBRL(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.profitColor(
                              totalProfit,
                            ))),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isListVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.purple,
                  size: 24.0,
                  semanticLabel: 'Click to open houses profit details',
                ),
                onPressed: () {
                  setState(() {
                    isListVisible = !isListVisible; // Alterna a visibilidade
                  });
                },
              )
            ],
          ),
        ),
        Expanded(
          child: AnimatedOpacity(
            opacity: isListVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Visibility(
                visible: isListVisible,
                child: ListView(
                  children: List.generate(
                    widget.houses.length,
                    (index) {
                      House model = widget.houses[index];
                      return GeneralInfoPanelItemList(house: model);
                    },
                  ),
                )),
          ),
        ),
      ],
    );
  }

  getInfo() {
    double tempTotalProfit = 0;
    for (var house in widget.houses) {
      tempTotalProfit += house.profit;
    }

    setState(() {
      totalProfit = tempTotalProfit;
    });
  }
}

class GeneralInfoPanelItemList extends StatefulWidget {
  final House house;

  const GeneralInfoPanelItemList({super.key, required this.house});

  @override
  State<GeneralInfoPanelItemList> createState() =>
      _GeneralInfoPanelItemListState();
}

class _GeneralInfoPanelItemListState extends State<GeneralInfoPanelItemList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text.rich(
            TextSpan(
              text: '${widget.house.name}: ',
              style: const TextStyle(fontSize: 16),
              children: [
                TextSpan(
                    text: widget.house.profit.toBRL(),
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorUtils.profitColor(widget.house.profit))),
              ],
            ),
          )
          //Text('${widget.house.name}: R\$${widget.house.profit.toBRL()}'),
          ),
    );
  }
}
