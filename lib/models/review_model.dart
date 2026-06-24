class ReviewModel {
  final String id;
  final String author;
  final String content;
  final double? rating;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.author,
    required this.content,
    this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      rating: json['author_details'] != null
          ? (json['author_details']['rating'] as num?)?.toDouble()
          : null,
      createdAt: json['created_at'] ?? '',
    );
  }
}

// Model untuk membungkus response list review
class ReviewResponse {
  final int page;
  final List<ReviewModel> results;
  final int totalPages;
  final int totalResults;

  ReviewResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List)
          .map((item) => ReviewModel.fromJson(item))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
