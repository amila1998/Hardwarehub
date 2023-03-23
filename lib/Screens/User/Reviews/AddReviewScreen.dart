import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comment',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final review = {
                      'name': _nameController.text,
                      'comment': _commentController.text,
                      'created_at': Timestamp.now(),
                    };
                    await FirebaseFirestore.instance
                        .collection('reviews')
                        .add(review);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
