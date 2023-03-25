import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hardwarehub/Models/Delivery.dart';
import 'package:hardwarehub/Screens/Delivery/DeliveryScreen.dart';
import 'package:provider/provider.dart';

import '../../Providers/DeliveryProvider.dart';

class DeliveryStatus extends StatefulWidget {
 final Delivery item;

  const DeliveryStatus({required this.item, Key? key}) : super(key: key);

  @override
  State<DeliveryStatus> createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {
 

  @override
  Widget build(BuildContext context) {
     final deliveryProvider = Provider.of<DeliveryProvider>(context);
   void _submitForm() async {
      final id = widget.item.id;
      final orderId = widget.item.orderId;
      final status = "delivery";
      final name = widget.item.name;
      final userId = widget.item.userId;
      final itemId = widget.item.itemId;
      final itemPhoto = widget.item.itemPhoto;

 final updatedItem = Delivery(
          id: id.toString(),
          orderId:orderId,
          status: status,
          name: name,
          userId:userId ,
          itemId: itemId,
          itemPhoto: itemPhoto,
          
        );



      await deliveryProvider.updateDelivery(updatedItem);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>DeliveryScreen()),
      );
    }
   return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.item.itemPhoto,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'status :${widget.item.status}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Description : ${widget.item.description}',
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'Available: ',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       widget.item.isAvailable ? 'Yes' : 'No',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: widget.item.isAvailable
                  //             ? Colors.green
                  //             : Colors.red,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'Measurement: ',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       widget.item.mesurement,
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'Quantity: ',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       '${widget.item.quantity}',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ReviewsItemWiseScreen(
                  //                     item: widget.item,
                  //                   )));
                  //     },
                  //     child: Text(
                  //       ' Reviews ',
                  //       style: TextStyle(
                  //         fontSize: 20.0,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delivery_dining),
        onPressed: _submitForm,
      ),
    );
  }
}