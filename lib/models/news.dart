class News {
  final String title;
  final String url;
  final String imageUrl;
  final String source;
  final String publishedAt;

  News({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt
  });

  // Konversi dari JSON ke objek News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json["title"] ?? "No Title",
      url: json["url"] ?? "",
      imageUrl: json["urlToImage"] ?? "",
      source: json["source"] is Map ? // Apakah json["source"] adalah Map (dari API news) atau langsung String dari database
                json["source"]["name"] ?? "No Source" // dari API news
                : json["source"] ?? "No Source", // dari database
      publishedAt: json['publishedAt']
    );
  }
}
