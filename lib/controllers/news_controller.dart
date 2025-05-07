import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constants/config.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/models/news.dart';

// Controller untuk halaman berita setiap ketegori
class NewsController extends GetxController {
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  var articles = <News>[].obs; // Menyimpan data berita yang didapat dari API
  var selectedCategory =
      'business'.obs; // Menampung kategori berita yang dipilih
  var isLoading = false.obs; // Menandakan status loading

  // Kategori berita yang akan ditampilkan
  final categories =
      <String>[
        'business',
        'entertainment',
        'health',
        'science',
        'sports',
        'technology',
      ].obs;

  // Menjalankan diawal ketika controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  // Fungsi untuk mengambil data berita dari API
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
          '$baseUrl?country=us&category=${selectedCategory.value}&apiKey=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        // Jika status code response 200 (berhasil)
        final data = jsonDecode(response.body); // Mendekode data JSON
        if (data["articles"] != null) {
          // Jika data berita tidak kosong
          articles.value = List<News>.from(
            data["articles"].map<News>((item) => News.fromJson(item)).toList(),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch news',
          backgroundColor: AppColors.errorSnackbar,
          colorText: AppColors.errorSnackbarText,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error occured: ${e.toString()}',
        backgroundColor: AppColors.errorSnackbar,
        colorText: AppColors.errorSnackbarText,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
    update();
  }

  bool isSelectedCategory(String category) {
    return selectedCategory.value == category;
  }
}
