//edit.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/services/data_service.dart';
import 'package:carikosannn/endpoints/endpoints.dart';

class EditKosScreen extends StatefulWidget {
  final Kos kos;

  const EditKosScreen({Key? key, required this.kos}) : super(key: key);

  @override
  _EditKosScreenState createState() => _EditKosScreenState();
}

class _EditKosScreenState extends State<EditKosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _facilitiesController;
  late TextEditingController _contactController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.kos.id.toString());
    _nameController = TextEditingController(text: widget.kos.name);
    _addressController = TextEditingController(text: widget.kos.address);
    _cityController = TextEditingController(text: widget.kos.city);
    _priceController = TextEditingController(text: widget.kos.price.toString());
    _descriptionController =
        TextEditingController(text: widget.kos.description);
    _facilitiesController = TextEditingController(text: widget.kos.facilities);
    _contactController = TextEditingController(text: widget.kos.contact);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _facilitiesController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick an image')),
      );
    }
  }

  Future<String> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/kos_image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File newImage = await image.copy(imagePath);
    return imagePath;
  }

  void _saveChanges(int id) async {
    if (_formKey.currentState!.validate()) {
      String imagePath = widget.kos.imagePath;
      if (_imageFile != null) {
        imagePath = await _saveImage(_imageFile!);
      }

      final updatedKos = Kos(
        id: int.parse(_idController.text), // Ensure ID is parsed correctly
        name: _nameController.text,
        address: _addressController.text,
        city: _cityController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        facilities: _facilitiesController.text,
        contact: _contactController.text,
        imagePath: imagePath,
      );

      try {
        await KosManager().updateKos(updatedKos);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kos successfully updated!')),
        );
        Navigator.pop(context, updatedKos); // Send updatedKos back
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update Kos!')),
        );
        print('Error updating Kos: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : widget.kos.imagePath.isNotEmpty
                        ? Image.network(
                            '${Endpoints.baseUAS}/static/show_image/${widget.kos.imagePath}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            color: Colors.grey[300],
                          ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.brown),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.brown),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _facilitiesController,
                decoration: const InputDecoration(labelText: 'Facilities'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the facilities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveChanges(widget.kos.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
