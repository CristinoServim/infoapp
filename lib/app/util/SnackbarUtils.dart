import 'package:flutter/material.dart';

class SnackbarUtils {
  static void exibirSnackbar(BuildContext context, String mensagem,
      {String? actionText,
      int? statusCode,
      Color? backgroundColor,
      Color? actionTextColor,
      Color? messageColor,
      Color? actionTextColorAmarelo,
      Color? actionBackgroundColorAmarelo,
      Color? messageColorOnYellow,
      VoidCallback? onPressed}) {
    String texto = actionText ?? 'Fechar';

    final scaffold = ScaffoldMessenger.of(context);
    Color defaultMessageColor = Colors.white;
    Color defaultActionTextColor = Colors.white;
    Color defaultActionBackgroundColor =
        actionBackgroundColorAmarelo ?? Colors.green;
    Color bgColor = backgroundColor ?? Color.fromARGB(240, 239, 93, 93);

    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      bgColor = Colors.green;
      defaultActionBackgroundColor = actionBackgroundColorAmarelo ??
          const Color.fromARGB(255, 63, 155, 66);
    } else if (statusCode != null && statusCode >= 300 && statusCode < 400) {
      bgColor = Theme.of(context)
          .colorScheme
          .secondary; // Altera para vermelho para outros status
    }

    if (bgColor == Theme.of(context).colorScheme.secondary) {
      defaultMessageColor = messageColorOnYellow ?? Colors.black;
      defaultActionBackgroundColor =
          actionBackgroundColorAmarelo ?? Color.fromARGB(255, 232, 191, 31);
      defaultActionTextColor = Colors.black;
    } else if (bgColor == Colors.green) {
      defaultActionBackgroundColor = actionBackgroundColorAmarelo ??
          const Color.fromARGB(255, 63, 155, 66);
    } else if (bgColor == Color.fromARGB(240, 239, 93, 93)) {
      defaultActionBackgroundColor =
          actionBackgroundColorAmarelo ?? Color.fromARGB(239, 218, 75, 75);
    }

    // Verifica se o contexto é válido e se o widget está montado
    if (scaffold.mounted) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            mensagem,
            style: TextStyle(color: messageColor ?? defaultMessageColor),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: bgColor,
          action: SnackBarAction(
            label: texto,
            textColor: actionTextColor ?? defaultActionTextColor,
            backgroundColor: defaultActionBackgroundColor,
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
