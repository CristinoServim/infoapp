import 'package:flutter/material.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:infoapp/app/config/app_config.dart';

class RegisterService {
  static Future<void> register({
    required String username,
    required String password,
    required String confirmaSenha,
    required String apiKey,
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
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Mostrar CircularProgressIndicator enquanto aguarda a conclusão do Future
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final apiService = ApiService.create();
      const String apiUrl = AppConfig.apiUrlSignup;

      final response = await apiService.post(
        apiUrl,
        {
          'usu_apelido': username,
          'usu_pass': password,
          'confirma_senha': confirmaSenha,
          'apikey': apiKey
        },
      );

      // print('Response Status Code: ${response.statusCode}');

      Navigator.of(context).pop(); // Fechar o diálogo de progresso

      List<String> errors = [];
      var message = '';

      if (response.data.containsKey('message')) {
        message = response.data['message'];
      }

      if (response.data.containsKey('errors')) {
        errors = List<String>.from(response.data['errors']);
      }

      if (errors.isNotEmpty) {
        message = errors.join(', ');
      }

      if (response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          // ignore: unused_local_variable
          var usuCodigo = response.data['usu_codigo'] ?? 0;
          // ignore: unused_local_variable
          var usuApelido = response.data['usu_apelido'] ?? '';
        }
        // Navegar para a tela '/home'
        Navigator.pushReplacementNamed(context, '/login');

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado com sucesso !'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response.statusCode >= 200 && response.statusCode <= 500) {
        if (response.statusCode >= 200) {
          if (message.isNotEmpty) {
            exibirSnackbar(scaffoldMessenger, message);
          } else {
            exibirSnackbar(scaffoldMessenger, 'Entre em contato com o suporte');
          }
        } else if (response.statusCode == 401) {
          if (message.isNotEmpty) {
            exibirSnackbar(scaffoldMessenger, message);
          } else {
            exibirSnackbar(scaffoldMessenger, 'Acesso negado');
          }
        } else if (response.statusCode == 408) {
          if (message.isNotEmpty) {
            exibirSnackbar(scaffoldMessenger, message);
          } else {
            exibirSnackbar(scaffoldMessenger, 'Tempo expirado');
          }
        } else if (response.statusCode == 422) {
          if (message.isNotEmpty) {
            exibirSnackbar(scaffoldMessenger, message);
          } else {
            exibirSnackbar(scaffoldMessenger, 'Nome de usuário já utilizado');
          }
        } else if (response.statusCode == 500) {
          if (message.isNotEmpty) {
            exibirSnackbar(scaffoldMessenger, message);
          } else {
            exibirSnackbar(
                scaffoldMessenger, 'Erro no servidor, tente novamente');
          }
        } else {
          exibirSnackbar(scaffoldMessenger, 'Erro interno, tente novamente');
        }
      } else {
        exibirSnackbar(scaffoldMessenger, 'Erro interno, tente novamente');
      }
    } catch (error) {
      exibirSnackbar(scaffoldMessenger, 'Erro interno, tente novamente');
    }
  }

  static void exibirSnackbar(
    ScaffoldMessengerState scaffoldMessenger,
    String mensagem,
  ) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
