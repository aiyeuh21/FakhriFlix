# 🎬 FakhriFlix Mobile

Aplikasi mobile berbasis Flutter yang menampilkan katalog film menggunakan data dinamis dari The Movie Database (TMDB) API. Aplikasi ini dirancang dengan nuansa warna profesional (Hitam & Kuning), dilengkapi fitur pencarian pintar, penanganan _error_ UI yang tangguh, serta sistem _pagination_ untuk membaca ulasan film.

## 📱 Tampilan Fitur

### Home Page

Menampilkan daftar film dan fitur pencarian terintegrasi:

- Search Bar dinamis (memanggil endpoint `/search/movie`)
- Poster Film
- Judul Film
- Rating Film
- Tanggal Rilis

### Detail Page

Menampilkan informasi lengkap film dengan _error handling_ (mencegah UI blank):

- Trailer Video (dengan penanganan jika video kosong)
- Judul Film & Rating
- Kategori/Genre (dengan penanganan jika genre kosong)
- Tanggal Rilis & Deskripsi Film (Overview)

### All Reviews Page (on Progress)

Halaman khusus yang menampilkan seluruh ulasan penonton:

- Daftar seluruh review pengguna
- Fitur _Pagination_ menggunakan `ScrollController` dan parameter `page`

---

## 🛠 Teknologi yang Digunakan

- Flutter
- Dart
- Material Design
- Dio (HTTP Client)
- RESTful API (TMDB)
- ListView.builder & ScrollController

---

## 📂 Struktur Project

```text
lib/
│
├── main.dart
├── services/
│   └── movie_service.dart
│
└── pages/
    ├── movie_list_page.dart
    ├── movie_detail_page.dart
    └── all_reviews_page.dart
```

---

## 🚀 Cara Menjalankan Project

### Clone Repository

```bash
git clone [https://github.com/aiyeuh21/FakhriFlix.git](https://github.com/aiyeuh21/FakhriFlix.git)
```

### Masuk ke Folder Project

```bash
cd FakhriFlix
```

### Install Dependency

```bash
flutter pub get
```

### Setup API Key

Daftar di [TMDB](https://www.themoviedb.org/) untuk mendapatkan API Key, lalu masukkan key tersebut ke dalam file `movie_service.dart`.

### Jalankan Aplikasi

```bash
flutter run
```

---

## 📋 Implementasi Dio Request

```dart
Future<List<Movie>> searchMovie(String keyword) async {
  try {
    final response = await _dio.get(
      '/search/movie',
      queryParameters: {
        'query': keyword,
      },
    );

    if (response.statusCode == 200) {
      final List data = response.data['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal melakukan pencarian');
    }
  } on DioException catch (e) {
    throw Exception('Terjadi kesalahan: ${e.message}');
  }
}
```

---

## 🎯 Tujuan Pengembangan

Project ini dibuat untuk mempelajari:

- Integrasi RESTful API menggunakan package Dio
- Implementasi endpoint Search dengan Query Parameter
- Pembuatan fitur _Pagination_ (Infinite Scroll)
- Penanganan Null/Empty State pada UI agar tidak _error/blank_
- Kustomisasi Tema Aplikasi (Warna Hitam dan Kuning)
- Pengolahan Data JSON

---

## 👨‍💻 Developer

**Fakhri Andika** _(GitHub: [@aiyeuh21](https://github.com/aiyeuh21))_

---

## 📄 License

Project ini dibuat untuk keperluan pembelajaran dan pengembangan aplikasi mobile menggunakan Flutter dan integrasi API.
