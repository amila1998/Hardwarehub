import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Providers/ReviewProvider.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:hardwarehub/Screens/User/Reviews/EditReviewScreen.dart';
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
                    return SizedBox(
                      height: 180,
                      width: 200,
                      child: CustomCard(
                        borderRadius: 10,
                        onTap: () {},
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ItemDetailPage(
                        //               item: item,
                        //             )),
                        //   );
                        // },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                                  Text(
                                    review.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    review.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Item Name :- ' + review.itemName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 131, 141, 143),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => const Icon(
                                        // index < item.ratings ? Icons.star : Icons.star_border,
                                        Icons.star_border,
                                        size: 20.0,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ElevatedButton.icon(
                                              icon: const Icon(Icons.edit),
                                              label: const Text(''),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditReviewScreen(
                                                              review: review)),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      //const SizedBox(width: 10.0),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton.icon(
                                              icon: const Icon(Icons.delete),
                                              label: const Text(''),
                                              onPressed: () {
                                                reviewProvider.deleteReviewById(
                                                    review.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
