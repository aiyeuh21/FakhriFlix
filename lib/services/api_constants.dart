class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original';

  // Ganti dengan API Read Access Token milik Anda
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMGNkODkzOTIzMDBhYTNiMzA2YjFmY2VkYzg4ZDI4MiIsIm5iZiI6MTc4MjMwNTI0MS45MTM5OTk4LCJzdWIiOiI2YTNiZDFkOWI3M2ZlYzkwYjJjNTdiM2IiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.L-c1gidy045lO35eBqnsv4Q1LCKce8ENmAf9zsFXrW8';

  static Map<String, String> get headers => {
    'Authorization': 'Bearer $bearerToken',
    'Content-Type': 'application/json;charset=utf-8',
  };
}
