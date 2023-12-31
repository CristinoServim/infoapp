import 'package:flutter/material.dart';

class NavigationUtils {
  static void navigateToDestination(
      BuildContext context, Widget destination, bool hasPermission) {
    if (hasPermission) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destination,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Você não tem permissão para acessar esta funcionalidade.'),
        ),
      );
    }
  }
}

// class SnackbarUtils {
//   static void exibirSnackbar(BuildContext context, String mensagem,
//       {String? actionText,
//       Color? backgroundColor,
//       Color? actionTextColor,
//       VoidCallback? onPressed}) {
//     String texto = actionText ?? 'Fechar';

//     final scaffold = ScaffoldMessenger.of(context);

//     // Verifica se o contexto é válido e se o widget está montado
//     if (scaffold.mounted) {
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text(
//             mensagem,
//             style: TextStyle(color: Colors.white),
//           ),
//           duration: const Duration(seconds: 3),
//           backgroundColor: backgroundColor ?? Colors.green,
//           action: SnackBarAction(
//             label: texto,
//             textColor:
//                 actionTextColor ?? Theme.of(context).colorScheme.secondary,
//             onPressed: onPressed ??
//                 () {
//                   scaffold.hideCurrentSnackBar();
//                 },
//           ),
//         ),
//       );
//     }
//   }
// }
