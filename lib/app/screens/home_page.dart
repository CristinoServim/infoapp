import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/screens/vendas/vendas_conferencias/conferencia_venda_screen.dart';
import 'package:infoapp/app/util/navigation_utils.dart';
import 'package:infoapp/app/widgets/app_drawer.dart';
import 'package:infoapp/app/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(titleText: 'Infobrasil'),
      drawer: const AppDrawer(),
      body: Center(
        child: InkWell(
          onTap: () {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            NavigationUtils.navigateToDestination(
              context,
              const ConferenciaVendaScreen(),
              authProvider.hasPermission,
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3.0,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logop.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
