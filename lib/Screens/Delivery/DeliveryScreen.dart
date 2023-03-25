import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Models/Oder.dart';
import 'package:hardwarehub/Screens/Delivery/DeliveryStatus.dart';
import 'package:provider/provider.dart';
import 'package:hardwarehub/Providers/DeliveryProvider.dart';


import '../../Providers/OderProvider.dart';

class DeliveryScreen extends StatefulWidget {
  // final Oder item;
  // const DeliveryScreen({required this.item, Key? key}) : super(key:key)
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    // Provider.of<CartProvider>(context, listen: false).loadCartItems(user!.uid);
    Provider.of<DeliveryProvider>(context, listen: false).loaddeliveries();
    Provider.of<OderProvider>(context, listen: false).loadAllOder();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final oderProvider = Provider.of<OderProvider>(context);
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
          itemCount: deliveryProvider.deliveries.length,
          itemBuilder: (BuildContext context, int index) {
            final item = deliveryProvider.deliveries[index];
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
                      // child: FadeInImage.assetNetwork(
                      //   image: item.itemPhoto,
                      //   placeholder: 'logo.png',
                      //   fit: BoxFit.cover,
                      // ),
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
                          item.status,
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
                                  label: const Text('set delivery'),
                                  onPressed: () {
                                    Navigator.push(
                                              context,
                                         MaterialPageRoute(
                                           builder: (context) => DeliveryStatus(
                                              item: item,
                                            )),
                                          );

                                  }),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Remove'),
                                onPressed: () {
                                  deliveryProvider.deleteDeliveryById(item.id);
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
