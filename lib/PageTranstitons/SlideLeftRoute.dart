import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
