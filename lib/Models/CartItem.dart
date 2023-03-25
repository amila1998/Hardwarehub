import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String userId;
  final String itemId;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.userId,
    required this.itemId,
  });

  factory CartItem.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return CartItem(
      id: snapshot.id,
      name: snapshot['name'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      userId: snapshot['userId'],
      itemId: snapshot['itemId'],
    );
  }
 Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
       'userId': userId,
      'itemId': itemId,
    };
  }
 
}
