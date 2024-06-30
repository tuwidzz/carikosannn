// 3chat.dart(user)
// ignore_for_file: prefer_const_constructors, use_super_parameters, file_names

import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Riwayat Pemesanan'),
      //   backgroundColor: Color.fromARGB(255, 255, 255, 255),
      //   automaticallyImplyLeading: false, // Tambahkan baris ini
      // ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Text(
          'Belum ada riwayat Chat.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
