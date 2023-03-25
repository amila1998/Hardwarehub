import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarehub/Models/Item.dart';
import 'package:hardwarehub/Providers/AuthProvider.dart';
import 'package:hardwarehub/Providers/ReviewProvider.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  final Item item;

  const AddReviewScreen({required this.item, Key? key}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReviewScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot _userDoc;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final User? user = _auth.currentUser;
    final doc = await _firestore.collection('users').doc(user!.uid).get();
    //print(doc);
    setState(() {
      _userDoc = doc;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
    final reviewProvider = Provider.of<ReviewProvider>(context);
    void _submitForm() async {
      final form = _formKey.currentState;

      if (form != null && form.validate()) {
        // get the values entered by the user
        final title = _titleController.text;
        final description = _descriptionController.text;
        final rating = int.parse(_ratingController.text);
        final itemId = widget.item.id;
        final itemName = widget.item.name;
        final userName = _userDoc['name'];
        //print(userName);
        // add the new item to the database
        await reviewProvider.addReview(
            title, description, itemId, rating, itemName, userName);

        // clear the form
        _titleController.clear();
        _descriptionController.clear();
        _ratingController.clear();

        // navigate back to the item list screen
        Navigator.pop(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: Text('Add Review'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            controller: _titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a title for the review';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Description'),
                              controller: _descriptionController,
                              maxLines: 3,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a description';
                                }
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: const InputDecoration(
                                labelText: 'Rating(Out of 5)'),
                            controller: _ratingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter rating(Out of 5) for the review';
                              }
                              final number = int.tryParse(value);
                              if (number == null) {
                                return 'Please enter a valid number';
                              }
                              if (number < 1 || number > 5) {
                                return 'Please enter a number between 1 and 5';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: const Text('Add Review'),
                                  style: style,
                                ),
                              ],
                            ),
                          )
                        ])))));
  }
}
