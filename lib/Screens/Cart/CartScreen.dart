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
  int qnt = 1;

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<ItemProvider>(context, listen: false).loaditems();
    Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: cartProvider.cartItems.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return ListTile(
                        leading: Image.network(item.itemPhoto),
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${(item.price)*qnt}'),
                            const SizedBox(height: 4),
                            if(qnt>1)
                            Text('Quantity: $qnt'),
                            if(qnt==1)
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 144,
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OdersScreens(
                                          item: item,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.shopping_bag),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    cartProvider.deleteItemById(item.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {setState(() {
                                     if (qnt > 0) qnt++;
                                  
                                });

                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                       setState(() {
                                     if (qnt > 1) qnt--;
                                  
                                });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // ElevatedButton.icon(
                //   icon: const Icon(Icons.check),
                //   label: const Text('Checkout'),
                //   onPressed: () {},
                // ),
              ],
            )
          : const Placeholder(),
    );
  }
}
