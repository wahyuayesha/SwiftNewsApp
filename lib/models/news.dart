class News {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final String publishedAt;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  // Konversi dari JSON ke objek News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json["title"] ?? "Tanpa Judul",
      description: json["description"] ?? "Deskripsi tidak tersedia",
      url: json["url"] ?? "",
      imageUrl: json["urlToImage"] ?? "",
      source: json["source"]["name"] ?? "Tidak diketahui",
      publishedAt: json["publishedAt"] ?? "",
    );
  }
}

