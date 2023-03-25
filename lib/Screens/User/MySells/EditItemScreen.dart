import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/Models/Item.dart';
import 'package:hardwarehub/Providers/ItemProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class EditItemScreen extends StatefulWidget {
  final Item item;

  const EditItemScreen({super.key, required this.item});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _measurementController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _itemPhotoController = TextEditingController();
  late String _selectedMeasurement;
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
  late final String? id;

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
  void initState() {
    super.initState();
    id = widget.item.id;
    _nameController.text = widget.item.name;
    _priceController.text = widget.item.price.toString();
    _descriptionController.text = widget.item.description;
    _isAvailable = widget.item.isAvailable;
    _selectedMeasurement = widget.item.mesurement;
    _quantityController.text = widget.item.quantity.toString();
    _itemPhotoController.text = widget.item.itemPhoto;
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
  String? imageUrl;
    void _submitForm() async {
      if(selectedBookImageInBytes != null) {
      imageUrl = await _uploadFile(selectedBookImageInBytes!);
      }
      final form = _formKey.currentState;
      if (form != null && form.validate()) {
// get the values entered by the user
        final name = _nameController.text;
        final price = double.parse(_priceController.text);
        final description = _descriptionController.text;
        final isAvailable = _isAvailable;
        final mesurement = _selectedMeasurement;
        final quantity = int.parse(_quantityController.text);
        final itemPhoto = imageUrl ?? _itemPhotoController.text ;
// add the new item to the database
        final updatedItem = Item(
          id: id.toString(),
          name:name,
          price: price,
          description: description,
          isAvailable: isAvailable,
          mesurement: mesurement,
          quantity: quantity,
          itemPhoto: itemPhoto,
          userId: user!.uid,
        );
        await itemProvider.updateItem(updatedItem);
        // clear the form
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _isAvailable = true;
        _measurementController.clear();
        _quantityController.clear();
        _itemPhotoController.clear();

        // navigate back to the item list screen
        Provider.of<ItemProvider>(context, listen: false).loadItemsbyuser(user.uid);
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
                            child: const Text('Edit Item'),
                          ),
                        ])))));
  }
}
