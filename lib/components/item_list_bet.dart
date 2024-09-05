import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/DoubleUtils.dart';
import 'package:flutter_bets_the_return/models/bet.dart';
import 'package:flutter_bets_the_return/themes/theme_colors.dart';

class ItemListBet extends StatefulWidget {
  final Bet bet;

  const ItemListBet({required this.bet, super.key});

  @override
  State<ItemListBet> createState() => _ItemListBetState();
}

class _ItemListBetState extends State<ItemListBet> {
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(
                      text: 'Aposta: ',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: widget.bet.tipDate,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                    Text.rich(TextSpan(
                      text: 'Evento: ',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: widget.bet.eventDate,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Text(
                  widget.bet.homeTeam == "-" || widget.bet.visitingTeam == "-"
                      ? "* Multiplos Times *"
                      : '${widget.bet.homeTeam} x ${widget.bet.visitingTeam}',
                  style: const TextStyle(
                      color: ThemeColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Text(widget.bet.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              // Container with bet values
              Container(
                decoration: BoxDecoration(
                  color: ThemeColors.backgroundItemBetColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 2, color: ThemeColors.backgroundItemBetColor),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aposta',
                            style: TextStyle(
                              color: ThemeColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            widget.bet.value.toBRL(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ThemeColors.textColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ODDx',
                            style: TextStyle(
                              color: ThemeColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${widget.bet.odd}',
                            style: const TextStyle(
                              color: ThemeColors.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prêmio',
                            style: TextStyle(
                              color: ThemeColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            widget.bet.valueXOdd.toBRL(),
                            style: const TextStyle(
                              color: ThemeColors.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.bet.status == 'Aberto'
                        ? Colors.yellow[300]
                        : widget.bet.status == 'Green'
                            ? Colors.green[300]
                            : widget.bet.status == 'Red'
                                ? Colors.red[600]
                                : widget.bet.status == 'Anulado'
                                    ? Colors.orange[100]
                                    : widget.bet.status == 'Cashout'
                                        ? Colors.blue[100]
                                        : Colors.black38,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.bet.status,
                              style: TextStyle(
                                  color: widget.bet.status == 'Aberto'
                                      ? Colors.black38
                                      : widget.bet.status == 'Green'
                                          ? Colors.white
                                          : widget.bet.status == 'Red'
                                              ? Colors.white
                                              : widget.bet.status == 'Anulado'
                                                  ? Colors.orange[300]
                                                  : widget.bet.status ==
                                                          'Cashout'
                                                      ? Colors.blue[300]
                                                      : Colors.black38,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
