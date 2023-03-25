import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Screens/User/MySells/AddItemScreen.dart';
import 'package:hardwarehub/Screens/User/MySells/EditItemScreen.dart';
import 'package:provider/provider.dart';

class MySellsScreen extends StatefulWidget {
  const MySellsScreen({Key? key}) : super(key: key);

  @override
  _MySellsScreenState createState() => _MySellsScreenState();
}

class _MySellsScreenState extends State<MySellsScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<ItemProvider>(context, listen: false)
        .loadItemsbyuser(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Sells'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Consumer<ItemProvider>(
        builder: (context, itemProvider, _) => Container(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
            ),
            itemCount: itemProvider.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = itemProvider.items[index];
              return SizedBox(
                height: 300,
                width: 200,
                child: CustomCard(
                  borderRadius: 10,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              ),
                            ),
                            Text(
                              '\$${item.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            FittedBox(
                              child: Row(
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
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: const Text(''),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditItemScreen(item: item)),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.delete),
                                    label: const Text(''),
                                    onPressed: () {
                                      itemProvider.deleteItemById(item.id);
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
        },
      ),
    );
  }
}
