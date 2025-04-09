import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/news.dart';

class HomeController extends GetxController {
  final String apiKey = '98e2970c9bf743c39593289b599c394d';
  final String baseUrl = 'https://newsapi.org/v2';

  var topHeadlines = <News>[].obs; // Variabel untuk berita utama
  var popularNews = <News>[].obs; // Variabel untuk berita populer
  var isLoading = false.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchNews(type: 'top-headlines'); // Ambil berita top
    fetchNews(type: 'everything', sortBy: 'popularity'); // Ambil berita populer
  }

  Future<void> fetchNews({required String type, String? sortBy, String? query}) async {
    try {
      isLoading.value = true;
      Uri url;

      if (type == 'top-headlines') {
        url = Uri.parse("$baseUrl/top-headlines?country=us&apiKey=$apiKey");
      } else {
        url = Uri.parse("$baseUrl/everything?q=${query ?? 'trending'}&sortBy=$sortBy&apiKey=$apiKey");
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["articles"] != null) {
          var articles = List<News>.from(
            data["articles"].map<News>((item) => News.fromJson(item)).toList()
          );

          if (type == 'top-headlines') {
            topHeadlines.value = articles;
          } else {
            popularNews.value = articles;
          }
        }
      } else {
        Get.snackbar('Error', 'Gagal mengambil data berita');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
