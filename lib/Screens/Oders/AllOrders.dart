import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Screens/Delivery/DeliveryScreen.dart';
import 'package:provider/provider.dart';

import '../../Providers/CartProvider.dart';
import '../../Providers/OderProvider.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
    Provider.of<OderProvider>(context, listen: false).loadAllOder();
}
  @override
  Widget build(BuildContext context) {
    final oderProvider = Provider.of<OderProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Orders'),
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
          itemCount: oderProvider.oder.length,
          itemBuilder: (BuildContext context, int index) {
            final item = oderProvider.oder[index];
            return SizedBox(
              height: 300,
              width: 200,
              child: CustomCard(
                borderRadius: 10,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                                  icon: const Icon(Icons.delivery_dining),
                                  label: const Text(''),
                                  onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryScreen(
                              
                            )),
                  );
 }
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text(''),
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
  // ),
);
  }
}