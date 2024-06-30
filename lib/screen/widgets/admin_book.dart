import 'package:flutter/material.dart';
import 'package:carikosannn/dto/book_manager.dart';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

class BookScreenAdmin extends StatelessWidget {
  const BookScreenAdmin({super.key});

  Future<void> _deleteKos(BuildContext context, int kosId) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.dataKosDelete}/$kosId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kos berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus kos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookedKosList = BookedKosManager().bookedKosList;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30, // Tinggi dari marquee
          child: Marquee(
            text: 'Booked Kos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            blankSpace: 100, // Spasi di antara teks berjalan
            velocity: 50, // Kecepatan animasi berjalan
            pauseAfterRound: Duration(seconds: 1), // Jeda setelah satu putaran
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
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text(
                          'Apakah Anda yakin ingin menghapus kos ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Ya'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await _deleteKos(context, kos.id);
                  // Refresh the UI after deletion
                  (context as Element).reassemble();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
