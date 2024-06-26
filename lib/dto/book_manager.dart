import 'package:carikosannn/dto/kos.dart';

class BookedKosManager {
  static final BookedKosManager _instance = BookedKosManager._internal();
  final List<Kos> _bookedKosList = [];

  BookedKosManager._internal();

  factory BookedKosManager() {
    return _instance;
  }

  void addKos(Kos kos) {
    _bookedKosList.add(kos);
  }

  List<Kos> get bookedKosList => _bookedKosList;
}
