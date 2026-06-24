import 'video_model.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int runtime;
  final String releaseDate;
  final List<String> genres;
  final List<VideoModel> videos;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.runtime,
    required this.releaseDate,
    required this.genres,
    required this.videos,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List? ?? [])
          .map((g) => g['name'] as String)
          .toList(),
      // Parsing nested object 'videos' -> 'results'
      videos: json['videos'] != null
          ? (json['videos']['results'] as List)
                .map((v) => VideoModel.fromJson(v))
                .toList()
          : [],
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/original$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';
}
