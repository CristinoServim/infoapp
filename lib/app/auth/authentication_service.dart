// authentication_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static Future<void> authenticate({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Campos obrigatórios'),
            content: const Text('Por favor preencha os campos'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    final Dio dio = Dio();
    const String apiUrl = 'https://api.infobrasilsistemas.com.br/v1-ibra/login';

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'usu_apelido': username,
          'usu_pass': password,
        },
      );

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response.data['token']);

        // ignore: use_build_context_synchronously
        Provider.of<AuthProvider>(context, listen: false).login();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro na autenticação'),
              content: const Text(
                'Credenciais inválidas. Por favor, tente novamente.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro na autenticação'),
            content: const Text(
              'Erro na autenticação. Por favor, tente novamente.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
