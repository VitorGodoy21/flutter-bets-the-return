import 'package:flutter/material.dart';

class FormBetScreen extends StatefulWidget {
  const FormBetScreen({super.key});

  @override
  State<FormBetScreen> createState() => _FormBetScreenState();
}

class _FormBetScreenState extends State<FormBetScreen> {
  TextEditingController tipDateController = TextEditingController();
  TextEditingController dateEventController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Entrada'),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [Text('Hello World')],
            ),
          )),
    );
  }
}
