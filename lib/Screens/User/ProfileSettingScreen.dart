import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Screens/Auth/AuthScreen.dart';
import 'package:hardwarehub/Screens/Auth/LoginScreen.dart';


class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        leading: IconButton(icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildServiceColumn(
                  context,
                  'Account Information',
                  Icons.person,
                ),
                buildServiceColumn(
                  context,
                  'Address Book',
                  Icons.book,
                ),
                buildServiceColumn(
                  context,
                  'Messages',
                  Icons.message,
                ),
                buildServiceColumn(
                  context,
                  'Country',
                  Icons.flag,
                ),
                buildServiceColumn(
                  context,
                  'Language',
                  Icons.language,
                ),
                buildServiceColumn(
                  context,
                  'General',
                  Icons.settings,
                ),
                buildServiceColumn(
                  context,
                  'Policies',
                  Icons.policy,
                ),
              ],
            ),
            buildServiceColumn(
              context,
              'Logout',
              Icons.exit_to_app,
              textColor: Colors.red,
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const AuthScreen(),
                    ),
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceColumn(BuildContext context, String title, IconData icon,
      {Color textColor = Colors.black,
      VoidCallback? onPressed,
      double iconSize = 28.0}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
            ),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
