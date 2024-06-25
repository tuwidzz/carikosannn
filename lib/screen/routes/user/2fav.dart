// 2fav.dart(user)
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carikosannn/dto/fav.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager().favorites;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Riwayat Favorit'),
      //   backgroundColor: const Color.fromARGB(255, 186, 143, 186),
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: Colors.brown[50],
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat Favorit.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final kos = favorites[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                color: Colors.grey[300],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite),
                              onPressed: () {
                                FavoritesManager().removeFavorite(kos);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          kos.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          kos.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          'Rp. 999.999/Kamar/Bulan',
                          style: TextStyle(color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
