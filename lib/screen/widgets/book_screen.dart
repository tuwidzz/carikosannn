import 'package:flutter/material.dart';
import 'package:carikosannn/dto/book_manager.dart';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:marquee/marquee.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookedKosList = BookedKosManager().bookedKosList;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30, // Tinggi dari marquee
          child: Marquee(
            text: 'Booked Kos',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            blankSpace: 100, // Spasi di antara teks berjalan
            velocity: 50, // Kecepatan animasi berjalan
            pauseAfterRound: const Duration(seconds: 1), // Jeda setelah satu putaran
            startPadding: 10, // Padding di awal teks
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: bookedKosList.length,
        itemBuilder: (context, index) {
          final kos = bookedKosList[index];
          return ListTile(
            leading: Image.network(
              '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported);
              },
            ),
            title: Text(kos.name),
            subtitle: Text('Rp ${kos.price}'),
          );
        },
      ),
    );
  }
}
