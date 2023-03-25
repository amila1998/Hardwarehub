import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:hardwarehub/Screens/Oders/AllOrders.dart';
import 'package:hardwarehub/Screens/User/MySells/MySellsScreen.dart';
import 'package:hardwarehub/Screens/User/ProfileSettingScreen.dart';
import 'package:hardwarehub/Screens/User/Reviews/AddReviewScreen.dart';
import 'package:hardwarehub/Screens/User/Reviews/MyReviewsScreen.dart';
import 'package:hardwarehub/Screens/User/Reviews/ReviewsItemWiseScreen.dart';
import 'package:provider/provider.dart';

import '../Delivery/DeliveryScreen.dart';
import '../Oders/MYOdersScreens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot _userDoc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final User? user = _auth.currentUser;
    final doc = await _firestore.collection('users').doc(user!.uid).get();
    print(doc);
    setState(() {
      _userDoc = doc;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProfileSettingScreen()),
                        );
                      },
                    ),
                  ],
                  leading: CircleAvatar(
                    backgroundImage: _userDoc['photoURL'] != null
                        ? NetworkImage(_userDoc['photoURL'])
                        : null,
                    child: _userDoc['photoURL'] == null ||
                            _userDoc['photoURL'] == ''
                        ? Text(
                            _userDoc['name'] != null
                                ? _userDoc['name'].substring(0, 1).toUpperCase()
                                : '',
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
                    const SizedBox(height: 16),
                    _buildDeliveryColumn(context),
                    const SizedBox(height: 16),
                    // if (_userDoc['role'] == 'deliver')
                    // TODO: Need to show deliver options
                  ]),
                ),
              ],
            ),
    );
  }

  Widget _buildOrderColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
              _buildOrderTile(context, Icons.on_device_training, 'My Oder'),
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
      ),
    );
  }

  Widget _buildOrderTile(BuildContext context, IconData icon, String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            switch (title) {
              case 'My Oder':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyOdersScreens()),
                  );
                }
                break;

              case 'My Reviews':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyReviewsScreen()),
                  );
                }
                break;
            }
          },
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ));
  }

  Widget _buildServiceColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'My Service',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildServiceTile(context, Icons.work, 'My Sells'),
                _buildServiceTile(context, Icons.assignment, 'My Service'),
                _buildServiceTile(context, Icons.message, 'My Messages'),
                _buildServiceTile(context, Icons.payment, 'Payment Option'),
                _buildServiceTile(context, Icons.help, 'Help Center'),
                _buildServiceTile(context, Icons.chat_bubble, 'Chat with Us'),
                _buildServiceTile(context, Icons.star, 'My Reviews'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, IconData icon, String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            switch (title) {
              case 'My Sells':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySellsScreen()),
                  );
                }
                break;

              case 'My Reviews':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyReviewsScreen()),
                  );
                }
                break;
            }
          },
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ));
  }

  Widget _buildDeliveryColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'My Deliveries',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildDeliveryTile(
                  context, Icons.shopping_cart_checkout, 'All Orders'),
              _buildDeliveryTile(
                  context, Icons.local_shipping, 'My Deliveries'),
              _buildDeliveryTile(context, Icons.message, 'My Messages'),
              //_buildDeliveryTile(context, Icons.payment, 'Payment Option'),
              _buildDeliveryTile(context, Icons.help, 'Help Center'),
              _buildDeliveryTile(context, Icons.chat_bubble, 'Chat with Us'),
              _buildDeliveryTile(context, Icons.star, 'My Reviews'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDeliveryTile(BuildContext context, IconData icon, String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            switch (title) {
              case 'All Orders':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllOrders()),
                  );
                }
                break;

              case 'My Deliveries':
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeliveryScreen()),
                  );
                }
                break;
            }
          },
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ));
  }
}
