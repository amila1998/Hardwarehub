import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final String description;
  final bool isAvailable;
  final String mesurement;
  final int quantity;
  final String userId;

  Item(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.isAvailable,
      required this.mesurement,
      required this.quantity,
      required this.userId});

  factory Item.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Item(
      id: snapshot.id,
      name: snapshot['name'],
      price: snapshot['price'],
      description: snapshot['description'],
      isAvailable: snapshot['isAvailable'],
      mesurement: snapshot['mesurement'],
      quantity: snapshot['quantity'],
      userId: snapshot['userId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'isAvailable': isAvailable,
      'mesurement': mesurement,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
