class News {
  final String title;
  final String url;
  final String imageUrl;
  final String source;

  News({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.source,
  });

  // Konversi dari JSON ke objek News 
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json["title"] ?? "Tanpa Judul",
      url: json["url"] ?? "",
      imageUrl: json["urlToImage"] ?? "",
      source: json["source"] is Map // Apakah json["source"] adalah Map (dari API news) atau langsung String dari database 
          ? json["source"]["name"] ?? "Tanpa Sumber" // dari API news
          : json["source"] ?? "Tanpa Sumber", // dari database
    );
  }
}

