import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Item.dart';

class ItemProvider extends ChangeNotifier {
  late CollectionReference _itemsCollectionRef;

  // private field to store the list of items retrieved from the database
  List<Item> _allItems = [];

// getter to retrieve the list of items
  // List<Item> get items => _items;

  // private field to store the list of items currently displayed
  List<Item> _displayedItems = [];

  // getter to retrieve the list of items
  List<Item> get items => _displayedItems;

  // constructor to initialize the TodoProvider
  ItemProvider() {
    _itemsCollectionRef = FirebaseFirestore.instance.collection('items');
  }

  Future<void> reloadItems() async {
    try {
      final snapshot = await _itemsCollectionRef.get();
      _displayedItems =
          snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error reloading items: $e');
    }
  }

// private method to load items from the database
  Future<void> loaditems() async {
    try {
      final snapshot = await _itemsCollectionRef.get();
      _allItems =
          snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
      _displayedItems = _allItems;
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }

// private method to load items by user from the database
  Future<void> loadItemsbyuser(String userId) async {
    try {
      final snapshot =
          await _itemsCollectionRef.where('userId', isEqualTo: userId).get();
      _displayedItems =
          snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  // private method to filter from the database
  Future<void> filterItems(String text) async {
    try {
      final snapshot =
          await _itemsCollectionRef.where('name', isEqualTo: text).get();
      _displayedItems =
          snapshot.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }

// method to add a new todo to the database and _items list
  Future<void> addItem(
      String name,
      double price,
      String description,
      bool isAvailable,
      String mesurement,
      int quantity,
      String itemPhoto) async {
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
        itemPhoto: itemPhoto,
      );
      _allItems.add(item);
      _displayedItems = _allItems;
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  // method to update a todo in the database and _items list
  Future<void> updateItem(Item item) async {
    try {
      await _itemsCollectionRef.doc(item.id).update(item.toMap());
      final index = _allItems.indexWhere((t) => t.id == item.id);
      _allItems[index] = item;
      _displayedItems = _allItems;
      notifyListeners();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

// method to delete a todo from the database and _items list
  Future<void> deleteItemById(String id) async {
    try {
      await _itemsCollectionRef.doc(id).delete();
      _allItems.removeWhere((item) => item.id == id);
      _displayedItems = _allItems;
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}
