import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/screens/conferencia_venda_screen.dart';
import 'package:infoapp/app/screens/login_page.dart';
import 'package:infoapp/app/util/navigation_utils.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    // final Color drawerHeaderColor = Theme.of(context).primaryColor;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.login,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.primary,
                fontSize: 19,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Conferência',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.primary,
                fontSize: 19,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o menu
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              NavigationUtils.navigateToDestination(context,
                  const ConferenciaVendaScreen(), authProvider.hasPermission);
            },
          ),
          // Adicione outros itens do menu aqui
        ],
      ),
    );
  }
}
