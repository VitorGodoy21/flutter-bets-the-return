import 'package:flutter/material.dart';

class FilterComponent extends StatefulWidget {
  final Future<List<String>> columnsFuture;
  final Function(String? column, String value) onFilterApplied;

  FilterComponent({required this.columnsFuture, required this.onFilterApplied});

  @override
  _FilterComponentState createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  String? selectedColumn;
  String inputValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<String>>(
          future: widget.columnsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Exibe um indicador de carregamento
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar colunas');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Nenhuma coluna disponível');
            }

            List<String> columns = snapshot.data!;

            return DropdownButton<String>(
              hint: Text('Selecione a coluna'),
              value: selectedColumn,
              onChanged: (String? newValue) {
                setState(() {
                  selectedColumn = newValue;
                });
              },
              items: columns.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Valor da coluna',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputValue = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedColumn != null && inputValue.isNotEmpty) {
                    widget.onFilterApplied(selectedColumn, inputValue);
                  } else {
                    print('Selecione uma coluna e insira um valor!');
                  }
                },
                child: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
