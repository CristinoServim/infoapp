import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/config/app_keys.dart';
import 'package:infoapp/app/screens/vendas/vendas_conferencias/conferencia_venda_screen.dart';
import 'package:infoapp/app/screens/home_page.dart';
import 'package:infoapp/app/screens/auth/login_page.dart';
import 'package:infoapp/app/screens/auth/register_page.dart';
import 'package:infoapp/app/screens/splash_screen.dart';
import 'package:infoapp/app/themes/app_theme_data.dart';
import 'package:provider/provider.dart';

class AppModule extends StatelessWidget {
  const AppModule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Adicione outros providers conforme necessário
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'InfoConferencia',
        theme: AppTheme.lightTheme,
        initialRoute: '/splash', // Inicia com a tela de splash
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomePage(),
          '/conferencia': (context) => const ConferenciaVendaScreen(),
          '/login': (context) => LoginPage(),
          '/registro': (context) => RegisterPage(),
        },
      ),
    );
  }
}
