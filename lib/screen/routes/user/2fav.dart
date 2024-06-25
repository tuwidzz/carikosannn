import 'package:flutter/material.dart';
import 'package:carikosannn/dto/fav.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager().favorites;

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: favorites.isEmpty
          ? Center(
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
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          color: Colors.grey[300],
                          child: kos.imagePath.isNotEmpty
                              ? _buildKosImage(kos.imagePath)
                              : Center(child: Text('No Image')),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kos.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    kos.description,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Rp. 999.999/Kamar/Bulan',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                FavoritesManager().removeFavorite(kos);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildKosImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
    );
  }
}
