import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Screens/Delivery/DeliveryScreen.dart';
import 'package:provider/provider.dart';

import '../../Providers/CartProvider.dart';
import '../../Providers/DeliveryProvider.dart';
import '../../Providers/OderProvider.dart';
import '../HomeScreen.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    // Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
    Provider.of<OderProvider>(context, listen: false).loadAllOder();
  }

  @override
  Widget build(BuildContext context) {
    final oderProvider = Provider.of<OderProvider>(context);
    final deliveryProvider = Provider.of<DeliveryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
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
          itemCount: oderProvider.oder.length,
          itemBuilder: (BuildContext context, int index) {
            final item = oderProvider.oder[index];
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
                                label: const Text('pickup oder'),
                                onPressed: () {
                                  final orderId = item.id;
                                  final status = "pending";
                                  final name = item.name;
                                  final userId = item.userId;
                                  final itemId = item.itemId;
                                  final itemPhoto = item.itemPhoto;

                                  deliveryProvider.addDelivery(
                                    orderId,
                                    status,
                                    name,
                                    userId,
                                    itemId,
                                    itemPhoto
                                    
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            // Expanded(
                            //   child: ElevatedButton.icon(
                            //     icon: const Icon(Icons.delete),
                            //     label: const Text('Remove'),
                            //     onPressed: () {
                            //       oderProvider.deleteOderById(item.id);
                            //     },
                            //   ),
                            // ),
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
