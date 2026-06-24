import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../services/api_service_dio.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final ApiServiceDio _apiService = ApiServiceDio();
  late Future<MovieResponse> _futureMovies;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    _futureMovies = _apiService.getDiscoverMovies();
  }

  void searchMovies(String keyword) {
    setState(() {
      _futureMovies = _apiService.searchMovies(keyword);
    });
  }

  void loadDiscoverMovies() {
    setState(() {
      _futureMovies = _apiService.getDiscoverMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FakhriFlix'), centerTitle: true),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Looking for Movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  loadDiscoverMovies();
                } else {
                  searchMovies(value.trim());
                }
              },
            ),
          ),

          // LIST MOVIES
          Expanded(
            child: FutureBuilder<MovieResponse>(
              future: _futureMovies,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Data kosong
                if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
                  return const Center(
                    child: Text(
                      'Film tidak ditemukan',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final movies = snapshot.data!.results;

                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterUrl,
                          width: 56,
                          height: 84,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(movie.voteAverage.toStringAsFixed(1)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(movieId: movie.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
