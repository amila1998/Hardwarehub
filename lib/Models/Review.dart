import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String title;
  final String description;
  final int rating;
  final String itemId;
  final String itemName;
  final String userId;
  final String userName;

  Review(
      {required this.id,
      required this.title,
      required this.description,
      required this.rating,
      required this.itemId,
      required this.itemName,
      required this.userId,
      required this.userName});

  factory Review.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Review(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      rating: snapshot['rating'],
      itemId: snapshot['itemId'],
      itemName: snapshot['itemName'],
      userId: snapshot['userId'],
      userName: snapshot['userName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'rating': rating,
      'itemId': itemId,
      'itemName': itemName,
      'userId': userId,
      'userName': userName,
    };
  }
}
