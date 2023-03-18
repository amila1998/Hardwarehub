import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('profileappbarBG.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   // MaterialPageRoute(builder: (context) => const ProfileSettingScreen()),
                  // );
                },
              ),
            ],
            leading: CircleAvatar(
              backgroundImage: _user?.photoURL != null
                  ? NetworkImage(_user!.photoURL!)
                  : null,
              child: _user?.photoURL == null
                  ? Text(
                      _user?.displayName?.substring(0, 1).toUpperCase() ?? '',
                      style: const TextStyle(fontSize: 18),
                    )
                  : null,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              _buildOrderColumn(context),
              const SizedBox(height: 16),
              _buildServiceColumn(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'My Orders',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOrderTile(context, Icons.payment, 'To Pay'),
            _buildOrderTile(context, Icons.local_shipping, 'To Ship'),
            _buildOrderTile(context, Icons.local_mall, 'To Receive'),
            _buildOrderTile(context, Icons.rate_review, 'To Review'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOrderTile(context, Icons.undo, 'My Returns'),
            _buildOrderTile(context, Icons.cancel, 'My Cancellations'),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTile(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        // Navigate to order screen
      },
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildServiceColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'My Service',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.work, 'My Sells'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.assignment, 'My Service'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.message, 'My Messages'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.payment, 'Payment Option'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.help, 'Help Center'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.chat_bubble, 'Chat with Us'),
        const SizedBox(height: 16),
        _buildOrderTile(context, Icons.star, 'My Reviews'),
      ],
    );
  }
}
