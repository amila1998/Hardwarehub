import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyOdersScreens extends StatefulWidget {
  const MyOdersScreens({super.key});

  @override
  State<MyOdersScreens> createState() => _MyOdersScreensState();
}

class _MyOdersScreensState extends State<MyOdersScreens> {
  @override
 List<Map<String, dynamic>> _orders = [
    {'name': 'Order 1', 'date': '2022-01-01', 'status': 'Processing'},
    {'name': 'Order 2', 'date': '2022-01-02', 'status': 'Shipped'},
    {'name': 'Order 3', 'date': '2022-01-03', 'status': 'Delivered'},
    {'name': 'Order 4', 'date': '2022-01-04', 'status': 'Cancelled'},
  ];

  @override
  Widget build(BuildContext context) {
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