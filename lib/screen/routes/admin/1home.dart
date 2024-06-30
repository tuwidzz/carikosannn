import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:carikosannn/screen/routes/admin/add.dart';
import 'package:carikosannn/screen/routes/admin/edit.dart';
// import 'package:carikosannn/screen/routes/admin/2history.dart';
import 'package:carikosannn/screen/routes/admin/3profil.dart';
import 'package:carikosannn/services/data_service.dart';

import '../../widgets/admin_book.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  late Future<List<Kos>> _kosFuture;

  @override
  void initState() {
    super.initState();
    _refreshKosList();
  }

  void _refreshKosList() {
    setState(() {
      _kosFuture = KosService.fetchKosList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        backgroundColor: Colors.brown[50],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 70,
              width: 70,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.brown[50],
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddKos(),
                  ),
                ).then((_) {
                  _refreshKosList();
                });
              },
              backgroundColor: Colors.brown,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _deleteKos(int kosId) async {
    final success = await DataService.deleteKos(kosId);
    if (success) {
      setState(() {
        _kosFuture = KosService.fetchKosList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete Kos')),
      );
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<List<Kos>>(
          future: _kosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildKosList(snapshot.data!),
                  ],
                ),
              );
            }
          },
        );
      case 1:
        return const BookScreenAdmin(); // Placeholder for your HistoryScreen
      case 2:
        return const AdminProfile(); // Placeholder for your AdminProfile
      default:
        return Container();
    }
  }

  Widget _buildKosList(List<Kos> kosList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kosList.length,
      itemBuilder: (context, index) {
        final kos = kosList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditKosScreen(kos: kos),
              ),
            ).then((updatedKos) {
              if (updatedKos != null) {
                setState(() {
                  kosList[index] = updatedKos;
                });
              }
            });
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
                          child: kos.imagePath.isNotEmpty
                              ? Image.network(
                                  '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    kos.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    kos.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Rp. ${kos.price.toStringAsFixed(0)}/Kamar/Bulan',
                    style: const TextStyle(color: Colors.brown),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Alamat: ${kos.address}, ${kos.city}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Fasilitas: ${kos.facilities}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Kontak: ${kos.contact}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteKos(kos.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
