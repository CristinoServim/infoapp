import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                Center(
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const TextField(
                            decoration: InputDecoration(labelText: 'Usuario'),
                          ),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Senha'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Entrar'))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
