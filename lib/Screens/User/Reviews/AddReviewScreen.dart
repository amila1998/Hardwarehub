import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hardwarehub/Providers/ReviewProvider.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
        final itemId = 'rtr3t435t4trerttre';
        // add the new item to the database
        await reviewProvider.addReview(
          title,
          description,
          itemId,
        );

        // clear the form
        _titleController.clear();
        _descriptionController.clear();

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
