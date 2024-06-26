//4profil.dart(user)
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carikosannn/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.brown,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          'assets/images/profile_picture.png'), // Ganti dengan path foto profil Anda
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'user',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'user@test.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildListTile(Icons.person_outline, 'Edit Profil', () {
              // Navigasi ke halaman edit profil
            }),
            const Divider(height: 0),
            buildListTile(Icons.history, 'Booking', () {
              // Navigasi ke halaman riwayat pembelian
            }),
            const Divider(height: 0),
            buildListTile(Icons.exit_to_app, 'Keluar', () {
              // Implementasi logika untuk keluar dari akun
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CariKosan(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.brown,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
