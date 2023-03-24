import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Providers/ReviewProvider.dart';
import 'package:provider/provider.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    reviewProvider.loadReviews(user!.uid);
    int reviewCount = reviewProvider.reviews.length;

    return Scaffold(
        appBar: AppBar(
            title: const Text('My Reviews'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 149, 171, 192),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  ' You have placed $reviewCount Reviews ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: reviewProvider.reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    final review = reviewProvider.reviews[index];
                    return ListTile(
                      hoverColor: Color.fromARGB(255, 140, 140, 167),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      title: Text(
                        review.title,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        review.description,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          reviewProvider.deleteReviewById(review.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
