// manager.dart

import 'kos.dart';

class KosManager1 {
  static final KosManager1 _instance = KosManager1._internal();
  factory KosManager1() => _instance;
  KosManager1._internal();

  final List<Kos> _kosList = [];

  List<Kos> get kosList => _kosList;

  // void addKos(Kos kos) {
  //   _kosList.add(kos);
  // }

  // void removeKos(Kos kos) {
  //   _kosList.remove(kos);
  // }

  void updateKos(Kos kos) {
    int index = _kosList.indexWhere((element) => element.id == kos.id);
    if (index != -1) {
      _kosList[index] = kos;
    }
  }
}
