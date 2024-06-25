// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// Dummy data representing complaints
final List<Complaint> complaints = [
  Complaint(
    id: '1',
    title: 'Kos 1',
    description: 'Kos tidak bersih.',
    status: 'Test',
  ),
  Complaint(
    id: '2',
    title: 'Kos 2',
    description: 'Kos terlau raamai dan ribut.',
    status: 'Test',
  ),
  Complaint(
    id: '3',
    title: 'Kos 3',
    description: 'Kos selalu terkendala air.',
    status: 'Resolved',
  ),
];

class Complaint {
  final String id;
  final String title;
  final String description;
  final String status;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
}

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Complaints'),
        backgroundColor: Color.fromARGB(255, 152, 114, 0),
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return ListTile(
            title: Text(complaint.title),
            subtitle: Text(complaint.description),
            trailing: Text(complaint.status),
            onTap: () {
              // Navigate to complaint details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ComplaintDetailsScreen(complaint: complaint),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: const Color.fromARGB(255, 186, 143, 186),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Title: ${complaint.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Description: ${complaint.description}'),
            const SizedBox(height: 10),
            Text('Status: ${complaint.status}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ComplaintsScreen(),
  ));
}
