import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import '../models/movie_model.dart';
import '../services/api_service_dio.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final ApiServiceDio _apiService = ApiServiceDio();

  late Future<MovieDetail> _futureDetail;
  late Future<ReviewResponse> _futureReviews;
  late Future<MovieResponse> _futureSimilar;

  @override
  void initState() {
    super.initState();
    // Panggil 3 endpoint sekaligus saat halaman dibuka
    _futureDetail = _apiService.getMovieDetail(widget.movieId);
    _futureReviews = _apiService.getMovieReviews(widget.movieId);
    _futureSimilar = _apiService.getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetail>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // ── App bar dengan backdrop image ──
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorWidget: (c, u, e) => Container(color: Colors.grey),
                  ),
                ),
              ),

              // ── Konten utama ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster + info dasar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterUrl,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${movie.voteAverage}'),
                                    const SizedBox(width: 12),
                                    Text('${movie.runtime} min'),
                                  ],
                                ),
                                // 1. Kondisi Genres
                                movie.genres == null || movie.genres!.isEmpty
                                    ? const Text(
                                        'Genre tidak tersedia',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        children: movie.genres
                                            .map((g) => Chip(label: Text(g)))
                                            .toList(),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sinopsis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(movie.overview),

                      const SizedBox(height: 16),
                      const Text(
                        'Trailer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildVideoSection(movie),

                      const SizedBox(height: 16),
                      const Text(
                        'Ulasan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildReviewSection(),

                      const SizedBox(height: 16),
                      const Text(
                        'Film Serupa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSimilarSection(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Section: Trailer ──
  Widget _buildVideoSection(MovieDetail movie) {
    if (movie.videos.isEmpty) {
      return const Text('Trailer tidak tersedia');
    }

    final trailer = movie.videos.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: trailer.youtubeThumbnail,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Icon(Icons.play_circle_fill, color: Colors.white, size: 56),
        ],
      ),
    );
  }

  // ── Section: Reviews ──
  Widget _buildReviewSection() {
    return FutureBuilder<ReviewResponse>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final reviews = snapshot.data!.results;

        if (reviews.isEmpty) {
          return const Text('Belum ada ulasan');
        }

        return Column(
          children: reviews.take(3).map((review) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.author,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (review.rating != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              Text(' ${review.rating}'),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ── Section: Similar Movies ──
  Widget _buildSimilarSection() {
    return FutureBuilder<MovieResponse>(
      future: _futureSimilar,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final similar = snapshot.data!.results;

        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final movie = similar[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    // Buka detail movie serupa (replace halaman saat ini)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movieId: movie.id),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      width: 110,
                      height: 160,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => Container(color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
