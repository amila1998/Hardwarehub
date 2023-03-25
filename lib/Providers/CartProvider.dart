import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/CartItem.dart';


class CartProvider with ChangeNotifier {

  // final DatabaseReference _database = FirebaseDatabase.instance.reference();
  late CollectionReference _cartCollectionRef;

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;


CartProvider(){
  _cartCollectionRef = FirebaseFirestore.instance.collection('cartItems');
}

Future<void> loadCartItems(String userId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot =
          await _cartCollectionRef.where('userId', isEqualTo: userId).get();
      _cartItems =
          snapshot.docs.map((doc) => CartItem.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }

 Future<void> addCartItem(String name, double price,int quantity,String itemId,String itemPhoto ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await _cartCollectionRef.add({
        'name': name,
        'price': price,
        'quantity': quantity,
        'userId': user!.uid,
        'itemId': itemId,
        'itemPhoto':itemPhoto,
      });
      final cartItems =CartItem(
        id: docRef.id,
        name: name,
        price: price,
        quantity: quantity,
        userId: user.uid,
        itemId:itemId,
        itemPhoto:itemPhoto,
        
      );
      _cartItems.add(cartItems);
      notifyListeners();
    } catch (e) {
      print('Error adding cartItem: $e');
    }
  }

  Future<void> updateItem(CartItem cartItem) async {
    try {
      await _cartCollectionRef.doc(cartItem.id).update(cartItem.toMap());
      _cartItems[_cartItems.indexWhere((t) => t.id == cartItem.id)] = cartItem;
      notifyListeners();
    } catch (e) {
      print('Error updating item: $e');
    }
  }


Future<void> deleteItemById(String id) async {
    try {
      await _cartCollectionRef.doc(id).delete();
      _cartItems.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Function to add an item to the cart
  // void addItemToCart(CartItem item) {
  //   final cartItemRef = _database.child('cart').push();

  //   cartItemRef.set({
  //     'id': cartItemRef.key,
  //     'name': item.name,
  //     'price': item.price,
  //     'quantity': item.quantity,
  //   }).then((_) {
  //     item.id = cartItemRef.key!;
  //     _cartItems.add(item);
  //     notifyListeners();
  //   });
  // }

  // // Function to remove an item from the cart
  // void removeItemFromCart(String itemId) {
  //   final cartItemRef = _database.child('cart/$itemId');

  //   cartItemRef.remove().then((_) {
  //     _cartItems.removeWhere((item) => item.id == itemId);
  //     notifyListeners();
  //   });
  // }

  // // Function to update the quantity of an item in the cart
  // void updateItemQuantity(String itemId, int newQuantity) {
  //   final cartItemRef = _database.child('cart/$itemId');

  //   cartItemRef.update({'quantity': newQuantity}).then((_) {
  //     _cartItems.firstWhere((item) => item.id == itemId).quantity = newQuantity;
  //     notifyListeners();
  //   });
  // }

  // // Function to calculate the total price of all items in the cart
  // double get totalCartPrice {
  //   return _cartItems.fold(
  //       0, (previousValue, item) => previousValue + (item.price * item.quantity));
  // }

  // // Function to clear all items from the cart
  // void clearCart() {
  //   _cartItems.clear();
  //   notifyListeners();
  // }

  // // Function to fetch all cart items from Firebase
  // Future<void> fetchCartItems() async {
  //   final cartItemsSnapshot = await _database.child('cart').once();

  //   final cartItemsMap = cartItemsSnapshot.value ?? {};
  //   final cartItemsList = cartItemsMap.entries
  //       .map((entry) => CartItem(
  //             id: entry.key!,
  //             name: entry.value['name'],
  //             price: entry.value['price'],
  //             quantity: entry.value['quantity'],
  //           ))
  //       .toList();

  //   _cartItems = cartItemsList;
  //   notifyListeners();
  // }
}
