// kos.dart

class Kos {
  final String id; // Tambahkan ID unik
  String name;
  String address;
  String city;
  double price;
  String description;
  String facilities;
  String contact;
  String imagePath;

  Kos({
    required this.id, // ID sebagai parameter wajib
    required this.name,
    required this.address,
    required this.city,
    required this.price,
    required this.description,
    required this.facilities,
    required this.contact,
    required this.imagePath,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Kos && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
