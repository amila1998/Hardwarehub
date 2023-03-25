import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Review.dart';
import 'package:hardwarehub/Providers/ReviewProvider.dart';
import 'package:provider/provider.dart';

class EditReviewScreen extends StatefulWidget {
  final Review review;

  const EditReviewScreen({super.key, required this.review});

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  late final String? id;

  @override
  void initState() {
    super.initState();

    id = widget.review.id;
    _titleController.text = widget.review.title;
    _descriptionController.text = widget.review.description;
    _ratingController.text = widget.review.rating.toString();
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
        final itemId = widget.review.itemId;
        final itemName = widget.review.itemName;
        final userName = widget.review.userName;
        final userId = widget.review.userId;

        // add the new item to the database
        final updatedReview = Review(
            id: id.toString(),
            title: title,
            description: description,
            rating: rating,
            itemId: itemId,
            itemName: itemName,
            userId: userId,
            userName: userName);
        await reviewProvider.updateReview(updatedReview);

        // clear the form
        _titleController.clear();
        _descriptionController.clear();
        _ratingController.clear();

        // navigate back to the item list screen
        //Provider.of<ReviewProvider>(context, listen: false).;
        Navigator.pop(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: Text('Edit Review'),
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
                                  child: const Text('Update Review'),
                                  style: style,
                                ),
                              ],
                            ),
                          )
                        ])))));
  }
}
