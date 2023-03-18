import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hardwarehub/Screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (input) {
              if (input!.isEmpty) {
                return 'Please enter an email address';
              }
            },
            onSaved: (input) => _email = input!,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            obscureText: true,
            validator: (input) {
              if (input!.length < 6) {
                return 'Password must be at least 6 characters long';
              }
            },
            onSaved: (input) => _password = input!,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () => _login(),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password';
            break;
          default:
            errorMessage = 'Login failed. Please try again.';
            break;
        }
        Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: 'Login failed. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
