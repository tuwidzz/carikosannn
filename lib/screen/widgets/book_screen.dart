import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/dto/book_manager.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookedKosList = BookedKosManager().bookedKosList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Kos'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: bookedKosList.length,
        itemBuilder: (context, index) {
          final kos = bookedKosList[index];
          return ListTile(
            leading: Image.file(
              File(kos.imagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(kos.name),
            subtitle: Text('Rp ${kos.price}'),
          );
        },
      ),
    );
  }
}
