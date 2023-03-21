import 'package:flutter/material.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class MySellsScreen extends StatelessWidget {
  const MySellsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    itemProvider.loadItems(user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sells'),
        leading: IconButton(icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },)
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: ListView.builder(
          itemCount: itemProvider.items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = itemProvider.items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  itemProvider.deleteItemById(item.id);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Add item screen
        },
      ),
    );
  }
}