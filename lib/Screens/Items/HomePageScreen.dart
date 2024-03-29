import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Screens/Items/ItemDetailsPage.dart';
import 'package:hardwarehub/Screens/User/MySells/AddItemScreen.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    Provider.of<ItemProvider>(context, listen: false).loaditems();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).reloadItems();
    });

    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.transparent,
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by item name',
                      border: InputBorder.none,
                      prefixIcon: IconTheme(
                        data: IconThemeData(color: Colors.black),
                        child: Icon(Icons.search),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null || value == '') {
                        Provider.of<ItemProvider>(context, listen: false)
                            .reloadItems();
                      } else {
                        Provider.of<ItemProvider>(context, listen: false)
                            .filterItems(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetailPage(
                                  item: item,
                                )),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: FadeInImage(
                              image: NetworkImage(item.itemPhoto.toString()),
                              placeholder: const AssetImage('logo.png'),
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
        ));
  }
}
