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
    // var revs = reviewProvider.loadReviews(user!.uid);
    // print(revs);

    return Scaffold(
      appBar: AppBar(
          title: const Text('My Reviews'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: ListView.builder(
          itemCount: reviewProvider.reviews.length,
          itemBuilder: (BuildContext context, int index) {
            final review = reviewProvider.reviews[index];
            return ListTile(
              title: Text(review.title),
              subtitle: Text(review.description),
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hardwarehub/Providers/ReviewProvider.dart';
// import 'package:provider/provider.dart';

// class MyReviewsScreen extends StatefulWidget {
//   @override
//   _ReviewListScreenState createState() => _ReviewListScreenState();
// }

// class _ReviewListScreenState extends State<MyReviewsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final reviewProvider = Provider.of<ReviewProvider>(context);
//     final user = FirebaseAuth.instance.currentUser;
//     reviewProvider.loadReviews(user!.uid);
//     var revs = reviewProvider.loadReviews(user!.uid);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Reviews'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           List<QueryDocumentSnapshot> reviews = snapshot.data!.docs;

//           // if (revs.isEmpty) {
//           //   return Center(
//           //     child: Text('You have not written any reviews yet.'),
//           //   );
//           // }

//           return ListView.builder(
//             itemCount: reviewProvider.reviews.length,
//             itemBuilder: (BuildContext context, int index) {
//               final review = reviewProvider.reviews[index];
//               return ListTile(
//                 title: Text(review.title),
//                 subtitle: Text(review.description),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () {
//                     // reviewProvider.deleteReviewById(review.id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MyReviewsScreen extends StatefulWidget {
//   @override
//   _MyReviewsScreenState createState() => _MyReviewsScreenState();
// }

// class _MyReviewsScreenState extends State<MyReviewsScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final user = FirebaseAuth.instance.currentUser;

//   List<QueryDocumentSnapshot> _reviews = [];

//   @override
//   void initState() {
//     super.initState();
//     _getUser();
//   }

//   void _getUser() async {
//     if (user != null) {
//       _getReviews();
//     }
//   }

//   void _getReviews() async {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('reviews')
//         .where('userId', isEqualTo: user!.uid)
//         .get();

//     setState(() {
//       _reviews = querySnapshot.docs;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Reviews'),
//       ),
//       body: user == null
//           ? Center(child: CircularProgressIndicator())
//           : _reviews.isEmpty
//               ? Center(child: Text('No reviews found.'))
//               : ListView.builder(
//                   itemCount: _reviews.length,
//                   itemBuilder: (context, index) {
//                     Map<String, dynamic> data =
//                         _reviews[index].data() as Map<String, dynamic>;

//                     return ListTile(
//                       title: Text(data['title']),
//                       subtitle: Text(data['description']),
//                       trailing: Text(data['rating'].toString()),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hardwarehub/Providers/ReviewProvider.dart';
// import 'package:provider/provider.dart';

// class MyReviewsScreen extends StatelessWidget {
//   const MyReviewsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final reviewProvider = Provider.of<ReviewProvider>(context);
//     final user = FirebaseAuth.instance.currentUser;
//     reviewProvider.loadReviews(user!.uid);
//     //var revs = reviewProvider.loadReviews(user.uid);
//     //print(revs);

//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('My Sells'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           )),
//       // ignore: avoid_unnecessary_containers
//       body: Container(
//         child: ListView.builder(
//           itemCount: reviewProvider.reviews.length,
//           itemBuilder: (BuildContext context, int index) {
//             final review = reviewProvider.reviews[index];
//             return ListTile(
//               title: Text(review.title),
//               subtitle: Text(review.description),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () {
//                   reviewProvider.deleteReviewById(review.id);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   child: const Icon(Icons.add),
//       //   onPressed: () {
//       //       Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                         builder: (context) =>
//       //                             AddItemScreen()),
//       //                   );
//       //   },
//       // ),
//     );
//   }
// }
