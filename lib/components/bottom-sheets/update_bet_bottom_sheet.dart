import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/double_utils.dart';

import '../../models/bet.dart';
import '../../themes/theme_colors.dart';
import '../money_text_field.dart';

class UpdateBetBottomSheet extends StatefulWidget {
  final Bet bet;

  const UpdateBetBottomSheet({required this.bet, super.key});

  @override
  State<UpdateBetBottomSheet> createState() => _UpdateBetBottomSheetState();
}

class _UpdateBetBottomSheetState extends State<UpdateBetBottomSheet> {
  String? selectedStatus;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _valuexoddController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus =
        widget.bet.status;

    _valuexoddController.text = widget.bet.valueXOdd.toBRL();
  }

  @override
  void dispose() {
    // Libera o controlador ao finalizar
    _valuexoddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3, // Altura mínima (30%)
      maxChildSize: 0.9, // Altura máxima (90%)
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    'id: ${widget.bet.id}',
                    style: const TextStyle(fontSize: 14, color: Colors.black38),
                    showCursor: true,
                    cursorWidth: 2,
                    cursorColor: Colors.blue,
                    cursorRadius: Radius.circular(5),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 2, color: ThemeColors.backgroundItemBetColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: MoneyTextField(value: widget.bet.value),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          alignment: Alignment.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: selectedStatus == 'Aberto'
                                ? Colors.yellow[300]
                                : selectedStatus == 'Green'
                                ? Colors.green[300]
                                : selectedStatus == 'Red'
                                ? Colors.red[600]
                                : selectedStatus == 'Anulado'
                                ? Colors.orange[100]
                                : selectedStatus == 'Cashout'
                                ? Colors.blue[100]
                                : Colors.black12,
// Cor de fundo do dropdown
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
// Bordas arredondadas
                              borderSide: BorderSide.none, // Sem borda visível
                            ),
                          ),
                          items: <String>[
                            'Aberto',
                            'Green',
                            'Red',
                            'Anulado',
                            'Cashout'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          },
                          hint: const Text('Status'),
                          style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      updateBet(_valuexoddController.text, selectedStatus);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void updateBet(String valueString, String? status){
    double updatedValue = double.parse(valueString.substring(3).replaceAll(',', ".").trim());
    String updatedStatus = (status != null)? status : widget.bet.status;
    firestore.collection(Bet.FIREBASE_TABLE_NAME).doc(widget.bet.id).set(widget.bet.toFirebaseMap(updatedValue, updatedStatus));
  }
}
