import 'package:cloud_firestore/cloud_firestore.dart';

class Oder {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String userId;
  final String itemId;
  final String status;
  final String itemPhoto;

  Oder({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.userId,
    required this.itemId,
    required this.status,
    required this.itemPhoto,
  });

  factory Oder.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Oder(
      id: snapshot.id,
      name: snapshot['name'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      userId: snapshot['userId'],
      itemId: snapshot['itemId'],
      status: snapshot['status'],
      itemPhoto: snapshot['itemPhoto'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'userId': userId,
      'itemId': itemId,
      'status': status,
      'itemPhoto':itemPhoto,
    };
  }
}
