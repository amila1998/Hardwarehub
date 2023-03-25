import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Screens/User/MySells/AddItemScreen.dart';
import 'package:provider/provider.dart';
import '../../Models/Item.dart';
import '../../Providers/CartProvider.dart';
import '../Oders/OdersScreens.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<ItemProvider>(context, listen: false).loaditems();
    Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);





    
    return Scaffold(
      appBar: AppBar(
          title: const Text('My cart'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
          ),
          itemCount: cartProvider.cartItems.length,
          itemBuilder: (BuildContext context, int index) {
            final item = cartProvider.cartItems[index];
            return SizedBox(
              height: 300,
              width: 200,
              child: CustomCard(
                borderRadius: 10,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Expanded(
                    //   child: ClipRRect(
                    //     borderRadius: const BorderRadius.only(
                    //       topLeft: Radius.circular(10),
                    //       topRight: Radius.circular(10),
                    //     ),
                    //     child: FadeInImage.assetNetwork(
                    //       image: item.itemPhoto,
                    //       placeholder: 'logo.png',
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
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
                            ),
                          ),
                          Text(
                            '\$${item.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Quantity :${item.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
                                  icon: const Icon(Icons.backpack),
                                  label: const Text('oder item'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               OdersScreens(
                                               item:item
                                              )),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('remove the cart'),
                                  onPressed: () {
                                    cartProvider.deleteItemById(item.id);
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
              ),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddItemScreen()),
      //     );
      //   },
      // ),
    );
  }
}
