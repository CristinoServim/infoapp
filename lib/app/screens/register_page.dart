// login_page.dart
import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/register_service.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';
    String confirmaSenha = '';
    String apiKey = '';

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                      margin: const EdgeInsets.all(26),
                      child: Padding(
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                username = value;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Usuário'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obrigatório';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: 'Senha'),
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.min(6, 'Mínimo de 6 digitos ')
                              ]),
                            ),
                            TextFormField(
                              onChanged: (value) {
                                confirmaSenha = value;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: 'Confirmar Senha'),
                              validator: (value) {
                                if (value != password) {
                                  return 'As senhas não coincidem';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (value) {
                                apiKey = value;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'API Key'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obrigatório';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  RegisterService.register(
                                    username: username,
                                    password: password,
                                    confirmaSenha: confirmaSenha,
                                    apiKey: apiKey,
                                    context: context,
                                  );
                                }
                              },
                              text: 'Registrar-se',
                              textColor: Theme.of(context).colorScheme.primary,
                              buttonColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
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
      ),
    );
  }
}
