import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Item.dart';

class ItemProvider extends ChangeNotifier {
  late CollectionReference _itemsCollectionRef;

  // private field to store the list of items retrieved from the database
  List<Item> _items = [];

// getter to retrieve the list of items
  List<Item> get items => _items;

  // constructor to initialize the TodoProvider
  ItemProvider() {
    _itemsCollectionRef = FirebaseFirestore.instance.collection('items');
    _loaditems();
  }

// private method to load items from the database
  Future<void> _loaditems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot =
          await _itemsCollectionRef.get();
      _items =
          snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }
 

// private method to load items by user from the database
Future<void> loadItems(String userId) async {
  try {
    final snapshot = await _itemsCollectionRef.where('userId', isEqualTo: userId).get();
    _items = snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
    notifyListeners();
  } catch (e) {
    print('Error loading items: $e');
  }
}

// method to add a new todo to the database and _items list
  Future<void> addItem(String name, double price, String description,
      bool isAvailable, String mesurement, int quantity, String itemPhoto) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await _itemsCollectionRef.add({
        'name': name,
        'price': price,
        'description': description,
        'isAvailable': isAvailable,
        'mesurement': mesurement,
        'quantity': quantity,
        'userId': user!.uid,
        'itemPhoto': itemPhoto
      });
      final item = Item(
        userId: user.uid,
        id: docRef.id,
        name: name,
        price: price,
        description: description,
        isAvailable: isAvailable,
        mesurement: mesurement,
        quantity: quantity,
        itemPhoto:itemPhoto,
      );
      _items.add(item);
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  // method to update a todo in the database and _items list
  Future<void> updateItem(Item item) async {
    try {
      await _itemsCollectionRef.doc(item.id).update(item.toMap());
      _items[_items.indexWhere((t) => t.id == item.id)] = item;
      notifyListeners();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

// method to delete a todo from the database and _items list
  Future<void> deleteItemById(String id) async {
    try {
      await _itemsCollectionRef.doc(id).delete();
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}
