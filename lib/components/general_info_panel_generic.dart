import 'package:flutter/material.dart';
import 'package:flutter_bets_the_return/Util/ColorUtils.dart';
import 'package:flutter_bets_the_return/Util/DoubleUtils.dart';

class GeneralInfoPanelGeneric<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) nameBuilder;
  final double Function(T) valueBuilder;
  final String title;

  const GeneralInfoPanelGeneric({
    super.key,
    required this.items,
    required this.nameBuilder,
    required this.valueBuilder,
    required this.title,
  });

  @override
  State<GeneralInfoPanelGeneric> createState() =>
      _GeneralInfoPanelGenericState();
}

class _GeneralInfoPanelGenericState<T> extends State<GeneralInfoPanelGeneric> {
  bool isListVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double total =
        widget.items.fold(0.0, (sum, item) => sum + widget.valueBuilder(item));

    return IntrinsicHeight(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${widget.title}:   ',
                      style: const TextStyle(fontSize: 18),
                      children: [
                        TextSpan(
                            text: total.toBRL(),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.profitColor(
                                  total,
                                ))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isListVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.purple,
                      size: 24.0,
                      semanticLabel: 'Click to open houses profit details',
                    ),
                    onPressed: () {
                      setState(() {
                        isListVisible =
                            !isListVisible; // Alterna a visibilidade
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
                  child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      T item = widget.items[index];
                      return GeneralInfoPanelItemList(
                          name: widget.nameBuilder(item),
                          value: widget.valueBuilder(item));
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
}

class GeneralInfoPanelItemList extends StatefulWidget {
  final String name;
  final double value;

  const GeneralInfoPanelItemList(
      {super.key, required this.name, required this.value});

  @override
  State<GeneralInfoPanelItemList> createState() =>
      _GeneralInfoPanelItemListState();
}

class _GeneralInfoPanelItemListState extends State<GeneralInfoPanelItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text.rich(
              TextSpan(
                text: '${widget.name}: ',
                style: const TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                      text: widget.value.toBRL(),
                      style: TextStyle(
                          fontSize: 18,
                          color: ColorUtils.profitColor(widget.value))),
                ],
              ),
            )
            ),
      ),
    );
  }
}
