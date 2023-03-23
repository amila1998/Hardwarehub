import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Review.dart';

class ReviewProvider extends ChangeNotifier {
  late CollectionReference _reviewsCollectionRef;

  // private field to store the list of review retrieved from the database
  List<Review> _reviews = [];

  // getter to retrieve the list of reviews
  List<Review> get reviews => _reviews;

  // constructor to initialize the TodoProvider
  ReviewProvider() {
    _reviewsCollectionRef = FirebaseFirestore.instance.collection('reviews');
    _loadreviews();
  }

  // private method to load reviews from the database
  Future<void> _loadreviews() async {
    try {
      //final user = FirebaseAuth.instance.currentUser;
      final snapshot = await _reviewsCollectionRef.get();
      _reviews =
          snapshot.docs.map((doc) => Review.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading Reviews: $e');
    }
  }

  // private method to load reviews by user from the database
  Future<void> loadReviews(String userId) async {
    try {
      final snapshot =
          await _reviewsCollectionRef.where('userId', isEqualTo: userId).get();
      _reviews =
          snapshot.docs.map((doc) => Review.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading Reviews: $e');
    }
  }

  // method to add a new review to the database and _reviews list
  Future<void> addReview(
    String title,
    String description,
    String itemId,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await _reviewsCollectionRef.add({
        'title': title,
        'description': description,
        'itemId': itemId,
        'userId': user!.uid,
      });
      final review = Review(
        userId: user.uid,
        id: docRef.id,
        title: title,
        description: description,
        itemId: itemId,
      );
      _reviews.add(review);
      notifyListeners();
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  // method to update a review in the database and _reviews list
  Future<void> updateReview(Review review) async {
    try {
      await _reviewsCollectionRef.doc(review.id).update(review.toMap());
      _reviews[_reviews.indexWhere((t) => t.id == review.id)] = review;
      notifyListeners();
    } catch (e) {
      print('Error updating review: $e');
    }
  }

  // method to delete a review from the database and _reviews list
  Future<void> deleteReviewById(String id) async {
    try {
      await _reviewsCollectionRef.doc(id).delete();
      _reviews.removeWhere((review) => review.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting review: $e');
    }
  }
}
