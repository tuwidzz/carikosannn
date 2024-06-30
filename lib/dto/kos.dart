// lib/dto/kos.dart

class Kos {
  final int id; // Changed from String to int
  final String name;
  final String address;
  final String city;
  final double price;
  final String description;
  final String facilities;
  final String contact;
  final String imagePath;

  Kos({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.price,
    required this.description,
    required this.facilities,
    required this.contact,
    required this.imagePath,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id_kos'], // Assuming 'id_user' is an int in the JSON
      name: json['nama_kos'],
      address: json['alamat'],
      city: json['kota'],
      price: json['harga'],
      description: json['deskripsi'],
      facilities: json['fasilitas'],
      contact: json['kontak'],
      imagePath: json['gambar_kos'],
    );
  }
}
