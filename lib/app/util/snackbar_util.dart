import 'package:flutter/material.dart';

class SnackbarUtil {
  static void exibirSnackbar(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
