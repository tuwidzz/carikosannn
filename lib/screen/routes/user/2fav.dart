import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:carikosannn/screen/widgets/detail_screen.dart';
import 'package:flutter/material.dart';
import '../../../dto/kos.dart';

class FavScreen extends StatefulWidget {
  final List<Kos> favoriteKosList;

  const FavScreen({super.key, required this.favoriteKosList});

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<Kos> favoriteKosList = [];

  @override
  void initState() {
    super.initState();
    favoriteKosList = widget.favoriteKosList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      // appBar: AppBar(
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: const [
      //           Text(
      //             'Kos Favorit',
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           Text(
      //             'Kos yang kamu tandai sebagai favorit',
      //             style: TextStyle(
      //               fontSize: 16,
      //               color: Colors.grey,
      //             ),
      //           ),
      //         ],
      //       ),
      //       Image.asset(
      //         'assets/images/logo.png',
      //         height: 40,
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.brown[50],
      //   automaticallyImplyLeading: false,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favoriteKosList.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada kos favorit.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: favoriteKosList.length,
                itemBuilder: (context, index) {
                  Kos kos = favoriteKosList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KosDetailScreen(kos: kos),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Image.network(
                          '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(kos.name),
                        subtitle: Text(kos.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              favoriteKosList.remove(kos);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
