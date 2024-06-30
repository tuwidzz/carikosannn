// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/dto/manager.dart';
import 'package:flutter/material.dart';
import '2fav.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<Kos> filteredKost;
  TextEditingController searchController = TextEditingController();
  List<Kos> favoriteKosList = [];

  // Filter criteria
  double _selectedPrice = 0;
  RangeValues _priceRange = const RangeValues(0, 2000000);

  @override
  void initState() {
    super.initState();
    filteredKost = KosManager1().kosList;
    searchController.addListener(_filterKosList);
  }

  void _filterKosList() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredKost = KosManager1().kosList.where((kos) {
        return kos.name.toLowerCase().contains(query) ||
            kos.description.toLowerCase().contains(query);
      }).toList();

      if (_selectedPrice > 0) {
        filteredKost = filteredKost.where((kos) {
          return kos.price <= _selectedPrice;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Kos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 2000000,
                divisions: 20,
                labels: RangeLabels(
                  '${_priceRange.start.round()}',
                  '${_priceRange.end.round()}',
                ),
                onChanged: (values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              Text('Max Price: Rp ${_priceRange.end.round()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedPrice = _priceRange.end;
                });
                Navigator.pop(context);
                _filterKosList();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showFavoriteAddedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Berhasil ditambahkan ke favorit!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _addToFavorites(Kos kos) {
    setState(() {
      if (!favoriteKosList.contains(kos)) {
        favoriteKosList.add(kos);
        _showFavoriteAddedDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Mau cari kos di mana?',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Kos-kosan Andalan'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Urutkan'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FavScreen(favoriteKosList: favoriteKosList),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Lihat Favorit'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...filteredKost.map((kos) => _buildKosCard(kos)),
        ],
      ),
    );
  }

  Widget _buildKosCard(Kos kos) {
    return GestureDetector(
      onTap: () {
        _showKosDetailsDialog(context, kos);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                color: Colors.grey[300],
                child: kos.imagePath.isNotEmpty
                    ? _buildKosImage(kos.imagePath)
                    : const Center(child: Text('No Image')),
              ),
              const SizedBox(height: 10),
              Text(
                kos.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                ],
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
              IconButton(
                icon: favoriteKosList.contains(kos)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                onPressed: () {
                  _addToFavorites(kos);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKosDetailsDialog(BuildContext context, Kos kos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: kos.imagePath.isNotEmpty
                          ? _buildKosImage(kos.imagePath)
                          : const Center(child: Text('No Image')),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kos.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
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
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/booking');
                        },
                        child: const Text('Booking'),
                      ),
                      IconButton(
                        icon: favoriteKosList.contains(kos)
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border),
                        onPressed: () {
                          _addToFavorites(kos);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKosImage(String imagePath) {
    File imageFile = File(imagePath);
    bool fileExists = imageFile.existsSync();
    if (fileExists) {
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else {
      return const Center(child: Text('Image not found'));
    }
  }
}
