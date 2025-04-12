import 'package:flutter/material.dart';
import 'package:infoapp/app/widgets/forms/vendas/vendas_conferenciav1_form.dart';
import 'package:infoapp/app/widgets/my_app_bar.dart';

class ConferenciaVendaScreen extends StatefulWidget {
  const ConferenciaVendaScreen({Key? key}) : super(key: key);

  @override
  ConferenciaVendaScreenState createState() => ConferenciaVendaScreenState();
}

class ConferenciaVendaScreenState extends State<ConferenciaVendaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(titleText: 'Conferencia'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: VendasConferenciaV1Form(),
        ),
      ),
    );
  }
}
