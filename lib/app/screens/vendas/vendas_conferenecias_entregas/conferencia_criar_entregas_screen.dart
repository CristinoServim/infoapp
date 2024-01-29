import 'package:flutter/material.dart';
import 'package:infoapp/app/widgets/my_app_bar.dart';
import 'package:infoapp/app/widgets/forms/vendas/criar_entregas_form.dart';

class ConferenciaCriarEntregasScreen extends StatefulWidget {
  final String numeroVenda;
  const ConferenciaCriarEntregasScreen({Key? key, required this.numeroVenda})
      : super(key: key);

  @override
  ConferenciaCriarEntregasScreenState createState() =>
      ConferenciaCriarEntregasScreenState();
}

class ConferenciaCriarEntregasScreenState
    extends State<ConferenciaCriarEntregasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(titleText: 'Criar Entregas'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: CriarEntregasForm(
            numeroVenda: widget.numeroVenda,
          ),
        ),
      ),
    );
  }
}
