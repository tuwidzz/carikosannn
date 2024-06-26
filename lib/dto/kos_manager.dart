// manager.dart

import 'kos.dart';

class KosManager {
  static final KosManager _instance = KosManager._internal();
  factory KosManager() => _instance;
  KosManager._internal();

  final List<Kos> _kosList = [];

  List<Kos> get kosList => _kosList;

  void addKos(Kos kos) {
    _kosList.add(kos);
  }

  void removeKos(Kos kos) {
    _kosList.remove(kos);
  }

  void updateKos(Kos kos) {
    int index = _kosList.indexWhere((element) => element.id == kos.id);
    if (index != -1) {
      _kosList[index] = kos;
    }
  }
}
