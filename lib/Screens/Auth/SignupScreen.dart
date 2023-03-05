// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Screens/Auth/LoginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _role;
  final List<String> _roles = ['Buyer', 'Seller'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              DropdownButtonFormField(
                value: _roles[0],
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              ElevatedButton(
                onPressed: () => _signup(),
                child: const Text('Signup'),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _signupWithGoogle,
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('google_logo.png'),
                  ),
                  label: const Text('Sign up with Google'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // set the button's background color
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final user = userCredential.user!;
        await user.updateDisplayName(_role);
        await user.sendEmailVerification();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: Text('Verification email has been sent to $_email'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  void _signupWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        await user.updateDisplayName('Google User');
        await user.sendEmailVerification();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  Text('Verification email has been sent to ${user.email}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
