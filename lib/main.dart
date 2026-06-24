import 'package:flutter/material.dart';
import 'pages/movie_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FakhriFlix',
      // GANTI BAGIAN THEME INI
      theme: ThemeData(
        brightness: Brightness.dark, // Membuat background default menjadi gelap
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ), // Hitam pekat (bisa diganti Colors.black)
        primaryColor: const Color(0xFFFFE600), // Kuning khas EY
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(
            0xFFFFE600,
          ), // Warna teks/icon di AppBar menjadi kuning
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(
            0xFFFFE600,
          ), // Kuning untuk tombol, loading indicator, dll
          secondary: Color(0xFF2E2E38), // Abu-abu gelap untuk elemen sekunder
        ),
      ),
      home: const MovieListPage(),
    );
  }
}
