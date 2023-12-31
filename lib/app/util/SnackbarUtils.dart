import 'package:flutter/material.dart';

class SnackbarUtils {
  static void exibirSnackbar(BuildContext context, String mensagem,
      {String? actionText,
      int? statusCode,
      Color? backgroundColor,
      Color? actionTextColor,
      VoidCallback? onPressed}) {
    String texto = actionText ?? 'Fechar';

    final scaffold = ScaffoldMessenger.of(context);
    Color backgroundColor = Color.fromARGB(240, 239, 93, 93);
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      backgroundColor = Colors.green;
    } else if (statusCode != null && statusCode >= 300 && statusCode < 400) {
      backgroundColor = Theme.of(context)
          .colorScheme
          .secondary; // Altera para vermelho para outros status
    }

    // Verifica se o contexto é válido e se o widget está montado
    if (scaffold.mounted) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            mensagem,
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: backgroundColor,
          action: SnackBarAction(
            label: texto,
            textColor:
                actionTextColor ?? Theme.of(context).colorScheme.secondary,
            onPressed: onPressed ??
                () {
                  scaffold.hideCurrentSnackBar();
                },
          ),
        ),
      );
    }
  }
}
