import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String title;
  final String description;
  final String itemId;
  final String userId;

  Review(
      {required this.id,
      required this.title,
      required this.description,
      required this.itemId,
      required this.userId});

  factory Review.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Review(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      itemId: snapshot['itemId'],
      userId: snapshot['userId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'itemId': itemId,
      'userId': userId,
    };
  }
}
