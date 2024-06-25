// 1home.dart(user)
// ignore_for_file: sort_child_properties_last, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, unnecessary_to_list_in_spreads, use_super_parameters

import 'dart:io';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/dto/manager.dart';
import 'package:carikosannn/screen/routes/about.dart';
import 'package:carikosannn/screen/routes/user/3chat.dart';
import 'package:carikosannn/screen/routes/user/cs.dart';
import 'package:carikosannn/screen/routes/user/2fav.dart';
import 'package:carikosannn/screen/routes/user/4profil.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    const FavScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Selamat datang, User!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Cari Kos Dengan Mudah',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ],
        ),
        backgroundColor: Colors.brown[50],
        automaticallyImplyLeading: false,
      ),
      drawer: _selectedIndex == 0
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    child: Text(
                      'CariKos',
                      style: TextStyle(color: Colors.black),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Tentang Kami',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Customer Service',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerServiceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<Kos> filteredKost;
  TextEditingController searchController = TextEditingController();

  // Filter criteria
  double _selectedPrice = 0;
  RangeValues _priceRange = const RangeValues(0, 2000000);

  @override
  void initState() {
    super.initState();
    filteredKost = KosManager().kosList;
    searchController.addListener(_filterKosList);
  }

  void _filterKosList() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredKost = KosManager().kosList.where((kos) {
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
          title: Text('Filter Kos'),
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
              child: Text('Apply'),
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
          content: Text('Berhasil ditambahkan ke favorit!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
                    foregroundColor: Colors.white, // Change text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Kos-kosan Andalan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white, // Change text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Urutkan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3BBA0),
                    foregroundColor: Colors.white, // Change text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...filteredKost.map((kos) => _buildKosCard(kos)).toList(),
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
              Row(
                children: const [
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
                'Rp. ${kos.price.toStringAsFixed(0)}/Kamar/Bulan', // Menampilkan harga sesuai dengan data kos
                style: TextStyle(color: Colors.brown),
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
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Implement favorite functionality here
                        _showFavoriteAddedDialog(context);
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: const [
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
                        style: TextStyle(color: Colors.brown),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement booking functionality here
                          // Example: Navigator.pushNamed(context, '/booking');
                        },
                        child: const Text('Booking'),
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
