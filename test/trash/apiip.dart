// //apiip.dart

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:carikosannn/endpoints/endpoints1.dart'; // Pastikan file endpoints1.dart memiliki fungsi untuk memperbarui BaseURL

// class InputIp extends StatefulWidget {
//   const InputIp({super.key});

//   @override
//   _InputIpState createState() => _InputIpState();
// }

// class _InputIpState extends State<InputIp> {
//   final TextEditingController _ipController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadIP();
//   }

//   // Method to load the IP address
//   void _loadIP() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString('baseURL');
//     if (ip != null) {
//       _ipController.text = ip;
//     }
//   }

//   // Method to save the IP address
//   void _saveIP() async {
//     String ip = _ipController.text;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('baseURL', ip);
//     // Update the BaseURL in endpoints1.dart
//     Endpoints1.updateBaseURL(ip);
//     // ignore: use_build_context_synchronously
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('IP BaseURL berhasil disimpan')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Input IP BaseURL'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _ipController,
//               decoration: const InputDecoration(
//                 labelText: 'Masukkan IP BaseURL',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: _saveIP,
//               child: const Text('Simpan IP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
