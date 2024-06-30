import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/dto/book_manager.dart'; // Import the manager

class KosDetailScreen extends StatelessWidget {
  final Kos kos;

  const KosDetailScreen({super.key, required this.kos});

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
              Image.network(
                '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                'Nama: ${kos.id}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Nama: ${kos.name}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Alamat: ${kos.address}',
                style: const TextStyle(fontSize: 16),
              ),
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
                    BookedKosManager().addKos(kos); // Add booking functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking berhasil!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown,
                  ),
                  child: const Text('Booking Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
