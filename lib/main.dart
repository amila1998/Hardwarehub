import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hardwarehub/PageTranstitons/MyPageTransitionsTheme.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:hardwarehub/Screens/Auth/AuthScreen.dart';
import 'package:hardwarehub/Screens/Auth/LoginScreen.dart';
import 'package:hardwarehub/Screens/HomeScreen.dart';
import 'package:hardwarehub/firebase_options.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (_) => ItemProvider(),
            child: const MaterialApp(
              title: 'Hardware Hub',
              home: HomeScreen(),
            ),
          );
        } else {
          return  MaterialApp(
            title: 'Hardware Hub',
            theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: MyPageTransitionsTheme(),
            TargetPlatform.android: MyPageTransitionsTheme(),
            TargetPlatform.fuchsia: MyPageTransitionsTheme(),
            TargetPlatform.windows:MyPageTransitionsTheme(),
          },
        ),
      ),
            home: const AuthScreen(),
          );
        }
      },
    );
  }
}
