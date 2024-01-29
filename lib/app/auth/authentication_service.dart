import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/auth_provider.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:infoapp/app/util/SnackbarUtils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infoapp/app/config/app_config.dart';

class AuthenticationService {
  static Future<void> authenticate({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
      const String apiUrl = AppConfig.apiUrlLogin;
      var message;

      final response = await apiService.post(
        apiUrl,
        {
          'usu_apelido': username,
          'usu_pass': password,
        },
      );

      Navigator.of(context).pop(); // Fechar o diálogo de progresso

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response.data['token']);

        authProvider.login();

        // Navegar para a tela '/home'
        Navigator.pushReplacementNamed(context, '/home');
        SnackbarUtils.exibirSnackbar(context, 'Olá $username !',
            statusCode: response.statusCode);
      } else if (response.statusCode == 408) {
        SnackbarUtils.exibirSnackbar(context, 'Tempo de login expirado');
      } else if (response.statusCode == 422 || response.statusCode == 401) {
        print(response.data);

        if (response.data is Map) {
          // Se for um mapa, verifica se contém 'errors' ou 'message'
          if (response.data.containsKey('errors')) {
            message = response.data['errors'];
          } else if (response.data.containsKey('message')) {
            message = response.data['message'];
          } else {
            // Se não contiver nem 'errors' nem 'message', assume que é uma string direta
            message = response.data.toString();
          }
        } else if (response.data is List) {
          // Se for uma lista, verifica se contém elementos e usa o primeiro como mensagem
          if (response.data.isNotEmpty) {
            message = response.data[0].toString();
          } else {
            message = 'Erro na consulta';
          }
        } else if (response.data is String) {
          // Se for uma string direta, atribui à variável de mensagem
          message = response.data;
        }

        if (message != null) {
          SnackbarUtils.exibirSnackbar(context, message);
        } else {
          SnackbarUtils.exibirSnackbar(
              context, 'Erro interno, tente novamente');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    } catch (error) {
      SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
    }
  }
}

//   static void exibirSnackbar(
//     ScaffoldMessengerState scaffoldMessenger,
//     String mensagem,
//   ) {
//     scaffoldMessenger.showSnackBar(
//       SnackBar(
//         content: Text(mensagem),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

// // authentication_service.dart
// import 'package:flutter/material.dart';
// import 'package:infoapp/app/auth/auth_provider.dart';
// import 'package:infoapp/app/services/api_service.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:infoapp/app/config/app_config.dart';
// import 'dart:async';

// class AuthenticationService {
//   static Future<void> authenticate({
//     required String username,
//     required String password,
//     required BuildContext context,
//   }) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     void exibirSnackbar(String mensagem) {
//       final snackBar = SnackBar(
//         content: Text(mensagem),
//         duration: const Duration(seconds: 3),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }

//     if (username.isEmpty || password.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Campos obrigatórios'),
//             content: const Text('Por favor preencha os campos'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//     const String apiUrl = AppConfig.apiUrlLogin;
//     final apiService = ApiService.create();

//     try {
//       final response = await apiService.post(
//         apiUrl,
//         {
//           'usu_apelido': username,
//           'usu_pass': password,
//         },
//       );
//       // .timeout(
//       //   const Duration(seconds: 15),
//       //   onTimeout: () {
//       //     Navigator.of(context).pop();
//       //     throw TimeoutException('Tempo limite excedido');
//       //   },
//       // );
//       //Navigator.of(context).pop();
//       if (response.statusCode == 200) {
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('token', response.data['token']);

//         authProvider.login();
//         // ignore: use_build_context_synchronously
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       } else if (response.statusCode == 401) {
//         exibirSnackbar('Usuário ou senha inválidos');

//         // contextLocal.showSnackBar(
//         //   const SnackBar(
//         //     content: Text('Usuário ou senha inválidos'),
//         //   ),
//         // );
//       } else if (response.statusCode == 422) {
//         exibirSnackbar('Usuário ainda não registrado');
//       } else {
//         exibirSnackbar('Erro interno,tente novamente');
//       }
//     } catch (error) {
//       exibirSnackbar('Erro interno,tente novamente');
//     }
//   }
// }
