import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeEvent { selectTab }

class HomeBloc extends Bloc<HomeEvent, int> {
  HomeBloc() : super(0);

  @override
  Stream<int> mapEventToState(HomeEvent event) async* {
    if (event == HomeEvent.selectTab) {
      yield 0; // Ganti dengan index sesuai tab yang dipilih
    }
  }
}
