import 'package:flutter/material.dart';
import 'package:infoapp/app/app_widget.dart';
import 'package:infoapp/app/themes/app_theme_data.dart';
import 'package:provider/provider.dart';

class AppModule extends StatelessWidget {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => Object(),
        )
      ],
      child: MaterialApp(
        title: 'InfoConferencia',
        theme: AppTheme.lightTheme,
        home: const AppWidget(),
      ),
    );
  }
}
