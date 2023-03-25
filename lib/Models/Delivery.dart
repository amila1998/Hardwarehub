import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  final String id;
  final String orderId;
  final String status;

  Delivery({
    required this.id,
    required this.orderId,
    required this.status,
  });

  factory Delivery.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Delivery(
      id: snapshot.id,
      orderId: snapshot['orderId'],
      status: snapshot['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'status': status,
    };
  }
}
