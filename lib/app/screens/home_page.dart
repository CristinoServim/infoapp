import 'package:flutter/material.dart';
import 'package:infoapp/app/screens/login_page.dart';
import 'package:infoapp/app/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text("Welcome to the Home Page"),
      ),
    );
  }
}
