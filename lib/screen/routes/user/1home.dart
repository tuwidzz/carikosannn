import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:carikosannn/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/screen/routes/user/2fav.dart';
import 'package:carikosannn/screen/routes/user/4profil.dart';
import 'package:carikosannn/screen/widgets/detail_screen.dart';

import '../../widgets/book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeContent(onFavoriteAdded: _addKosToFavorites),
      FavScreen(favoriteKosList: favoriteKosList),
      const BookScreen(),
      const ProfileScreen(),
    ];
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            icon: Icon(Icons.book_online),
            label: 'Book',
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

  const HomeContent({super.key, required this.onFavoriteAdded});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<Kos> filteredKost;
  TextEditingController searchController = TextEditingController();
  bool _isLoading = true;

  // Filter criteria
  double _selectedPrice = 0;
  RangeValues _priceRange = const RangeValues(0, 2000000);

  @override
  void initState() {
    super.initState();
    _fetchKosData();
    searchController.addListener(_filterKosList);
  }

  Future<void> _fetchKosData() async {
    try {
      final kosList = await KosService.fetchKosList();
      setState(() {
        filteredKost = kosList;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _filterKosList() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredKost = filteredKost.where((kos) {
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
          title: const Text('Favorit Ditambahkan'),
          content: const Text('Kos telah ditambahkan ke daftar favorit.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _sortKosList('Terendah'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.brown,
                                backgroundColor: Colors.white,
                              ),
                              child: const Text('Harga Terendah'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _sortKosList('Tertinggi'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.brown,
                                backgroundColor: Colors.white,
                              ),
                              child: const Text('Harga Tertinggi'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _showFilterDialog,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.brown,
                                backgroundColor: Colors.white,
                              ),
                              child: const Text('Filter'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.network(
          '${Endpoints.baseUAS}/static/show_image/${kos.imagePath}',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(
          kos.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              kos.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Rp ${kos.price}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
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
