import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Item.dart';
import 'package:provider/provider.dart';
import '../../Providers/CartProvider.dart';
import '../Cart/CartScreen.dart';
import '../User/MySells/AddItemScreen.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;

  const ItemDetailPage({required this.item, Key? key}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    void _submitForm() async {
      final name = widget.item.name;
      final price = widget.item.price;
      final quantity = 1;
      final itemId = widget.item.id;

      print(name);
      print(price);
      print(quantity);
      print(itemId);
      await cartProvider.addCartItem(
          name,
          price,
          quantity,
          itemId,
        );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.id),
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
                    '\$${widget.item.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Available: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.item.isAvailable ? 'Yes' : 'No',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.item.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Measurement: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.item.mesurement,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Quantity: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart_checkout),
        // onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const CartScreen()),
        //   );
        // },
        onPressed: _submitForm,
      ),
    );
  }
}
