import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  final String id;
  final String orderId;
  final String status;
  final String name;
  final String userId;
  final String itemId;
  final String itemPhoto;

  Delivery({
    required this.id,
    required this.orderId,
    required this.status,
    required this.name,
    required this.userId,
    required this.itemId,
    required this.itemPhoto,
  });

  factory Delivery.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Delivery(
      id: snapshot.id,
      orderId: snapshot['orderId'],
      status: snapshot['status'],
      name: snapshot['name'],
      userId: snapshot['userId'],
      itemId: snapshot['itemId'],
      itemPhoto: snapshot['itemPhoto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'status': status,
      'name': name,
      'userId': userId,
      'itemId': itemId,
      'itemPhoto': itemPhoto,
    };
  }
}
