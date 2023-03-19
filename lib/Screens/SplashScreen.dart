import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(padding: EdgeInsets.all(20),
          child: Center(
        child: Image.asset('logo.png'),
      ))),
    );
  }
}
