import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Models/CartItem.dart';
import 'package:hardwarehub/Screens/User/MySells/AddItemScreen.dart';
import 'package:provider/provider.dart';

import '../../Models/Item.dart';
import '../../Providers/CartProvider.dart';
import '../../Providers/ItemProvider.dart';
import '../../Providers/OderProvider.dart';
import '../HomeScreen.dart';
import '../Items/HomePageScreen.dart';

class OdersScreens extends StatefulWidget {
  final CartItem item;

  const OdersScreens({required this.item, Key? key}) : super(key: key);

  @override
  State<OdersScreens> createState() => _OdersScreensState();
}

class _OdersScreensState extends State<OdersScreens> {
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
    Provider.of<OderProvider>(context, listen: false).loadCartItems(user!.uid);
  }

  @override
@override
Widget build(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context);
  final oderProvider = Provider.of<OderProvider>(context);

  void _getOrder() async {
    final name = widget.item.name;
    final price = widget.item.price;
    final quantity = 1;
    final itemId = widget.item.id;
    final status = "pending";
    final itemPhoto = widget.item.itemPhoto;
    await oderProvider.addOder(
      name,
      price,
      quantity,
      itemId,
      status,
      itemPhoto,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Orders'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: Container(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = cartProvider.cartItems[index];
          return CustomCard(
            borderRadius: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: FadeInImage.assetNetwork(
                      image: item.itemPhoto,
                      placeholder: 'logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${item.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            // index < item.ratings ? Icons.star : Icons.star_border,
                            Icons.star_border,
                            size: 20.0,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.delivery_dining),
                              label: const Text('Order'),
                              onPressed: () {
                                _getOrder();
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Remove'),
                              onPressed: () {
                                oderProvider.deleteOderById(item.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

}
