class VideoModel {
  final String id;
  final String key; // ID video YouTube
  final String name;
  final String site; // contoh: 'YouTube'
  final String type; // contoh: 'Trailer', 'Teaser'

  VideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }

  // URL thumbnail trailer dari YouTube
  String get youtubeThumbnail => 'https://img.youtube.com/vi/$key/0.jpg';

  // URL untuk membuka video di YouTube
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}
