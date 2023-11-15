import 'package:flutter/material.dart';
import 'package:infoapp/app/screens/login_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Color.fromARGB(255, 162, 161, 161),
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context); // Fecha o menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          // Adicione outros itens do menu aqui
        ],
      ),
    );
  }
}
