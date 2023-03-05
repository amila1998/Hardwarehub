import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hardwarehub/Screens/Admin/AdminScreen.dart';
import 'package:hardwarehub/Screens/Auth/Home.dart';
import 'package:hardwarehub/Screens/Auth/LoginScreen.dart';
import 'package:hardwarehub/Screens/User/UserScreen.dart';
import 'package:hardwarehub/firebase_options.dart';


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
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final User user = snapshot.data!;
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
                final String role = data?['role'] ?? '';
                return role == 'Buyer'
                    ? AdminScreen(user: user)
                    : UserScreen(user: user);
              },
            );
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (BuildContext context) => const LoginScreen(),
        '/home': (BuildContext context) => const MyApp(),
      },
    );
  }
}
