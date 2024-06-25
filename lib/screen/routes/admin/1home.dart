// 1.home.dart(admin)
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:io';

import 'package:carikosannn/dto/manager.dart';
import 'package:carikosannn/screen/routes/admin/add.dart';
import 'package:carikosannn/screen/routes/admin/2history.dart';
import 'package:carikosannn/screen/routes/admin/edit.dart';
import 'package:carikosannn/screen/routes/admin/3profil.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // KosManager().kosStream.listen((List<Kos> kosList) {
    //   setState(() {}); // Trigger a rebuild when kosList updates
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        backgroundColor:
            Colors.brown[50], // Same as AdminProfileScreen background color
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
      backgroundColor: Colors.brown[50], // Background color of the screen
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
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
                );
              },
              backgroundColor: Colors.brown,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildKosList(),
            ],
          ),
        );
      case 1:
        return const HistoryScreen(); // Adjust to your history screen
      case 2:
        return const AdminProfile();
      default:
        return Container();
    }
  }

  Widget _buildKosList() {
    final kosList = KosManager().kosList;
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
            );
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
                              ? Image.file(
                                  File(kos.imagePath),
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
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    kos.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Rp. ${kos.price.toStringAsFixed(0)}/Kamar/Bulan',
                    style: TextStyle(color: Colors.brown),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Alamat: ${kos.address}, ${kos.city}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Fasilitas: ${kos.facilities}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Kontak: ${kos.contact}',
                    style: TextStyle(color: Colors.grey),
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
    // kosBloc.dispose();
    super.dispose();
  }
}
