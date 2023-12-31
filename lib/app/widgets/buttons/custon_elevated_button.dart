// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final IconData? icon;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.buttonColor,
    this.textColor,
    this.fontFamily,
    this.fontSize,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: buttonColor ?? Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon), // Adicionando o ícone se estiver definido
              SizedBox(width: 8), // Espaçamento entre o ícone e o texto
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Theme.of(context).colorScheme.secondary,
                fontFamily: fontFamily ?? 'Roboto',
                fontSize: fontSize ?? 20,
                // Adicione esta linha para definir a fonte
              ),
            ),
          ],
        ),
      ),
    );
  }
}
