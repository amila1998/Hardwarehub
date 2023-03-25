import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Providers/AuthProvider.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:hardwarehub/Screens/Items/HomePageScreen.dart';
import 'package:hardwarehub/Screens/User/ProfileScreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final ItemProvider _itemProvider = Provider.of<ItemProvider>(context, listen: false);
  static const List<Widget> _pages = <Widget>[
    HomePageScreen(),
    MessagesPage(),
    CartPage(),
    ProfileScreen(),
  ];



  void _onTabSelected(int index) {
    _itemProvider.reloadItems();
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ItemProvider>(context);
    // final authProvider = Provider.of<AuthProvider>(context);
    // final itemProvider = Provider.of<ItemProvider>(context);
    // final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amberAccent,
        onTap: _onTabSelected,
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Messages Page'),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cart Page'),
    );
  }
}
