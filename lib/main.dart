// main.dart

import 'package:carikosannn/cubit/auth/auth_cubit.dart';
import 'package:carikosannn/screen/routes/admin/1home.dart';
import 'package:carikosannn/utils/auth_wrapper.dart';
import 'package:carikosannn/screen/routes/login.dart';
import 'package:carikosannn/screen/routes/user/1home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const CariKosan());
}

class CariKosan extends StatelessWidget {
  const CariKosan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        )
      ],
      child: MaterialApp(
        title: 'Cari Kos',
        theme: ThemeData(
          primarySwatch: Colors.purple, // Mengubah warna tema menjadi ungu
        ),
        initialRoute: '/login', // Set rute awal ke halaman login
        routes: {
          '/login': (context) =>
              const LoginScreen(), // Menambahkan rute ke halaman login
          '/home': (context) => AuthWrapper(child: HomeScreen()),
          '/admin': (context) =>
              const AdminScreen(), // Menambahkan rute ke halaman home
        },
      ),
    );
  }
}
