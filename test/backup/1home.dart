// 1home.dart(user)
// ignore_for_file: sort_child_properties_last, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, unnecessary_to_list_in_spreads, use_super_parameters, file_names, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:carikosannn/dto/manager.dart';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/screen/routes/user/3chat.dart';
import 'package:carikosannn/screen/routes/user/2fav.dart';
import 'package:carikosannn/screen/routes/user/4profil.dart';
import 'package:carikosannn/screen/widgets/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Kos> favoriteKosList = [];

  void _addKosToFavorites(Kos kos) {
    setState(() {
      favoriteKosList.add(kos);
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(
      onFavoriteAdded: (Kos) {},
    ),
    FavScreen(
      favoriteKosList: const [],
    ),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _widgetOptions[0] = HomeContent(onFavoriteAdded: _addKosToFavorites);
    _widgetOptions[1] = FavScreen(favoriteKosList: favoriteKosList);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        _widgetOptions[1] = FavScreen(favoriteKosList: favoriteKosList);
      }
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
  final Function(Kos) onFavoriteAdded;

  const HomeContent({required this.onFavoriteAdded});

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

  void _sortKosList(String criteria) {
    setState(() {
      if (criteria == 'Terendah') {
        filteredKost.sort((a, b) => a.price.compareTo(b.price));
      } else if (criteria == 'Tertinggi') {
        filteredKost.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }

  void _showFavoriteAddedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Favorit Ditambahkan'),
          content: Text('Kos telah ditambahkan ke daftar favorit.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari kos...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _sortKosList('Terendah'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown,
                          backgroundColor: Colors.white, // Text color
                        ),
                        child: const Text('Harga Terendah'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _sortKosList('Tertinggi'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown,
                          backgroundColor: Colors.white, // Text color
                        ),
                        child: const Text('Harga Tertinggi'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _showFilterDialog,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown,
                          backgroundColor: Colors.white, // Text color
                        ),
                        child: const Text('Filter Harga'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredKost.length,
                  itemBuilder: (context, index) {
                    final kos = filteredKost[index];
                    return _buildKosCard(kos);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKosCard(Kos kos) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Image.network(
          '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(
          kos.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              kos.description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              'Rp ${kos.price}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.brown,
          ),
          onPressed: () {
            widget.onFavoriteAdded(kos);
            _showFavoriteAddedDialog(context);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KosDetailScreen(kos: kos),
            ),
          );
        },
      ),
    );
  }
}
