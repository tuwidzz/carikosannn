// fav.dart

import 'package:carikosannn/dto/kos.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Kos> _favorites = [];

  List<Kos> get favorites => _favorites;

  void addFavorite(Kos kos) {
    _favorites.add(kos);
  }

  void removeFavorite(Kos kos) {
    _favorites.remove(kos);
  }
}
