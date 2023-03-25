import 'package:flutter/material.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _measurementController = TextEditingController();
  final _quantityController = TextEditingController();
  final _itemPhotoController = TextEditingController();
  String? _selectedMeasurement;
  bool _isAvailable = true;
  String _imageURL = '';
  String selctFile = '';
  XFile? file;
  Uint8List? selectedBookImageInBytes;
  Uint8List? selectedBookPdfInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;
  bool isItemSaved = false;

  File? _image;

  List<String> availableMeasurements = [
    'mm',
    'cm',
    'm',
    'in',
    'ft',
    'yd',
    'km',
    'mi',
  ];

  _selectFile() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'png',
          ],
          allowMultiple: false);

      if (fileResult != null && fileResult.files.isNotEmpty) {
        // File file = File(fileResult.files.single.path ?? '');
        final fileBytes = fileResult.files.first.bytes;
        final fileName = fileResult.files.first.name;
        setState(() {
          selctFile = fileName;
          selectedBookImageInBytes = fileBytes;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _uploadFile(Uint8List fileToUpload) async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$timestamp.jpg');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      //uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(fileToUpload, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    void _submitForm() async {
      String imageUrl = await _uploadFile(selectedBookImageInBytes!);
      final form = _formKey.currentState;
      if (form != null && form.validate()) {
// get the values entered by the user
        final name = _nameController.text;
        final price = double.parse(_priceController.text);
        final description = _descriptionController.text;
        final isAvailable = _isAvailable;
        final mesurement = _selectedMeasurement!;
        final quantity = int.parse(_quantityController.text);
        final itemPhoto = imageUrl;
        // add the new item to the database
        await itemProvider.addItem(
          name,
          price,
          description,
          isAvailable,
          mesurement,
          quantity,
          itemPhoto,
        );

        // clear the form
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _isAvailable = true;
        _measurementController.clear();
        _quantityController.clear();
        _itemPhotoController.clear();

        // navigate back to the item list screen
        Navigator.pop(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Add Item'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (selectedBookImageInBytes != null)
                            // Image.network(
                            //   _imageURL,
                            // height: 200,
                            // fit: BoxFit.cover,
                            Image.memory(
                              selectedBookImageInBytes!,
                              height: 200,
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Price'),
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a price';
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
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'Measurement'),
                            value: _selectedMeasurement,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedMeasurement = newValue!;
                              });
                            },
                            items: availableMeasurements
                                .map((measurement) => DropdownMenuItem(
                                      value: measurement,
                                      child: Text(measurement),
                                    ))
                                .toList(),
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Quantity'),
                            keyboardType: TextInputType.number,
                            controller: _quantityController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a quantity';
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid quantity';
                              }
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Available'),
                            value: _isAvailable,
                            onChanged: (newValue) {
                              setState(() {
                                _isAvailable = newValue;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              //_showPicker(context);
                              _selectFile();
                            },
                            icon: const Icon(
                              Icons.camera,
                            ),
                            label: const Text(
                              'Pick Image',
                              style: TextStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Add Item'),
                          ),
                        ])))));
  }
}
