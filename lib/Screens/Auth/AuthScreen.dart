import 'package:flutter/material.dart';
import 'package:hardwarehub/Screens/Auth/ForgotPassword.dart';
import 'package:hardwarehub/Screens/Auth/LoginScreen.dart';
import 'package:hardwarehub/Screens/Auth/SignupScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50.0),
                  const SizedBox(
                    height: 150.0,
                    child: Image(
                      image: AssetImage('logo.png'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      children: const [
                        LoginScreen(),
                        SignupScreen(),
                        ForgotPasswordPage(),
                      ],
                    ),
                  ),
                  if (_pageIndex == 0 || _pageIndex == 2)
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text("Haven't a account ? Signup"),
                    ),
                  if (_pageIndex == 1 || _pageIndex == 2)
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Text(_pageIndex == 2
                          ? 'Remember your password ? try to signin '
                          : 'Have an account ? Signin'),
                    ),
                  if (_pageIndex != 2)
                    TextButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        _pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text('Forgot Password'),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
