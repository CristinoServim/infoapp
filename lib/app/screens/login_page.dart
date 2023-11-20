// login_page.dart
import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/authentication_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
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
                          TextField(
                            onChanged: (value) {
                              username = value;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Usuario'),
                          ),
                          TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Senha'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              AuthenticationService.authenticate(
                                username: username,
                                password: password,
                                context: context,
                              );
                            },
                            child: const Text('Entrar'),
                          ),
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
