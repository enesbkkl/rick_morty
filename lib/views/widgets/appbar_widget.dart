import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty/app/router.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool transparentBackground;
  final bool hideSettings;
  const AppBarWidget({
    super.key,
    required this.title,
    this.transparentBackground = false,
    this.hideSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: transparentBackground ? Colors.transparent : null,
      title: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      actions: [
        if (!hideSettings)
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: Icon(Icons.settings),
          ),
      ],
    );
  }

  //Custom AppBar yapmak için PreferredSize classından implement edildi ve 56 yükseklik girildi
  @override
  Size get preferredSize => Size.fromHeight(56);
}
