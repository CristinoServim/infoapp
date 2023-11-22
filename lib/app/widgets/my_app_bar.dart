// app_bar.dart

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final IconData? iconData;

  const MyAppBar({
    required this.titleText,
    this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 25,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.secondary,
      ),
      leading: iconData != null ? Icon(iconData) : null,
    );
  }
}
