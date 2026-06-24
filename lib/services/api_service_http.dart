import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import 'api_constants.dart';

class ApiServiceHttp {
  // 1. GET Discover Movie (list movie)
  Future<MovieResponse> getDiscoverMovies() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/discover/movie');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat data movie: ${response.statusCode}');
    }
  }

  // 2. GET Detail Movie + Videos
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/$movieId?append_to_response=videos',
    );

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail movie: ${response.statusCode}');
    }
  }

  // 3. GET Review Movie
  Future<ReviewResponse> getMovieReviews(int movieId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/movie/$movieId/reviews');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ReviewResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat review: ${response.statusCode}');
    }
  }

  // 4. GET Similar Movie
  Future<MovieResponse> getSimilarMovies(int movieId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/movie/$movieId/similar');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat similar movie: ${response.statusCode}');
    }
  }
}
