// login.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:carikosannn/component/constants.dart';
import 'package:carikosannn/cubit/auth/auth_cubit.dart';
import 'package:carikosannn/services/data_service.dart';
import 'package:carikosannn/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Perlu untuk menggunakan BlocProvider
import '../../dto/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void sendLogin(BuildContext context, AuthCubit authCubit) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == "user1") {
      // Jika menggunakan user1, langsung arahkan ke layar admin
      Navigator.pushReplacementNamed(context, "/admin");
      return;
    }

    final response = await DataService.sendLoginData(email, password);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loggedIn = Login.fromJson(data);
      await SecureStorageUtil.storage
          .write(key: tokenStoreName, value: loggedIn.accessToken);
      authCubit.login(loggedIn.accessToken);
      Navigator.pushReplacementNamed(context, "/home"); // Rute untuk user biasa
      debugPrint(loggedIn.accessToken);
    } else {
      // Tambahkan error handling di sini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal, silakan coba lagi.')),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Adjust the path to your logo
                    height: 250,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Masuk Pencari Kos, CariKosan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.brown),
                      filled: true,
                      fillColor: Colors.brown[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(color: Colors.brown),
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.brown),
                      filled: true,
                      fillColor: Colors.brown[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.brown,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  BlocProvider(
                    create: (context) => AuthCubit(),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () =>
                              sendLogin(context, context.read<AuthCubit>()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Masuk'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text(
                  //     'Lupa Password?',
                  //     style: TextStyle(color: Colors.brown),
                  //   ),
                  // ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text(
                  //     'Tidak mempunyai akun? Daftar',
                  //     style: TextStyle(color: Colors.brown),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
