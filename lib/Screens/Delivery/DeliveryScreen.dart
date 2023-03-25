import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Oder.dart';
import 'package:provider/provider.dart';
import 'package:hardwarehub/Providers/DeliveryProvider.dart';
import 'package:hardwarehub/models/delivery.dart';

class DeliveryScreen extends StatefulWidget {
  // final Oder item;
  // const DeliveryScreen({required this.item, Key? key}) : super(key:key)
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  TextEditingController _orderIdController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  @override
  void dispose() {
    _orderIdController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _orders = [
    {'name': 'Order 1', 'date': '2022-01-01', 'status': 'Processing'},
    {'name': 'Order 2', 'date': '2022-01-02', 'status': 'Shipped'},
    {'name': 'Order 3', 'date': '2022-01-03', 'status': 'Delivered'},
    {'name': 'Order 4', 'date': '2022-01-04', 'status': 'Cancelled'},
];

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          final order = _orders[index];
          return Card(
            child: ListTile(
              title: Text(order['name']),
              subtitle: Text(order['date']),
              trailing: Text(order['status']),
            ),
          );
        },
),
);
  }
}