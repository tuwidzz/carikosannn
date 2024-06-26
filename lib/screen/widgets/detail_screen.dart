//detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';

class KosDetailScreen extends StatelessWidget {
  final Kos kos;

  const KosDetailScreen({Key? key, required this.kos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kos.name),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                File(kos.imagePath),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                'Nama: ${kos.name}',
                style: const TextStyle(fontSize: 16),
              ),
              // Text(
              //   kos.name,
              //   style: const TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 8),
              Text(
                'Alamat: ${kos.address}',
                style: const TextStyle(fontSize: 16),
              ),
              // Text(
              //   kos.address,
              //   style: const TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 8),
              Text(
                'Kota: ${kos.city}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Deskripsi: ${kos.description}',
                style: const TextStyle(fontSize: 16),
              ),
              // const SizedBox(height: 8),
              // Text(
              //   kos.description,
              //   style: const TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 8),
              Text(
                'Fasilitas: ${kos.facilities}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Kontak: ${kos.contact}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Harga: Rp ${kos.price}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement booking functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking berhasil!')),
                    );
                  },
                  child: const Text('Booking Sekarang'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    backgroundColor: Colors.white, // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
