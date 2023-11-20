import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/screens/login_page.dart';
import 'package:infoapp/app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _redirected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isLoggedIn && !_redirected) {
      // Aguarda 3 segundos e redireciona para a LoginPage
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

      // Marca que o redirecionamento já ocorreu
      _redirected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Infobrasil",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 25,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          drawer: const AppDrawer(),
          body: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0,
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
        );
      },
    );
  }
}
