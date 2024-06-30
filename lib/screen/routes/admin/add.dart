//add.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:carikosannn/endpoints/endpoints.dart';

class AddKos extends StatefulWidget {
  // ignore: use_super_parameters
  const AddKos({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddKos> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _facilitiesController = TextEditingController();
  final _contactController = TextEditingController();

  String _title = "";
  final String _description = "";
  // ignore: unused_field
  int _price = 0;

  File? galleryFile;
  final picker = ImagePicker();

  // String? _selectedCategory;

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')),
        );
      }
    });
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

  saveData() {
    debugPrint(_title);
    debugPrint(_description);
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    if (galleryFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // if (_selectedCategory == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please select a category')),
    //   );
    //   return;
    // }

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Endpoints.createdataKos));
      request.fields['id_user'] = _idController.text;
      request.fields['nama_kos'] = _nameController.text;
      request.fields['alamat'] = _addressController.text;
      request.fields['kota'] = _cityController.text;
      request.fields['harga'] = _priceController.text;
      request.fields['deskripsi'] = _descriptionController.text;
      request.fields['fasilitas'] = _facilitiesController.text;
      request.fields['kontak'] = _contactController.text;

      var multipartFile = await http.MultipartFile.fromPath(
        'gambar_kos',
        galleryFile!.path,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 201) {
        debugPrint('Menu posted successfully!');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        debugPrint('Error posting issue: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting menu: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  bool _validateInputs() {
    if (_idController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _facilitiesController.text.isEmpty ||
        _contactController.text.isEmpty ||
        galleryFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all the fields and select an image')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tambah Kos",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Isi form ini untuk menambahkan data Kos",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showPicker(context: context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 150,
                                  child: galleryFile == null
                                      ? Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                              Text(
                                                'Pilh gambar disini!',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                      255, 124, 122, 122),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Image.file(galleryFile!),
                                        ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _idController,
                                  decoration: const InputDecoration(
                                    hintText: "Id",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: "Nama Kos",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    hintText: "Alamat",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      _price = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    hintText: "Kota",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _price = int.tryParse(value) ?? 0;
                                    // });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    hintText: "Harga",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _price = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: "Deskripsi",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _price = int.tryParse(value) ?? 0;
                                    // });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _facilitiesController,
                                  decoration: const InputDecoration(
                                    hintText: "Fasilitas",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _price = int.tryParse(value) ?? 0;
                                    // });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  controller: _contactController,
                                  decoration: const InputDecoration(
                                    hintText: "Kontak",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    // setState(() {
                                    //   _price = int.tryParse(value) ?? 0;
                                    // });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 250),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(224, 138, 93, 20),
        tooltip: 'Save',
        onPressed: () {
          if (_validateInputs()) {
            _postDataWithImage(context);
          }
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}

// // ignore_for_file: library_private_types_in_public_api, unused_local_variable, avoid_print, use_build_context_synchronously, unused_element

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:carikosannn/dto/kos.dart';
// import 'package:carikosannn/services/data_service.dart';

// class AddKos extends StatefulWidget {
//   const AddKos({super.key});

//   @override
//   _AddKosScreenState createState() => _AddKosScreenState();
// }

// class _AddKosScreenState extends State<AddKos> {
//   final _formKey = GlobalKey<FormState>();
//   final _idController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _facilitiesController = TextEditingController();
//   final _contactController = TextEditingController();
//   File? _imageFile;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       // Handle error (e.g., show a dialog, log the error)
//     }
//   }

//   Future<String> _saveImage(File image) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath =
//         '${directory.path}/kos_image_${DateTime.now().millisecondsSinceEpoch}.png';
//     final File newImage = await image.copy(imagePath);
//     return imagePath;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Kos',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.brown,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   _pickImage(ImageSource.gallery);
//                 },
//                 child: _imageFile != null
//                     ? Image.file(
//                         _imageFile!,
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                     : Container(
//                         height: 200,
//                         color: Colors.grey[300],
//                       ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt, color: Colors.brown),
//                     onPressed: () {
//                       _pickImage(ImageSource.camera);
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library, color: Colors.brown),
//                     onPressed: () {
//                       _pickImage(ImageSource.gallery);
//                     },
//                   ),
//                 ],
//               ),
//               TextFormField(
//                 controller: _idController,
//                 decoration: const InputDecoration(labelText: 'ID'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the ID';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the address';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _cityController,
//                 decoration: const InputDecoration(labelText: 'City'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the city';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the price';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _facilitiesController,
//                 decoration: const InputDecoration(labelText: 'Facilities'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the facilities';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _contactController,
//                 decoration: const InputDecoration(labelText: 'Contact'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the contact';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final newKos = Kos(
//                       id: int.parse(_idController.text), // Parse to int
//                       name: _nameController.text,
//                       address: _addressController.text,
//                       city: _cityController.text,
//                       price: double.parse(_priceController.text),
//                       description: _descriptionController.text,
//                       facilities: _facilitiesController.text,
//                       contact: _contactController.text,
//                       imagePath: _imageFile != null ? _imageFile!.path : '',
//                     );
//                     try {
//                       await KosManager1().addKos(newKos);
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Kos successfully added!'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Failed to add Kos: $e'),
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.brown,
//                 ),
//                 child: const Text(
//                   'Add Kos',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
